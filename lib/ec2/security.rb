require 'right_aws_api'

class ::EC2::Security
  
  attr_reader :manager
  
  def initialize(manager)
    @manager = manager
  end
  
  def group
    # fetch the group
    sg = fetch_group || create_group
    
    # short-circuit if we don't have a group by now
    return nil unless sg
    
    # ensure the inbound rules are set
    if not sg[:inbound]
      set_inbound_policy sg[:id]
    end
    
    # ensure the oubound rules are set
    if not sg[:outbound]
      set_outbound_policy sg[:id]
    end
    
    sg
  end
  
  private
  
  def fetch_group
    filter     = [{'Name' => 'group-name', 'Value' => 'Nanobox'}]
    res        = manager.DescribeSecurityGroups('Filter' => filter)
    group_info = res["DescribeSecurityGroupsResponse"]["securityGroupInfo"]
    
    return nil unless group_info
    
    group = group_info["item"]
    
    {
      id:           group["groupId"],
      name:         group["groupName"],
      description:  group["groupDescription"],
      inbound:      !group["ipPermissions"].nil?,
      outbound:     !group["ipPermissionsEgress"].nil?
    }
  end
  
  def create_group
    res = manager.CreateSecurityGroup(
      'GroupDescription' => 'Simple security group policy for Nanobox apps.',
      'GroupName' => 'Nanobox'
    )
    
    fetch_group
  end
  
  def set_inbound_policy(id)
    res = manager.AuthorizeSecurityGroupIngress(
      'GroupId'     => id,
      'IpProtocol'  => '-1',
      'FromPort'    => '-1',
      'CidrIp'      => '0.0.0.0/0'
    )
  end
  
  def set_outbound_policy(id)
    res = manager.AuthorizeSecurityGroupEgress(
      'GroupId'     => id,
      'IpProtocol'  => '-1',
      'ToPort'      => '-1',
      'CidrIp'      => '0.0.0.0/0'
    )
  end
  
end
