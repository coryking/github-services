require 'contest'
require 'tilt'

begin
  require 'builder'
  class BuilderTemplateTest < Test::Unit::TestCase
    test "registered for '.builder' files" do
      assert_equal Tilt::BuilderTemplate, Tilt['test.builder']
      assert_equal Tilt::BuilderTemplate, Tilt['test.xml.builder']
    end

    test "preparing and evaluating the template on #render" do
      template = Tilt::BuilderTemplate.new { |t| "xml.em 'Hello World!'" }
      assert_equal "<em>Hello World!</em>\n", template.render
    end

    test "passing locals" do
      template = Tilt::BuilderTemplate.new { "xml.em('Hey ' + name + '!')" }
      assert_equal "<em>Hey Joe!</em>\n", template.render(Object.new, :name => 'Joe')
    end

    test "evaluating in an object scope" do
      template = Tilt::BuilderTemplate.new { "xml.em('Hey ' + @name + '!')" }
      scope = Object.new
      scope.instance_variable_set :@name, 'Joe'
      assert_equal "<em>Hey Joe!</em>\n", template.render(scope)
    end

    test "passing a block for yield" do
      template = Tilt::BuilderTemplate.new { "xml.em('Hey ' + yield + '!')" }
      assert_equal "<em>Hey Joe!</em>\n", template.render { 'Joe' }
    end

    test "block style templates" do
      template =
        Tilt::BuilderTemplate.new do |t|
          lambda { |xml| xml.em('Hey Joe!') }
        end
      assert_equal "<em>Hey Joe!</em>\n", template.render
    end
  end
rescue LoadError
  warn "Tilt::BuilderTemplate (disabled)"
end
