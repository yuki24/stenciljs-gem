# frozen-string-literal: true

module Stencil
  class ComponentGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_component
      if !file_name.include?('-')
        raise "Invalid custom element name `#{file_name}'.\n\n" \
              "The custom element name must have at least one dash '-' in its name by specification. " \
              "For the exact requirements, please refer to W3C's official documenattion:\n\n" \
              "    https://w3c.github.io/webcomponents/spec/custom/#valid-custom-element-name\n\n"
      end

      template "component.tsx",     "app/javascript/components/#{file_name}/#{file_name}.tsx"
      template "component.scss",    "app/javascript/components/#{file_name}/#{file_name}.scss"
      template "component.spec.ts", "app/javascript/components/#{file_name}/#{file_name}.spec.ts"
    end

    def add_component_bundles
      gsub_file "stencil.config.js", "  bundles: [\n", <<-JSON
  bundles: [
    { components: ['#{file_name}'] },
JSON
    end

    private

    def file_name # :doc:
      @_file_name ||= super.dasherize
    end

    def class_name # :doc:
      @_class_name ||= super.underscore.classify
    end
  end
end
