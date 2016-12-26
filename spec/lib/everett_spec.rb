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

  describe ".enable" do
    let(:model_class) { Object.const_get(model_name) }
    let(:model_name) { "Foo" }
    let(:observer_class) { Object.const_get(observer_name) }
    let(:observer_name) { "#{model_name}Observer" }
    let(:defined_method) { Everett::Subject::CALLBACKS.first }

    before do
      stub_const model_name, class_spy(model_name)
      stub_const observer_name, Class.new(Everett::Observer)

      observer_class.class_exec(defined_method) do |method_name|
        define_method(method_name) {}
      end

      described_class.configure do |config|
        config.observers = observer_name.underscore
      end

      described_class.enable
    end

    describe "observed models" do
      subject { model_class }
      it { is_expected.to have_received(defined_method).once }
    end

    after do
      described_class.configuration.reset
    end
  end
end
