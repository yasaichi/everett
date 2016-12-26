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

    before do
      stub_const model_name, Class.new(ApplicationRecord)
      stub_const observer_name, Class.new(Everett::Observer)

      observer_class.class_exec(defined_method) do |method_name|
        define_method(method_name) { |_record| }
      end

      described_class.configure do |config|
        config.observers = observer_name.underscore
      end
    end

    describe "observers" do
      subject { observer_class.instance }

      before do
        allow(subject).to receive(defined_method)
        described_class.enable
      end

      context "when an instance of observerd models is initialized" do
        let(:defined_method) { :after_initialize }
        let!(:model_instance) { model_class.new }

        it { is_expected.to have_received(defined_method).with(model_instance).once }
      end

      context "when a record of observerd models is created" do
        let(:defined_method) { :after_create_commit }
        let!(:model_instance) { model_class.create! }

        it { is_expected.to have_received(defined_method).with(model_instance).once }
      end
    end

    after do
      described_class.configuration.reset
    end
  end
end
