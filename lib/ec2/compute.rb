
class ::EC2::Compute
  
  attr_reader :manager
  
  def initialize(manager)
    @manager = manager
  end
  
  def instances
    list = []
    
    # filter the collection to just nanobox instances
    # todo: probably should filter to just the app instances
    filter = [{'Name'  => 'tag:Nanobox', 'Value' => 'true'}]
    
    # query the api
    # res = manager.DescribeInstances('Filter' => filter)
    res = manager.DescribeInstances()
    
    # extract the instance collection
    instances = res["DescribeInstancesResponse"]["reservationSet"]

    # short-circuit if the collection is empty
    return [] if instances.nil?
    
    # grab the instances and process them
    instances["item"].each do |instances|
      list << process_instance(instances["instancesSet"]["item"])
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
  def run_instance(attrs)
    manager.RunInstances(
      'ImageId'            => 'ami-b7a114d7',
      'MinCount'           => 1,
      'MaxCount'           => 1,
      'KeyName'            => 'test-ubuntu',
      'InstanceType'       => 't2.micro',
      'SecurityGroupId'    => ['sg-2d00d248'],
      'Placement'          => {
         'AvailabilityZone' => 'us-west-2a',
         'Tenancy'          => 'default' },
      'BlockDeviceMapping' => [
        { 'DeviceName' => '/dev/sda1',
          'Ebs'        => {
           'VolumeSize'          => 10,
           'DeleteOnTermination' => true}} ]
    )
  end
  
  private
  
  def process_instance(data)
    {
      id: data['instanceId'],
      name: (process_tag(data['tagSet']['item'], 'Nanobox-Name') rescue ''),
      status: data['instanceState']['name'],
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
end
