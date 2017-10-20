module ::EC2
  
  DEFAULT_REGION = 'us-east-1'
  
  REGIONS = {
    'us-east-1' => {
      id: 'us-east-1', 
      name: 'US East (N. Virginia)',
      short: 'N. Virginia',
      ami: 'ami-cd0f5cb6'
    },
    'us-east-2' => {
      id: 'us-east-2',
      name: 'US East (Ohio)',
      short: 'Ohio',
      ami: 'ami-10547475'
    },
    'us-west-1' => {
      id: 'us-west-1',
      name: 'US West (N. California)',
      short: 'N. California',
      ami: 'ami-09d2fb69'
    },
    'us-west-2' => {
      id: 'us-west-2',
      name: 'US West (Oregon)',
      short: 'Oregon',
      ami: 'ami-6e1a0117'
    },
    'ca-central-1' => {
      id: 'ca-central-1',
      name: 'Canada Central (Montreal)',
      short: 'Central',
      ami: 'ami-b3d965d7'
    },
    'eu-west-1' => {
      id: 'eu-west-1',
      name: 'EU West (Ireland)',
      short: 'Ireland',
      ami: 'ami-785db401'
    },
    'eu-central-1' => {
      id: 'eu-central-1',
      name: 'EU Central (Frankfurt)',
      short: 'Frankfurt',
      ami: 'ami-1e339e71'
    },
    'eu-west-2' => {
      id: 'eu-west-2',
      name: 'EU West (London)',
      short: 'London',
      ami: 'ami-996372fd'
    },
    'ap-southeast-1' => {
      id: 'ap-southeast-1',
      name: 'Asia Pacific (Singapore)',
      short: 'Singapore',
      ami: 'ami-6f198a0c'
    },
    'ap-southeast-2' => {
      id: 'ap-southeast-2',
      name: 'Asia Pacific (Sydney)',
      short: 'Sydney',
      ami: 'ami-e2021d81'
    },
    'ap-northeast-2' => {
      id: 'ap-northeast-2',
      name: 'Asia Pacific (Seoul)',
      short: 'Seoul',
      ami: 'ami-d28a53bc'
    },
    'ap-northeast-1' => {
      id: 'ap-northeast-1',
      name: 'Asia Pacific (Tokyo)',
      short: 'Tokyo',
      ami: 'ami-ea4eae8c'
    },
    'ap-south-1' => {
      id: 'ap-south-1',
      name: 'Asia Pacific (Mumbai)',
      short: 'Mumbai',
      ami: 'ami-099fe766'
    },
    'sa-east-1' => {
      id: 'sa-east-1',
      name: 'South America (São Paulo)',
      short: 'São Paulo',
      ami: 'ami-10186f7c'
    }
  }
  
end
