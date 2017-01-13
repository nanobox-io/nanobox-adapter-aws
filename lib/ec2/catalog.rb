require 'faraday'

module ::EC2::Catalog

  def self.fetch
    
  end
  
  def self.generate
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
    # Here we go...
    
    # grab the ec2 instances pricing structure dump
    plans = self.ec2_instances_info
    
    # first setup the datacenter region structures (later, we'll convert to a list)
    regions = {}
    
    ::EC2::REGIONS.each do |region|
      regions[region[:id]] = {
        id: region[:id],
        name: region[:name],
        plans: {} # (later we'll convert this to a list)
      }
    end
    
    # now let's iterate through the dump data and set plans
    plans.each do |plan|
      plan['pricing'].each_pair do |region, platform|
        
        # extract the pieces
        family        = plan['family']
        family_name   = plan['pretty_name']
        instance_type = plan['instance_type']
        vcpu          = plan['vCPU']
        memory        = plan['memory']
        hourly_price  = platform['linux']['ondemand'] rescue 'N/A'
        
        # short-circuit if there's no pricing for this plan
        if hourly_price == 'N/A'
          next
        end
        
        # 1 - add the plan (Family) to the regions dataset if it doesn't exist
        if regions[region][:plans][region].nil?
          
        end
        
      end
    end
    
    regions
  end
  
  protected
  
  def self.ec2_instances_info
    conn = Faraday.new(:url => 'http://www.ec2instances.info')
    res = conn.get '/instances.json'
    JSON.parse res.body
  end
  
end
