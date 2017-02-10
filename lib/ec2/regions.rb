module ::EC2
  
  DEFAULT_REGION = 'us-east-1'
  
  REGIONS = {
    'us-east-1' => {
      id: 'us-east-1', 
      name: 'US East (N. Virginia)',
      short: 'N. Virginia',
      ami: 'ami-6edd3078'
    },
    'us-east-2' => {
      id: 'us-east-2',
      name: 'US East (Ohio)',
      short: 'Ohio',
      ami: 'ami-fcc19b99'
    },
    'us-west-1' => {
      id: 'us-west-1',
      name: 'US West (N. California)',
      short: 'N. California',
      ami: 'ami-539ac933'
    },
    'us-west-2' => {
      id: 'us-west-2',
      name: 'US West (Oregon)',
      short: 'Oregon',
      ami: 'ami-7c803d1c'
    },
    'ca-central-1' => {
      id: 'ca-central-1',
      name: 'Canada Central (Montreal)',
      short: 'Central',
      ami: 'ami-3d299b59'
    },
    'eu-west-1' => {
      id: 'eu-west-1',
      name: 'EU West (Ireland)',
      short: 'Ireland',
      ami: 'ami-d8f4deab'
    },
    'eu-central-1' => {
      id: 'eu-central-1',
      name: 'EU Central (Frankfurt)',
      short: 'Frankfurt',
      ami: 'ami-5aee2235'
    },
    'eu-west-2' => {
      id: 'eu-west-2',
      name: 'EU West (London)',
      short: 'London',
      ami: 'ami-ede2e889'
    },
    'ap-southeast-1' => {
      id: 'ap-southeast-1',
      name: 'Asia Pacific (Singapore)',
      short: 'Singapore',
      ami: 'ami-b1943fd2'
    },
    'ap-southeast-2' => {
      id: 'ap-southeast-2',
      name: 'Asia Pacific (Sydney)',
      short: 'Sydney',
      ami: 'ami-fe71759d'
    },
    'ap-northeast-2' => {
      id: 'ap-northeast-2',
      name: 'Asia Pacific (Seoul)',
      short: 'Seoul',
      ami: 'ami-93d600fd'
    },
    'ap-northeast-1' => {
      id: 'ap-northeast-1',
      name: 'Asia Pacific (Tokyo)',
      short: 'Tokyo',
      ami: 'ami-eb49358c'
    },
    'ap-south-1' => {
      id: 'ap-south-1',
      name: 'Asia Pacific (Mumbai)',
      short: 'Mumbai',
      ami: 'ami-dd3442b2'
    },
    'sa-east-1' => {
      id: 'sa-east-1',
      name: 'South America (São Paulo)',
      short: 'São Paulo',
      ami: 'ami-7379e31f'
    }
  }
  
end
