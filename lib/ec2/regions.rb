module ::EC2

  DEFAULT_REGION = 'us-east-1'

  REGIONS = {
    'us-east-1' => {
      id: 'us-east-1',
      name: 'US East (N. Virginia)',
      short: 'N. Virginia',
      hvm_ami: 'ami-da05a4a0',
      pv_ami: 'ami-0309a879'
    },
    'us-east-2' => {
      id: 'us-east-2',
      name: 'US East (Ohio)',
      short: 'Ohio',
      hvm_ami: 'ami-336b4456',
      pv_ami: 'ami-b16c43d4'
    },
    'us-west-1' => {
      id: 'us-west-1',
      name: 'US West (N. California)',
      short: 'N. California',
      hvm_ami: 'ami-1c1d217c',
      pv_ami: 'ami-cb1d21ab'
    },
    'us-west-2' => {
      id: 'us-west-2',
      name: 'US West (Oregon)',
      short: 'Oregon',
      hvm_ami: 'ami-0a00ce72',
      pv_ami: 'ami-d000cea8'
    },
    'ca-central-1' => {
      id: 'ca-central-1',
      name: 'Canada Central (Montreal)',
      short: 'Central',
      hvm_ami: 'ami-8a71c9ee',
      pv_ami: 'ami-5670c832'
    },
    'eu-west-1' => {
      id: 'eu-west-1',
      name: 'EU West (Ireland)',
      short: 'Ireland',
      hvm_ami: 'ami-add175d4',
      pv_ami: 'ami-4dd07434'
    },
    'eu-central-1' => {
      id: 'eu-central-1',
      name: 'EU Central (Frankfurt)',
      short: 'Frankfurt',
      hvm_ami: 'ami-97e953f8',
      pv_ami: 'ami-7cef5513'
    },
    'eu-west-2' => {
      id: 'eu-west-2',
      name: 'EU West (London)',
      short: 'London',
      hvm_ami: 'ami-ecbea388',
      pv_ami: 'ami-36b8a552'
    },
    'ap-southeast-1' => {
      id: 'ap-southeast-1',
      name: 'Asia Pacific (Singapore)',
      short: 'Singapore',
      hvm_ami: 'ami-67a6e604',
      pv_ami: 'ami-f5a7e796'
    },
    'ap-southeast-2' => {
      id: 'ap-southeast-2',
      name: 'Asia Pacific (Sydney)',
      short: 'Sydney',
      hvm_ami: 'ami-41c12e23',
      pv_ami: 'ami-59c12e3b'
    },
    'ap-northeast-2' => {
      id: 'ap-northeast-2',
      name: 'Asia Pacific (Seoul)',
      short: 'Seoul',
      hvm_ami: 'ami-7b1cb915',
      pv_ami: 'ami-761cb918'
    },
    'ap-northeast-1' => {
      id: 'ap-northeast-1',
      name: 'Asia Pacific (Tokyo)',
      short: 'Tokyo',
      hvm_ami: 'ami-15872773',
      pv_ami: 'ami-348b2b52'
    },
    'ap-south-1' => {
      id: 'ap-south-1',
      name: 'Asia Pacific (Mumbai)',
      short: 'Mumbai',
      hvm_ami: 'ami-bc0d40d3',
      pv_ami: 'ami-7e0d4011'
    },
    'sa-east-1' => {
      id: 'sa-east-1',
      name: 'South America (São Paulo)',
      short: 'São Paulo',
      hvm_ami: 'ami-466b132a',
      pv_ami: 'ami-7d6a1211'
    }
  }

end
