require "rails_helper"
require "cancan/matchers"

RSpec.describe Admin, type: :model do
  describe "abilities" do
    subject { Ability.new(admin) }

    let(:admin) { nil }
    let(:japan) { FactoryGirl.create(:country, name: 'Japan') }
    let(:kosovo) { FactoryGirl.create(:country, name: 'Kosovo') }

    context "when is a super admin" do
      let(:admin) { FactoryGirl.create(:super_admin, country: japan) }
      it { is_expected.to be_able_to(:manage, Admin.new(country: kosovo)) }
    end

    context "when is a project manager" do
      let(:admin) { FactoryGirl.create(:project_manager, country: japan) }

      it { is_expected.to be_able_to(:manage, Area.new) }
      it { is_expected.to be_able_to(:manage, Admin.new(country: japan)) }
      it { is_expected.to_not be_able_to(:manage, Admin.new(country: kosovo)) }
    end
  end

  describe '#super_admin?' do
    subject { admin.super_admin? }

    context 'when is a super admin' do
      let(:admin) { FactoryGirl.create(:super_admin) }
      it { is_expected.to be true }
    end

    context 'when is not a super admin' do
      let(:admin) { FactoryGirl.create(:project_manager) }
      it { is_expected.to be false }
    end
  end
end
