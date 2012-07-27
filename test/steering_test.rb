require "steering"
require "stringio"
require "test/unit"

class SteeringTest < Test::Unit::TestCase
  JS_FUNCTION_PATTERN         = /^function\s*\(.*?\)\s*\{.*\}$/m
  HB_PREAMBLE                 = /Handlebars\.templates\s*=\s*Handlebars.templates\s\|\|\s*\{\};/
  HB_ASSIGNMENT               = /Handlebars\.templates\['\w+'\]\s*=/
  HB_TEMPLATE                 = /Handlebars\.template\(function\s*\(.*?\)\s*\{.*\}\);/m
  HB_PARTIAL                  = /Handlebars\.registerPartial\('\w+',\sHandlebars\.templates\['\w+'\]\);/
  HB_TEMPLATE_PATTERN         = /^\n#{HB_PREAMBLE}\n#{HB_ASSIGNMENT}\s*#{HB_TEMPLATE}\s*$/m
  HB_TEMPLATE_PATTERN_PARTIAL = /^\n#{HB_PREAMBLE}\n#{HB_ASSIGNMENT}\s*#{HB_TEMPLATE}\n#{HB_PARTIAL}\n*$/m

  def test_version
    assert_equal Steering::Source::VERSION, Steering.version
  end

  def test_compile
    assert_match JS_FUNCTION_PATTERN, Steering.compile("Hello {{ name }}")
  end

  def test_compile_with_io
    io = StringIO.new("Hello {{ name }}")
    assert_equal Steering.compile("Hello {{ name }}"), Steering.compile(io)
  end

  def test_compilation_error
    assert_raise ExecJS::ProgramError do
      Steering.compile("{{ name")
    end
  end

  def test_compile_file
    file = "example/mytemplate.handlebars"
    compiled_file = "example/mytemplate.js"

    Steering.compile_to_file(file, compiled_file)
    compiled_source = File.read(compiled_file)

    assert_match HB_TEMPLATE_PATTERN, compiled_source
  ensure
    File.delete(compiled_file) if File.exists?(compiled_file)
  end

  def test_compile_file_partial
    file = "example/mytemplate.handlebars"
    compiled_file = "example/mytemplate.js"

    Steering.compile_to_file(file, compiled_file, ".handlebars", true)
    compiled_source = File.read(compiled_file)

    assert_match HB_TEMPLATE_PATTERN_PARTIAL, compiled_source
  ensure
    File.delete(compiled_file) if File.exists?(compiled_file)
  end

  def test_context_for
    context = Steering.context_for("Hello {{ name }}")
    assert_equal "Hello Andrew", context.call("template", :name => "Andrew")
  end

  def test_render
    assert_equal "Hello Andrew", Steering.render("Hello {{ name }}", :name => "Andrew")
  end

  def test_runtime_error
    helper = "Handlebars.registerHelper('throw', function(arg) { throw arg; })"
    context = Steering.context_for("Hello {{ throw foo }}", helper)

    begin
      context.call("template", :foo => "bar")
    rescue ExecJS::ProgramError => e
      assert_equal "bar", e.message
    end
  end
end