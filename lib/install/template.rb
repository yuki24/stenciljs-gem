copy_file "#{__dir__}/templates/tsconfig.json",         "tsconfig.json"
template  "#{__dir__}/templates/stencil.config.js.erb", "stencil.config.js"
template  "#{__dir__}/templates/index.html.erb",        "app/javascript/components/index.html"
copy_file "#{__dir__}/templates/hello-world.tsx",       "app/javascript/components/hello-world/hello-world.tsx"

if File.exists?(".gitignore")
  append_to_file ".gitignore", <<-EOS
/app/javascript/components/components.d.ts
/public/components
EOS
end

say "Installing runtime dependencies"
run "yarn add @stencil/core"

say "Installing dev server for live reloading"
run "yarn add --dev @stencil/dev-server @stencil/utils @types/jest jest"

say "Injecting jest configurations"
gsub_file 'package.json', "  }\n}", <<-JSON
  },
  "jest": {
    "transform": {
      "^.+\\\\\\.(ts|tsx)$": "<rootDir>/node_modules/@stencil/core/testing/jest.preprocessor.js"
    },
    "testRegex": "(/__tests__/.*|\\\\\\.(test|spec))\\\\\\.(tsx?|jsx?)$",
    "moduleFileExtensions": [
      "ts",
      "tsx",
      "js",
      "json",
      "jsx"
    ]
  }
}
JSON

say "Wiring up Stencil.js' entry point into Rails' asset pipeline"
append_to_file "app/assets/javascripts/application.js", <<-EOS
//= require #{Rails.application.class.parent_name.downcase}
EOS

say "Stencil.js successfully installed 🎉 🍰", :green
