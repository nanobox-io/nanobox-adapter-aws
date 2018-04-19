module ::EC2

  DEFAULT_REGION = 'us-east-1'

  REGIONS = {
    'us-east-1' => {
      id: 'us-east-1',
      name: 'US East (N. Virginia)',
      short: 'N. Virginia',
      hvm_ami: 'ami-6dfe5010',
      pv_ami: 'ami-3cf85641'
    },
    'us-east-2' => {
      id: 'us-east-2',
      name: 'US East (Ohio)',
      short: 'Ohio',
      hvm_ami: 'ami-e82a1a8d',
      pv_ami: 'ami-4c281829'
    },
    'us-west-1' => {
      id: 'us-west-1',
      name: 'US West (N. California)',
      short: 'N. California',
      hvm_ami: 'ami-493f2f29',
      pv_ami: 'ami-e1203081'
    },
    'us-west-2' => {
      id: 'us-west-2',
      name: 'US West (Oregon)',
      short: 'Oregon',
      hvm_ami: 'ami-ca89eeb2',
      pv_ami: 'ami-5c97f024'
    },
    'ca-central-1' => {
      id: 'ca-central-1',
      name: 'Canada Central (Montreal)',
      short: 'Central',
      hvm_ami: 'ami-9d7afcf9',
      pv_ami: 'ami-9c7afcf8'
    },
    'eu-west-1' => {
      id: 'eu-west-1',
      name: 'EU West (Ireland)',
      short: 'Ireland',
      hvm_ami: 'ami-74e6b80d',
      pv_ami: 'ami-91e7b9e8'
    },
    'eu-central-1' => {
      id: 'eu-central-1',
      name: 'EU Central (Frankfurt)',
      short: 'Frankfurt',
      hvm_ami: 'ami-cd491726',
      pv_ami: 'ami-a649174d'
    },
    'eu-west-2' => {
      id: 'eu-west-2',
      name: 'EU West (London)',
      short: 'London',
      hvm_ami: 'ami-506e8f37',
      pv_ami: 'ami-0871906f'
    },
    'eu-west-3' => {
      id: 'eu-west-3',
      name: 'EU West 3',
      short: 'eu west 3',
      hvm_ami: 'ami-9a03b5e7',
      pv_ami: ''
    },
    'ap-southeast-1' => {
      id: 'ap-southeast-1',
      name: 'Asia Pacific (Singapore)',
      short: 'Singapore',
      hvm_ami: 'ami-82c9ecfe',
      pv_ami: 'ami-e4ceeb98'
    },
    'ap-southeast-2' => {
      id: 'ap-southeast-2',
      name: 'Asia Pacific (Sydney)',
      short: 'Sydney',
      hvm_ami: 'ami-2b12dc49',
      pv_ami: 'ami-5b10de39'
    },
    'ap-northeast-2' => {
      id: 'ap-northeast-2',
      name: 'Asia Pacific (Seoul)',
      short: 'Seoul',
      hvm_ami: 'ami-633d920d',
      pv_ami: 'ami-d0208fbe'
    },
    'ap-northeast-1' => {
      id: 'ap-northeast-1',
      name: 'Asia Pacific (Tokyo)',
      short: 'Tokyo',
      hvm_ami: 'ami-60a4b21c',
      pv_ami: 'ami-51a5b32d'
    },
    'ap-south-1' => {
      id: 'ap-south-1',
      name: 'Asia Pacific (Mumbai)',
      short: 'Mumbai',
      hvm_ami: 'ami-dba580b4',
      pv_ami: 'ami-e8a08587'
    },
    'sa-east-1' => {
      id: 'sa-east-1',
      name: 'South America (São Paulo)',
      short: 'São Paulo',
      hvm_ami: 'ami-5782d43b',
      pv_ami: 'ami-5b85d337'
    }
  }

end
