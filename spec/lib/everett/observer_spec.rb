require "rails_helper"

RSpec.describe Everett::Observer do
  # NOTE: To avoid changing state of Everett::Observer#instance
  let(:observer) { Object.const_get(observer_name).instance }

  let(:observer_name) { "#{model_name}Observer" }
  let(:model_class) { Object.const_get(model_name) }
  let(:model_name) { "Foo" }

  before do
    stub_const observer_name, Class.new(described_class)
    stub_const model_name, Class.new
  end

  describe ".observe" do
    let(:models) { %i(foo bar) }
    let(:observer_spy) { instance_spy(described_class) }

    before do
      allow(described_class).to receive(:instance) { observer_spy }

      described_class.class_exec(models) do |models|
        observe *models
      end
    end

    describe ".instance" do
      subject { described_class.instance }
      it { is_expected.to have_received(:observe).once.with(*models) }
    end
  end

  describe "#observe" do
    let(:described_method) { -> { observer.observe(*models) } }

    context "when specifing not existing models" do
      let(:models) { %i(bar) }
      it { expect(&described_method).to raise_error(NameError) }
    end

    context "when specifing existing models" do
      context "when specifing one model" do
        let(:models) { [model_name] }

        it "should change #subjects and return true" do
          expect(described_method.call).to eq true
          expect(observer.observed_classes).to eq [model_class]
        end
      end

      context "when specifing more than one subject" do
        let(:models) { [model_name, :bar] }

        before do
          stub_const "Bar", Class.new
        end

        it "should change #subjects and return true" do
          expect(described_method.call).to eq true
          expect(observer.observed_classes).to be_an_instance_of(Array).and contain_exactly(model_class, Bar)
        end
      end
    end
  end

  describe "#observed_classes" do
    subject { observer.observed_classes }

    context "when able to infer a model from the class name" do
      it { is_expected.to eq [model_class] }
    end

    context "when not able to infer a model from the class name" do
      let(:observer) { BarObserver.instance }

      before do
        stub_const "BarObserver", Class.new(described_class)
      end

      it { is_expected.to eq [] }
    end
  end
end
