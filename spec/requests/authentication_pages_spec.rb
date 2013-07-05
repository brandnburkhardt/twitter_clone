require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "Sign In Page" do
    before { visit signin_path }

    it { should have_selector 'h1', :text => 'Sign In' }
    it { should have_selector 'title', :text => 'Sign In' }
  end

  describe "Sign In Process" do
    before { visit signin_path }

    describe "Sign In With Invalid Information" do
      before { click_button "Sign In" }

      it { should have_selector 'title', :text => 'Sign In' }
      it { should have_selector 'div.alert.alert-error', :text => 'Invalid' }

      describe "Page Navigation After Failed Sign In" do
        before { click_link "Home" }

        it { should_not have_selector 'div.alert.alert-error' }
      end
    end

    describe "Sign In With Valid Information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    :with => user.email.upcase
        fill_in "Password", :with => user.password
        click_button "Sign In"
      end

      it { should have_selector 'title', :text => user.name }
      it { should have_link 'Profile', :href => user_path(user) }
      it { should have_link 'Sign Out', :href => signout_path }
      it { should_not have_link 'Sign In', :href => signin_path }      

      describe "Following Sign Out" do
        before { click_link 'Sign Out' }
        it { should have_link 'Sign In' }
      end
    end
  end
end