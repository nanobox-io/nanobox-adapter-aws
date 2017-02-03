require 'right_aws_api'

class ::EC2::SSH
  
  attr_reader :manager
  
  def initialize(manager)
    @manager = manager
  end
  
  def permission?
    begin
      manager.DescribeKeyPairs('DryRun' => true)
      manager.ImportKeyPair('DryRun' => true)
      manager.DeleteKeyPair('DryRun' => true)
    rescue RightScale::CloudApi::HttpError => e
      if not e.message =~ /DryRunOperation/
        raise
      end
    end
  end
  
  def keys
    res = manager.DescribeKeyPairs()

    key_set = res["DescribeKeyPairsResponse"]["keySet"]
    
    # instances might not be a collection, but a single item
    collection = begin
      if key_set['item'].is_a? Array
        key_set['item']
      else
        [key_set['item']]
      end
    end
    
    keys = []
    
    collection.each do |key|
      keys << process_key(key)
    end
    
    keys
  end
  
  def key(id)
    # filter the collection by key-name
    filter = [{'Name' => 'key-name', 'Value' => id}]
    
    res = manager.DescribeKeyPairs('Filter' => filter)
    
    # extract the keys collection
    keys = res["DescribeKeyPairsResponse"]["keySet"]
    
    # short-circuit if the collection is empty
    return nil if keys.nil?
    
    process_key(keys["item"])
  end
  
  def import_key(name, material)
    res = manager.ImportKeyPair(
      'KeyName'           => name,
      'PublicKeyMaterial' => ::RightScale::CloudApi::Utils::base64en(material)
    )
    
    process_key(res["ImportKeyPairResponse"])
  end
  
  def delete_key(id)
    res = manager.DeleteKeyPair(
      'KeyName' => id
    )
    
    res["DeleteKeyPairResponse"]["return"] == "true"
  end
  
  private
  
  def process_key(data)
    {
      id:           data["keyName"],
      name:         data["keyName"],
      fingerprint:  data["keyFingerprint"]
    }
  end
  
end
