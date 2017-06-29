
class ::EC2::Meta
  class << self

    def to_json
      {
        id:                'aws',
        name:              'Amazon Web Services',
        short_name:        'AWS',
        server_nick_name:  'EC2 Instance',
        default_region:    'us-east-1',
        default_plan:      'general_purpose',
        default_size:      't2.nano',
        can_reboot:        true,
        can_rename:        true,
        ssh_user:          'ubuntu',
        external_iface:    nil,
        internal_iface:    'eth0',
        credential_fields: [
          { key: :access_key_id, label: 'Access Key ID' },
          { key: :secret_access_key, label: 'Secret Access Key' }
        ],
        instructions:      instructions,
        bootstrap_script:  'https://s3.amazonaws.com/tools.nanobox.io/bootstrap/ubuntu.sh',
        ssh_key_method:    'reference'
      }.to_json
    end

    private

    def instructions
    <<-INSTR
<a href="//console.aws.amazon.com/iam/home#/home" target="_blank">Create
an IAM Account</a> in your AWS Management Console that has read/write
access to ec2 instances, security groups, and ssh keys, then add the
access key id and access key here.
    INSTR
    end

  end
end
