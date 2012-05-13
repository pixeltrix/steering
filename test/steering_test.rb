require "steering"
require "stringio"
require "test/unit"

class SteeringTest < Test::Unit::TestCase
  JS_FUNCTION_PATTERN = /^function\s*\(.*?\)\s*\{.*\}$/m

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
    compiled_file = File.dirname(file) + "/" + File.basename(file) + ".js"
    
    # making sure we leave things as they were
    should_delete_compiled = true unless File.exist?(compiled_file)
    File.delete(compiled_file) if File.exist?(compiled_file)
    
    Steering.compile_to_file(file, compiled_file)
    context_for_file_precompile = Steering.context_for_file_precompile(compiled_file)
    assert_equal Steering.render(File.read(compiled_file), :title => 'My title'), context_for_file_precompile.call("template", :title => 'My title')
    
    File.delete(compiled_file) if should_delete_compiled
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