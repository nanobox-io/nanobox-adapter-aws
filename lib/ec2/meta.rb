
class ::EC2::Meta
  class << self
    
    def to_json
      {
        id:                'aws',
        name:              'Amazon Web Services',
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
        bootstrap_script:  'https://s3.amazonaws.com/tools.nanobox.io/bootstrap/ubuntu.sh'
      }.to_json
    end

    private

    def instructions
    <<-INSTR
TODO: key instructions
    INSTR
    end
    
  end
end
