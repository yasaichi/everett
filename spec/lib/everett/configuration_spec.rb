require "rails_helper"

RSpec.describe Everett::Configuration do
  # NOTE: To avoid changing state of Everett::Configuration#instance
  let(:configuration) { Class.new(described_class).instance }

  describe "#instantiated_observers" do
    subject { configuration.instantiated_observers }

    before do
      stub_const "FooObserver", Class.new.include(Singleton)
      configuration.observers = observers
    end

    context "when #observers include invalid values" do
      let(:observers) { [FooObserver, nil] }
      it { expect { subject }.to raise_error(TypeError) }
    end

    context "when #observers include valid values" do
      let(:observers) { [FooObserver, :bar_observer, "baz_observer"] }
      let(:expectation) { [FooObserver, BarObserver, BazObserver].map(&:instance) }

      before do
        stub_const "BarObserver", Class.new.include(Singleton)
        stub_const "BazObserver", Class.new.include(Singleton)
      end

      it { is_expected.to be_an_instance_of(Array).and contain_exactly(*expectation) }
    end
  end

  describe "#observers" do
    subject { configuration.observers }
    it { is_expected.to eq [] }
  end

  describe "#observers=" do
    describe "#observers" do
      subject { configuration.observers }

      context "when passing one observer" do
        before do
          configuration.observers = observer
        end

        context "when the value is nil" do
          let(:observer) { nil }
          it { is_expected.to eq [] }
        end

        context "when the value isn't nil" do
          let(:observer) { :foo_observer }
          it { is_expected.to eq [observer] }
        end
      end

      context "when passing more than one observer as array" do
        before do
          configuration.observers = %i(foo_observer bar_observer)
        end

        it { is_expected.to eq %i(foo_observer bar_observer) }
      end

      context "when passing more than one observer as comma-separated values" do
        before do
          configuration.observers = :foo_observer, :bar_observer
        end

        it { is_expected.to eq %i(foo_observer bar_observer) }
      end
    end
  end

  describe "#reset" do
    before do
      configuration.observers = :foo_observer
    end

    describe "#observers" do
      subject { -> { configuration.observers } }
      it { expect { configuration.reset }.to change(&subject).from(%i(foo_observer)).to([]) }
    end
  end
end
