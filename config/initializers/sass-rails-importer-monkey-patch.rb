#This works around an issues with sass-rails that results in import having issues with nesting - https://gist.github.com/1343402
require 'sass/rails/importer'
if defined?(Sass::Rails::VERSION) && Sass::Rails::VERSION[0..3] >= '3.1.'
  Rails.logger.warn ' == MONKEY == Patching sass-rails: https://github.com/rails/sass-rails/pull/70'
  Rails.logger.warn " == MONKEY == Please remove #{__FILE__} once Sass::Rails upstream has pulled in the fix"
  # monkey patch to incorporate https://github.com/rails/sass-rails/pull/70
  module Sass
    module Rails
      class Importer
        def resolve(name, base_pathname = nil)
          name = Pathname.new(name)
          if base_pathname && base_pathname.to_s.size > 0
            root = context.pathname.dirname
            name = base_pathname.relative_path_from(root).join(name)
          end
          partial_name = name.dirname.join("_#{name.basename}")
          @resolver.resolve(name) || @resolver.resolve(partial_name)
        end
      end
    end
  end
end