require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = @micropost = user.microposts.build(content: "Lorem Ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "When User Id Is Not Present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end 

  describe "Accessible Attributes" do
    it "Should Not Allow Users To Access User_Id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "With Blank Content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "With Content That Is Too Long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end