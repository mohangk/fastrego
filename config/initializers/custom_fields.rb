UadcRego::Application.config.custom_fields = YAML.load_file(Rails.root.join('config', 'custom_fields.yml'))[Rails.env]
