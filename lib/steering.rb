require "execjs"
require "steering/source"

module Steering
  module Source
    def self.path
      @path ||= ENV["HANDLEBARS_SOURCE_PATH"] || bundled_path
    end

    def self.path=(path)
      @contents = @version = @context = nil
      @path = path
    end

    def self.contents
      @contents ||= File.read(path)
    end

    def self.context
      @context ||= ExecJS.compile(contents)
    end

    def self.runtime_path
      @runtime_path ||= ENV["HANDLEBARS_RUNTIME_PATH"] || bundled_runtime_path
    end

    def self.runtime_path=(runtime_path)
      @runtime = nil
      @runtime_path = runtime_path
    end

    def self.runtime
      @runtime_contents ||= File.read(runtime_path)
    end

    def self.version
      @version ||= context.eval("Handlebars.VERSION")
    end
  end

  class << self
    def version
      Source.version
    end

    def compile(template)
      template = template.read if template.respond_to?(:read)
      Source.context.call("Handlebars.precompile", template, { :knownHelpers => known_helpers })
    end

    def compile_to_file(template, file, extension = ".handlebars")
      File.open(file, 'w') do |f|
        name = File.basename(template, extension)
        template = File.read(template)
        f.write("\nHandlebars.templates = Handlebars.templates || {};")
        f.write("\nHandlebars.templates['#{name}'] = Handlebars.template(#{compile(template)});\n")
        f.write("\nHandlebars.registerPartial('#{name}', Handlebars.templates['#{name}']);\n")
      end
    end

    def context_for(template, extra = "")
      ExecJS.compile("#{Source.runtime}; #{extra}; var template = Handlebars.template(#{compile(template)})")
    end

    def known_helpers
      Source.known_helpers
    end

    def render(template, locals = {}, extra = "")
      context_for(template, extra).call("template", locals)
    end
  end
end
