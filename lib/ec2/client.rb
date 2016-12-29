require 'right_aws_api'

class ::EC2::Client
  
  attr_reader :key_id
  attr_reader :access_key
  attr_reader :endpoint
  
  def initialize(key_id, access_key, endpoint)
    @key_id     = key_id
    @access_key = access_key
    @endpoint   = endpoint
  end
  
  def verify
    "yes"
  end
  
  def keys
    
  end
  
  def key(id)
    
  end
  
  def key_create(id, public_key)
    
  end
  
  def key_delete(id)
    
  end
  
  def servers
    compute = ::EC2::Compute.new(manager)
    compute.instances
  end
  
  def server(id)
    compute = ::EC2::Compute.new(manager)
    compute.instance(id)
  end
  
  # Order a server to run on AWS
  # 
  # attrs:
  #   name:     Nanobox-generated name
  #   region:   the region wherein to launch the server
  #   size:     the size of server to provision
  #   ssh_key:  id of the SSH key
  def server_order(attrs)
    # lookup the disk size from the 'size' in catalog
    
    # find or create a nanobox security group
    
    compute = ::EC2::Compute.new(manager)
    compute.run_instance(attrs)
  end
  
  def server_delete(id)
    
  end
  
  def server_reboot(id)
    
  end
  
  def server_rename(id, name)
    
  end
  
  protected
  
  def manager
    @manager ||= begin
      ::RightScale::CloudApi::AWS::EC2::Manager.new(key_id, access_key, endpoint_uri)
    end
  end
  
  def endpoint_uri
    "https://ec2.#{endpoint}.amazonaws.com"
  end
  
end
