require "rails_helper"

RSpec.describe Everett::Utils do
  describe ".constantize" do
    subject { described_class.constantize(underscored_name_or_constant) }
    let(:constant_name) { "many_worlds_interpretation" }

    before do
      stub_const constant_name.camelize, Class.new
    end

    context "when passing underscored name" do
      context "when the name refers to not existing constant" do
        let(:underscored_name_or_constant) { :foo }
        it { expect { subject }.to raise_error(NameError) }
      end

      context "when the name is String" do
        let(:underscored_name_or_constant) { constant_name }
        it { is_expected.to eq ManyWorldsInterpretation }
      end

      context "when the name is Symbol" do
        let(:underscored_name_or_constant) { constant_name.to_sym }
        it { is_expected.to eq ManyWorldsInterpretation }
      end
    end

    context "when passing constant" do
      let(:underscored_name_or_constant) { ManyWorldsInterpretation }
      it { is_expected.to eq underscored_name_or_constant }
    end
  end
end
