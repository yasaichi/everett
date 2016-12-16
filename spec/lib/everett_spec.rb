require "rails_helper"

RSpec.describe Everett do
  describe ".configuration" do
    subject { described_class.configuration }
    it { is_expected.to be_an_instance_of Everett::Configuration }
  end

  describe ".configure" do
    subject { described_class.configuration }

    before do
      described_class.configure do |config|
        config.observers = :foo_observer
      end
    end

    it { is_expected.to have_attributes(observers: %i(foo_observer)) }

    after do
      described_class.configuration.reset
    end
  end
end
