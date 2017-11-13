require 'faraday'

class ::EC2::Catalog

  ASSET_FILE = File.expand_path('../../assets/catalog.json', __FILE__)
  CACHE_FILE = File.expand_path('../../assets/cache.json', __FILE__)

  class << self
    def fetch
      begin
        ::File.read ASSET_FILE
      rescue
        nil
      end
    end

    def cache
      @cache ||= begin
        begin
          JSON.parse(::File.read CACHE_FILE)
        rescue
          nil
        end
      end
    end

    def generate
      # The plan of attack:
      #
      # aws ec2 instance size catalog is pretty exhaustive. After digging around
      # the api, it became apparent that the pricing api was going to be a bit
      # ridiculous. The raw csv file alone was nearly 100MB. So I needed to find
      # a different way...
      #
      # http://www.ec2instances.info is a pretty cool service that will scrape
      # the aws pricing from amazon's website from time-to-time. They even
      # provide this information via a nice json api: /instances.json
      #
      # The challenge here is that the data from this service is structured
      # completely opposite to how the nanobox catalog needs to be structured.
      # So essentially we fetch the data, iterate over the data and construct
      # the data set according to how we need it to be.
      #
      # At first the data is structured into hashes instead of lists. We convert
      # the hashes to lists last, because while we're constructing the dataset,
      # it's much easier and quicker to reference keys in a hash than to iterate
      # through a list each time.
      #
      # Also, whenever a server is ordered, we'll need to lookup the disk size
      # according to the algorithm determined here. So while we're generating
      # the catalog, we'll also generate a simple mapping that can make the
      # lookup really fast.
      #
      # Here we go...

      # grab the ec2 instances pricing structure dump
      options = self.ec2_instances_info

      # grab the ebs prices
      ebs_prices = self.ebs_prices

      # first setup the datacenter region structures (later, we'll convert to a list)
      dcs = {}

      # the cache map for storing size -> resources to be looked up on order
      map = {}

      ::EC2::REGIONS.each_pair do |id, region|
        dcs[id] = {
          id: id,
          name: region[:name],
          plans: {} # (later we'll convert this to a list)
        }
      end

      # now let's iterate through the dump data and set plans
      # pricing -> ap-south-1 -> linux -> ondemand
      options.each do |option|
        option['pricing'].each_pair do |region, platform|

          # extract the pieces
          family        = option['family']
          family_id     = family.downcase.gsub(/ /, '_')
          instance_type = option['instance_type']
          cpus          = option['vCPU'].to_f / 4
          memory        = (option['memory'] * 1024).to_i
          disk          = calculate_disk(memory)
          hourly_price  = platform['linux']['ondemand'].to_f rescue 'N/A'
          monthly_price = hourly_price * 720 rescue 'N/A'

          # if this is micro, let's combine with General purpose
          if family_id == 'micro'
            family    = 'General purpose'
            family_id = 'general_purpose'
          end

          # let's skip GPU
          if family_id == 'gpu_instances'
            next
          end

          # adjust the hourly/monthly prices to reflect disk prices
          if hourly_price != 'N/A'
            hourly_price = hourly_price + disk * ebs_prices[region][:hourly]
            monthly_price = monthly_price + disk * ebs_prices[region][:monthly]
          end

          # short-circuit if there's no pricing for this plan
          if hourly_price == 'N/A'
            next
          end

          # grab the datacenter
          dc = dcs[region]

          # if we stumble upon a region that we don't support (gov) then move on
          if dc.nil?
            next
          end

          # grab the existing plan or create a new one
          plan = begin
            dc[:plans][family_id] || {
              id: family_id,
              name: family,
              specs: []
            }
          end

          # create the spec
          spec = {
            id: instance_type,
            ram: memory,
            cpu: cpus,
            disk: disk,
            transfer: 'unlimited',
            dollars_per_hr: '%.3f' % hourly_price,
            dollars_per_mo: '%.2f' % monthly_price
          }

          # add the spec to the plan
          plan[:specs] << spec

          # add the plan back to the dc
          dc[:plans][family_id] = plan

          # let's also populate the cache map
          if not map.has_key? instance_type
            map[instance_type] = {
              disk: disk,
              hvm: option['linux_virtualization_types'].include?('HVM')
            }
          end
        end
      end

      # convert regions/plans from hashes to lists for the final catalog
      catalog = []

      dcs.each_pair do |_key, dc|
        plans = []

        dc[:plans].each_pair do |_id, plan|
          plans << plan
        end

        dc[:plans] = plans

        catalog << dc
      end

      # write the catalog
      ::File.write ASSET_FILE, catalog.to_json

      # write the cache
      ::File.write CACHE_FILE, map.to_json
    end

    protected

    def ec2_instances_info
      conn = Faraday.new(:url => 'https://www.ec2instances.info')
      res = conn.get '/instances.json'
      JSON.parse res.body
    end

    def ebs_prices
      # So this is a bit of a trick... Since aws pricing is a nightmare to extract
      # we're just going to pull the javascript (which is essentially JSON) that
      # they load into their html price selector. We do have to strip some junk
      # out of the document before we can parse the json though.
      conn = Faraday.new(:url => 'https://a0.awsstatic.com')
      res = conn.get '/pricing/1/ebs/pricing-ebs.js'

      data = JSON.parse(res.body.match(/callback\(\n(.*)\n\);/)[1])

      prices = {}

      data["config"]["regions"].each do |region|
        monthly_price = region["types"].first["values"].first["prices"]["USD"].to_f
        hourly_price = monthly_price / 720

        prices[region["region"]] = {
          hourly: hourly_price,
          monthly: monthly_price
        }
      end

      prices
    end

    def calculate_disk(mbs)
      # == Standard ==
      # 512MB 20
      # 1G    30
      # 2G    40
      # 4G    60
      # 8G    80
      # 16G   160
      # 32G   320
      # 48G   480
      # 64G   640
      #
      # == High RAM ==
      # 16   30 1.875
      # 32   90 2.8
      # 64   200
      # 128  340
      # 224  500

      # For now, let's keep it simple and just use the standard multiplier
      # for all plans. Later, we can determine the slope equation for High RAM
      # tiers.

      gbs = mbs / 1024

      if gbs < 1
        return 20
      end

      if gbs < 2
        return 30
      end

      if gbs < 4
        return 40
      end

      if gbs < 8
        return 60
      end

      gbs * 10
    end
  end
end
