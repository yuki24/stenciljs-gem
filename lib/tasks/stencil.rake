tasks = {
  "stencil:install"           => "Installs and setup stencil with Yarn",
  "stencil:compile"           => "Compiles stencil bundles based on environment",
  "stencil:build"             => "Alias to stencil:build",
# "stencil:clobber"           => "Removes the stencil compiled output directory",
  "stencil:check_node"        => "Verifies if Node.js is installed",
  "stencil:check_yarn"        => "Verifies if Yarn is installed",
  "stencil:verify_install"    => "Verifies if Stencil is installed"
}.freeze

desc "Lists all available tasks in stencil"
task :stencil do
  puts "Available Stencil tasks are:"
  tasks.each { |task, message| puts task.ljust(30) + message }
end

namespace :stencil do
  desc "Support for older Rails versions. Install all JavaScript dependencies as specified via Yarn"
  task :yarn_install, [:arg1, :arg2] do |task, args|
    system "yarn #{args[:arg1]} #{args[:arg2]}"
  end

  desc "Installs and setup stencil with Yarn"
  task :install do
    template = File.expand_path("../install/template.rb", __dir__)
    if Rails::VERSION::MAJOR >= 5
      exec "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{template}"
    else
      exec "#{RbConfig.ruby} ./bin/rake rails:template LOCATION=#{template}"
    end
  end

  desc "Verifies if Node.js is installed"
  task :check_node do
    begin
      begin
        node_version = `node -v`
      rescue Errno::ENOENT
        node_version = `nodejs -v`
        raise Errno::ENOENT if node_version.blank?
      end
    rescue Errno::ENOENT
      $stderr.puts "Node.js not installed. Please download and install Node.js https://nodejs.org/en/download/"
      $stderr.puts "Exiting!" && exit!
    end
  end

  desc "Verifies if Yarn is installed"
  task :check_yarn do
    yarn_version = `yarn --version`

    if yarn_version.blank?
      $stderr.puts "Yarn not installed. Please download and install Yarn from https://yarnpkg.com/lang/en/docs/install/"
      $stderr.puts "Exiting!" && exit!
    end
  end

  desc "Verifies if Stencil is installed"
  task verify_install: ['stencil:check_node', 'stencil:check_yarn'] do
    if Rails.root.join("stencil.config.js").exist?
      $stdout.puts "Stenciljs is installed 🎉 🍰"
    else
      $stderr.puts "Configuration stencil.config.js file not found. \n"\
                   "Make sure stencil:install is run successfully before " \
                   "running dependent tasks"
      exit!
    end
  end

  desc "Compiles stencil bundles based on environment"
  task build: :verify_install do
    sh './node_modules/.bin/stencil build'
  end

  desc "Alias to stencil:build"
  task compile: :build

  desc "Starts stencil dev server with --watch option"
  task dev: :verify_install do
    sh './node_modules/.bin/sd concurrent ' \
       '"./node_modules/.bin/stencil build --dev --watch" ' \
       '"./node_modules/.bin/stencil-dev-server"'
  end

  desc "Starts stencil dev server with --watch option"
  task start: :dev

  desc "Runs jest tests"
  task :test do
    sh './node_modules/.bin/jest --no-cache'
  end

  namespace :test do
    desc "Runs jest tests with --watch option"
    task :watch do
      sh './node_modules/.bin/jest --watch --no-cache'
    end
  end
end

# Compile web components before we've compiled all other assets during precompilation
if Rake::Task.task_defined?("assets:precompile")
  if Rails::VERSION::STRING >= '5.1.0'
    Rake::Task["assets:precompile"].enhance ["yarn:install", "stencil:compile"]
  else
    # For Rails < 5.1
    Rake::Task["stencil:compile"].enhance ['stencil:yarn_install']
    Rake::Task["assets:precompile"].enhance ["stencil:compile"]
  end
end
