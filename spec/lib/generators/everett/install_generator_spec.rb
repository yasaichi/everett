require "rails_helper"
require "generators/everett/install/install_generator"

RSpec.describe Everett::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../tmp", __FILE__)

  before do
    prepare_destination
  end

  describe "generated files" do
    before do
      run_generator
    end

    describe "initializer" do
      subject { file("config/initializers/everett.rb") }

      let(:expected_content) do
        /\A
          Everett\.configure\ do\ \|config\|\n
          .*
          \#\ config.observers\ =\ :.+\n
          .*
          end
        \Z/mx
      end

      it { is_expected.to exist }
      it { is_expected.to have_correct_syntax }
      it { is_expected.to contain expected_content }
    end
  end

  after do
    FileUtils.rm_rf(destination_root)
  end
end
