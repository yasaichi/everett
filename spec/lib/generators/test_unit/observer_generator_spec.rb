require "rails_helper"
require "generators/test_unit/observer/observer_generator"

RSpec.describe TestUnit::Generators::ObserverGenerator, type: :generator do
  destination File.expand_path("../tmp", __FILE__)

  before do
    prepare_destination
  end

  describe "generated files" do
    %w(foo Foo foo_bar FooBar foo/bar Foo::Bar).each do |model_name|
      context %(when "#{model_name}" is passed) do
        before do
          run_generator [model_name]
        end

        describe "test" do
          subject { file(File.join("test/unit", "#{model_name.underscore}_observer_test.rb")) }

          let(:expected_content) do
            <<-CONTENT.strip_heredoc
              require "test_helper"

              class #{model_name.camelize}ObserverTest < ActiveSupport::TestCase
                # test "the truth" do
                #   assert true
                # end
              end
            CONTENT
          end

          it { is_expected.to exist & have_correct_syntax & contain(expected_content) }
        end
      end

      after do
        FileUtils.rm_rf(destination_root)
      end
    end
  end
end
