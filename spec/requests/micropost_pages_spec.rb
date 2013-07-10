require 'spec_helper'

describe "Micropost Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "Micropost Creation" do
    before { visit root_path }

    describe "With Invalid Information" do

      it "Should Not Create A Micropost" do
        expect { click_button "Tweeet" }.not_to change(Micropost, :count)
      end

      describe "Error Messages" do
        before { click_button "Tweeet" }
        it { should have_content 'error' }
      end
    end

    describe "With Valid Information" do

      before { fill_in "micropost_content", :with => "Lorem Ipsum" }

      it "Should Create A Micropost" do
        expect { click_button "Tweeet" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "Micropost Destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "As Correct User" do
      before { visit root_path }

      it "Should Delete A Micropost" do
        expect { click_link "Delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end