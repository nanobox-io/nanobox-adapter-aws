require 'right_aws_api'

class ::EC2::Compute

  attr_reader :manager

  def initialize(manager)
    @manager = manager
  end

  def permission?
    begin
      manager.DescribeInstances('DryRun' => true)
      manager.RunInstances('DryRun' => true)
      manager.TerminateInstances('DryRun' => true)
    rescue RightScale::CloudApi::HttpError => e
      if not e.message =~ /DryRunOperation/
        raise
      end
    end
  end

  def instances
    list = []

    # filter the collection to just nanobox instances
    filter = [{'Name'  => 'tag:Nanobox', 'Value' => 'true'}]

    # query the api
    res = manager.DescribeInstances('Filter' => filter)

    # extract the instance collection
    instances = res["DescribeInstancesResponse"]["reservationSet"]

    # short-circuit if the collection is empty
    return [] if instances.nil?

    # instances might not be a collection, but a single item
    collection = begin
      if instances['item'].is_a? Array
        instances['item']
      else
        [instances['item']]
      end
    end

    # grab the instances and process them
    collection.each do |instance|
      list << process_instance(instance["instancesSet"]["item"])
    end

    list
  end

  def instance(id)
    # query the api
    res = manager.DescribeInstances('InstanceId' => id)

    # extract the instance collection
    instances = res["DescribeInstancesResponse"]["reservationSet"]

    # short-circuit if the collection is empty
    return nil if instances.nil?

    # grab the fist instance and process it
    process_instance(instances["item"]["instancesSet"]["item"])
  end

  # Run an on-demand compute instance
  #
  # attrs:
  #   name:               nanobox-specific name of instance
  #   size:               instance type/size (t2.micro etc)
  #   disk:               size of disk for ebs volume
  #   ami:                amazon machine image to use to launch instance
  #   availability_zone:  availability zone to run instance on
  #   key:                id of ssh key
  #   security_group:     id of security group
  #   vpc:                id of VPC
  def run_instance(attrs)

    # launch the instance
    res = manager.RunInstances(
      'ImageId'            => attrs[:ami],
      'MinCount'           => 1,
      'MaxCount'           => 1,
      'KeyName'            => attrs[:key],
      'InstanceType'       => attrs[:size],
      'SecurityGroupId'    => [attrs[:security_group]],
      'SubnetId'           => get_subnet(attrs[:vpc], attrs[:availability_zone])['subnetId'],
      'Placement'          => {
        'AvailabilityZone' => attrs[:availability_zone],
        'Tenancy'          => 'default'
      },
      'BlockDeviceMapping' => [
        {
          'DeviceName' => '/dev/sda1',
          'Ebs'        => {
            'VolumeType'          => 'gp2',
            'VolumeSize'          => attrs[:disk],
            'DeleteOnTermination' => true
          }
        }
      ]
    )

    # extract the instance
    instance = process_instance(res["RunInstancesResponse"]["instancesSet"]["item"])

    # name the instance
    set_instance_name(instance[:id], attrs[:name])

    # now update the name and return it
    instance.tap do |i|
      i[:name] = attrs[:name]
    end
  end

  def reboot_instance(id)
    res = manager.RebootInstances( "InstanceId" => id )
  end

  def terminate_instance(id)
    # todo: catch error?
    res = manager.TerminateInstances( "InstanceId" => id )
    res["TerminateInstancesResponse"]["instancesSet"]["item"]["currentState"]["name"]
  end

  def set_instance_name(id, name)
    # set tags
    res = manager.CreateTags(
      'ResourceId'  => id,
      'Tag' => [
        {
          'Key' => 'Nanobox',
          'Value' => 'true'
        },
        {
          'Key' => 'Name',
          'Value' => name
        },
        {
          'Key' => 'Nanobox-Name',
          'Value' => name
        }
      ]
    )
  end

  def availability_zones
    # Ultimately, we only want the availability_zones that are available to
    # this account AND have a default subnet. Querying the subnets for
    # default-for-az finds this list pretty quickly

    # filter the collection to just nanobox instances
    filter = [{'Name'  => 'default-for-az', 'Value' => 'true'}]

    # query the api
    res = manager.DescribeSubnets('Filter' => filter)

    subnets = res['DescribeSubnetsResponse']['subnetSet']

    # if we don't have any default subnets, let's return an empty set
    return [] if subnets.nil?

    # subnets might not be a collection, but a single item
    collection = begin
      if subnets['item'].is_a? Array
        subnets['item']
      else
        [subnets['item']]
      end
    end

    availability_zones = []

    collection.each do |subnet|
      availability_zones << subnet['availabilityZone']
    end

    availability_zones.uniq.sort
  end

  private

  def get_subnet(vpc, az)
    res = manager.DescribeSubnets(
      'Filter' => [
        {'Name'  => 'availability-zone', 'Value' => az},
        {'Name'  => 'vpc-id', 'Value' => vpc}
      ]
    )

    subnets = res['DescribeSubnetsResponse']['subnetSet']

    if not subnets
      return create_subnet(vpc, az)
    end

    subnet = begin
      if subnets['item'].is_a? Array
        subnets['item'][0]
      else
        subnets['item']
      end
    end

    subnet
  end

  def create_subnet(vpc, az)
    network = az.nil? ? 72 : {
      'a' =>  0, 'b' =>  2, 'c' =>  4, 'd' =>  6, 'e' =>  8, 'f' => 10,
      'g' => 12, 'h' => 14, 'i' => 16, 'j' => 18, 'k' => 20, 'l' => 22,
      'm' => 24, 'n' => 26, 'o' => 28, 'p' => 30, 'q' => 32, 'r' => 34,
      's' => 26, 't' => 38, 'u' => 40, 'v' => 42, 'w' => 44, 'x' => 46,
      'y' => 48, 'z' => 50, '0' => 52, '1' => 54, '2' => 56, '3' => 58,
      '4' => 60, '5' => 62, '6' => 64, '7' => 66, '8' => 68, '9' => 70,
    }[az[-1,1]]

    res = manager.DescribeVpcs(
      'Filter' => [
        {'Name'  => 'vpc-id', 'Value' => vpc}
      ]
    )
    block = res["DescribeVpcsResponse"]["vpcSet"]["item"]["cidrBlock"]
    prefix = /^(\d+\.\d+)\./.match(block)[1]

    res = manager.CreateSubnet(
      'AvailabilityZone' => az,
      'VpcId' => vpc,
      'CidrBlock' => "#{prefix}.#{network}.0/24"
    )

    get_subnet(vpc, az)
  end

  def process_instance(data)
    {
      id: data['instanceId'],
      name: (process_tag(data['tagSet']['item'], 'Nanobox-Name') rescue 'unknown'),
      status: translate_status(data['instanceState']['name']),
      external_ip: data['ipAddress'],
      internal_ip: data['privateIpAddress']
    }
  end

  def process_tag(tags, key)
    tags.each do |tag|
      if tag['key'] == key
        return tag['value']
      end
    end
    ''
  end

  def translate_status(status)
    case status
    when 'running'
      'active'
    else
      status
    end
  end

end
