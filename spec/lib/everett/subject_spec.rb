require "rails_helper"

describe Everett::Subject do
  describe "::CALLBACKS" do
    subject { described_class::CALLBACKS }

    let(:expectation) do
      %i(
          after_initialize
          after_find
          after_touch
          before_validation
          after_validation
          before_save
          around_save
          after_save
          before_create
          around_create
          after_create
          before_update
          around_update
          after_update
          before_destroy
          around_destroy
          after_destroy
          after_commit
          after_create_commit
          after_update_commit
          after_destroy_commit
          after_rollback
        )
    end

    it { is_expected.to contain_exactly(*expectation) }
  end

  describe ".new" do
    subject { -> { described_class.new(Class.new) } }
    it { is_expected.to raise_error(NoMethodError) }
  end

  describe ".[]" do
    subject { -> { described_class[model_class] } }
    let(:model_class) { Class.new }

    it { expect(subject.call).to eq subject.call }
  end

  describe "#add_observer" do
    subject { described_method.call }

    let(:described_method) { -> { described_class[model_class].add_observer(observer) } }
    let(:model_class) { class_double("Model") }
    let(:observer) { double(:observer) }

    before do
      allow(observer).to receive(defined_method)
      described_class::CALLBACKS.each { |callback| allow(model_class).to receive(callback) }
    end

    context "when the observer defines no ActiveRecord callbacks" do
      let(:defined_method) { :foo }
      it { is_expected.to eq false }
    end

    context "when the observer defines ActiveRecord callbacks" do
      let(:defined_method) { described_class::CALLBACKS.first }

      context "when the observer is already added" do
        before do
          described_method.call
        end

        it "should return false, and the instance isn't used to set callbacks" do
          expect(model_class).not_to receive(defined_method)
          expect(subject).to eq false
        end
      end

      context "when the observer isn't added yet" do
        it "should return true, and the instance is used to set callbacks" do
          expect(model_class).to receive(defined_method).and_yield.once
          expect(subject).to eq true
        end
      end
    end
  end
end
