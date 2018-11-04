# frozen-string-literal: true

module Stencil
  class ComponentGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    RESERVED_ELEMENT_NAMES = %w(
      annotation-xml
      color-profile
      font-face
      font-face-src
      font-face-uri
      font-face-format
      font-face-name
      missing-glyph
    ).freeze

    def create_component
      validate_element_name!

      template "component.tsx",     "app/javascript/components/#{file_name}/#{file_name}.tsx"
      template "component.scss",    "app/javascript/components/#{file_name}/#{file_name}.scss"
      template "component.spec.ts", "app/javascript/components/#{file_name}/#{file_name}.spec.ts"
    end

    private

    def file_name # :doc:
      @_file_name ||= super.dasherize
    end

    def class_name # :doc:
      @_class_name ||= super.underscore.classify
    end

    def validate_element_name!
      if !file_name.include?('-')
        raise "Invalid custom element name `#{file_name}'.\n\n" \
              "The custom element name must have at least one dash '-' in its name by specification. " \
              "For the exact requirements, please refer to W3C's official documentation:\n\n" \
              "    https://w3c.github.io/webcomponents/spec/custom/#valid-custom-element-name\n\n"
      end

      if RESERVED_ELEMENT_NAMES.include?(file_name)
        raise "Invalid custom element name `#{file_name}'.\n\n" \
              "The name `#{file_name}' is a reserved element name and can't be overwritten. Reserved names are the followings:\n\n" \
              "    #{RESERVED_ELEMENT_NAMES.join(", ")}\n\n" \
              "For the exact requirements, please refer to W3C's official documentation:\n\n" \
              "    https://w3c.github.io/webcomponents/spec/custom/#valid-custom-element-name\n\n"
      end
    end
  end
end
