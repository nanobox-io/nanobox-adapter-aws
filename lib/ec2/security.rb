require 'right_aws_api'

class ::EC2::Security

  attr_reader :manager

  def initialize(manager)
    @manager = manager
    @vpc_id = get_vpc_id
  end

  def permission?
    begin
      manager.DescribeSecurityGroups('DryRun' => true)
      manager.CreateSecurityGroup('DryRun' => true)
    rescue RightScale::CloudApi::HttpError => e
      if not e.message =~ /DryRunOperation/
        raise
      end
    end
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
    filter     = [
      {'Name' => 'group-name', 'Value' => 'Nanobox'},
      {'Name' => 'vpc-id', 'Value' => @vpc_id}
    ]
    res        = manager.DescribeSecurityGroups('Filter' => filter)
    group_info = res["DescribeSecurityGroupsResponse"]["securityGroupInfo"]

    return nil unless group_info

    group = group_info["item"]

    {
      id:           group["groupId"],
      name:         group["groupName"],
      description:  group["groupDescription"],
      inbound:      !group["ipPermissions"].nil?,
      outbound:     !group["ipPermissionsEgress"].nil?,
      vpc_id:       group["vpcId"]
    }
  end

  def create_group
    res = manager.CreateSecurityGroup(
      'GroupDescription' => 'Simple security group policy for Nanobox apps.',
      'GroupName' => 'Nanobox',
      'VpcId' => @vpc_id
    )

    fetch_group
  end

  def get_vpc_id
    # Retrieve the default VPC.
    # If needed, fall back to the first non-default VPC.
    # If _still_ needed, fall back to creating a new VPC.
    res = manager.DescribeVpcs(
      'Filter' => [
        {'Name' => 'state', 'Value' => 'available'},
        {'Name' => 'isDefault', 'Value' => true}
      ]
    )
    vpc_info = res["DescribeVpcsResponse"]["vpcSet"]

    if not vpc_info
      res = manager.DescribeVpcs(
        'Filter' => [
          {'Name' => 'state', 'Value' => 'available'}
        ]
      )
      vpc_info = res["DescribeVpcsResponse"]["vpcSet"]

      if not vpc_info
        res = manager.CreateVpc('CidrBlock' => '10.10.0.0/16')
        vpc_id = res["CreateVpcResponse"]["vpc"]["vpcId"]

        res = manager.CreateSubnet(
          'CidrBlock' => '10.10.0.0/16',
          'VpcId' => vpc_id
        )

        vpc_id
      else
        vpc_info["item"][0]["vpcId"]
      end
    else
      vpc_info["item"]["vpcId"]
    end
  end

  def set_inbound_policy(id)
    begin
      res = manager.AuthorizeSecurityGroupIngress(
        'GroupId'     => id,
        'IpProtocol'  => '-1',
        'FromPort'    => '-1',
        'CidrIp'      => '0.0.0.0/0'
      )
    rescue RightScale::CloudApi::HttpError => e
      if not e.message =~ /InvalidPermission\.Malformed/
        raise
      end

      # add inbound policies for tcp and udp
      ['tcp', 'udp'].each do |protocol|
        manager.AuthorizeSecurityGroupIngress(
          'GroupId'                           => id,
          'IpPermissions.1.IpProtocol'        => protocol,
          'IpPermissions.1.FromPort'          => '0',
          'IpPermissions.1.ToPort'            => '65535',
          'IpPermissions.1.IpRanges.1.CidrIp' => '0.0.0.0/0'
        )
      end

      # now allow icmp (ping)
      manager.AuthorizeSecurityGroupIngress(
        'GroupId'                           => id,
        'IpPermissions.1.IpProtocol'        => 'icmp',
        'IpPermissions.1.FromPort'          => '-1',
        'IpPermissions.1.ToPort'            => '-1',
        'IpPermissions.1.IpRanges.1.CidrIp' => '0.0.0.0/0'
      )
    end
  end

  def set_outbound_policy(id)
    begin
      res = manager.AuthorizeSecurityGroupEgress(
        'GroupId'     => id,
        'IpProtocol'  => '-1',
        'ToPort'      => '-1',
        'CidrIp'      => '0.0.0.0/0'
      )
    rescue RightScale::CloudApi::HttpError => e
      if not e.message =~ /InvalidPermission\.Malformed|UnknownParameter/
        raise
      end

      # add outbound policy for tcp and udp
      ['tcp', 'udp'].each do |protocol|
        manager.AuthorizeSecurityGroupEgress(
          'GroupId'                           => id,
          'IpPermissions.1.IpProtocol'        => protocol,
          'IpPermissions.1.FromPort'          => '0',
          'IpPermissions.1.ToPort'            => '65535',
          'IpPermissions.1.IpRanges.1.CidrIp' => '0.0.0.0/0'
        )
      end

      # now allow outbound icmp (ping)
      manager.AuthorizeSecurityGroupEgress(
        'GroupId'                           => id,
        'IpPermissions.1.IpProtocol'        => 'icmp',
        'IpPermissions.1.FromPort'          => '-1',
        'IpPermissions.1.ToPort'            => '-1',
        'IpPermissions.1.IpRanges.1.CidrIp' => '0.0.0.0/0'
      )
    end
  end

end
