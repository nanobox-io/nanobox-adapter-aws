module ::EC2
  
  DEFAULT_REGION = 'us-east-1'
  
  REGIONS = {
    'us-east-1' => {
      id: 'us-east-1', 
      name: 'US East (N. Virginia)',
      short: 'N. Virginia',
      availability_zones: [
        'us-east-1a',
        'us-east-1b',
        'us-east-1d',
        'us-east-1e'
      ],
      ami: 'ami-6edd3078'
    },
    'us-east-2' => {
      id: 'us-east-2',
      name: 'US East (Ohio)',
      short: 'Ohio',
      availability_zones: [
        'us-east-2a',
        'us-east-2b',
        'us-east-2c'
      ],
      ami: 'ami-fcc19b99'
    },
    'us-west-1' => {
      id: 'us-west-1',
      name: 'US West (N. California)',
      short: 'N. California',
      availability_zones: [
        'us-west-1b',
        'us-west-1c'
      ],
      ami: 'ami-539ac933'
    },
    'us-west-2' => {
      id: 'us-west-2',
      name: 'US West (Oregon)',
      short: 'Oregon',
      availability_zones: [
        'us-west-2a',
        'us-west-2b',
        'us-west-2c'
      ],
      ami: 'ami-7c803d1c'
    },
    'ca-central-1' => {
      id: 'ca-central-1',
      name: 'Canada Central (Montreal)',
      short: 'Central',
      availability_zones: [
        'ca-central-1a',
        'ca-central-1b'
      ],
      ami: 'ami-3d299b59'
    },
    'eu-west-1' => {
      id: 'eu-west-1',
      name: 'EU West (Ireland)',
      short: 'Ireland',
      availability_zones: [
        'eu-west-1a',
        'eu-west-1b',
        'eu-west-1c'
      ],
      ami: 'ami-d8f4deab'
    },
    'eu-central-1' => {
      id: 'eu-central-1',
      name: 'EU Central (Frankfurt)',
      short: 'Frankfurt',
      availability_zones: [
        'eu-central-1a',
        'eu-central-1b'
      ],
      ami: 'ami-5aee2235'
    },
    'eu-west-2' => {
      id: 'eu-west-2',
      name: 'EU West (London)',
      short: 'London',
      availability_zones: [
        'eu-west-2a',
        'eu-west-2b'
      ],
      ami: 'ami-ede2e889'
    },
    'ap-southeast-1' => {
      id: 'ap-southeast-1',
      name: 'Asia Pacific (Singapore)',
      short: 'Singapore',
      availability_zones: [
        'ap-southeast-1a',
        'ap-southeast-1b'
      ],
      ami: 'ami-b1943fd2'
    },
    'ap-southeast-2' => {
      id: 'ap-southeast-2',
      name: 'Asia Pacific (Sydney)',
      short: 'Sydney',
      availability_zones: [
        'ap-southeast-2a',
        'ap-southeast-2b',
        'ap-southeast-2c'
      ],
      ami: 'ami-fe71759d'
    },
    'ap-northeast-2' => {
      id: 'ap-northeast-2',
      name: 'Asia Pacific (Seoul)',
      short: 'Seoul',
      availability_zones: [
        'ap-northeast-2a',
        'ap-northeast-2c'
      ],
      ami: 'ami-93d600fd'
    },
    'ap-northeast-1' => {
      id: 'ap-northeast-1',
      name: 'Asia Pacific (Tokyo)',
      short: 'Tokyo',
      availability_zones: [
        'ap-northeast-1a',
        'ap-northeast-1c'
      ],
      ami: 'ami-eb49358c'
    },
    'ap-south-1' => {
      id: 'ap-south-1',
      name: 'Asia Pacific (Mumbai)',
      short: 'Mumbai',
      availability_zones: [
        'ap-south-1a',
        'ap-south-1b'
      ],
      ami: 'ami-dd3442b2'
    },
    'sa-east-1' => {
      id: 'sa-east-1',
      name: 'South America (São Paulo)',
      short: 'São Paulo',
      availability_zones: [
        'sa-east-1a',
        'sa-east-1b',
        'sa-east-1c'
      ],
      ami: 'ami-7379e31f'
    }
  }
  
end
