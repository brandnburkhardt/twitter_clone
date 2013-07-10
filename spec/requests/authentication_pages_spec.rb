require 'spec_helper'
require 'pry'

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
      before { sign_in user }

      it { should have_selector 'title',    :text => user.name }
      it { should have_link     'Users',    :href => users_path }
      it { should have_link     'Profile',  :href => user_path(user) }
      it { should have_link     'Settings', :href => edit_user_path(user) }
      it { should have_link     'Sign Out', :href => signout_path }
      it { should_not have_link 'Sign In',  :href => signin_path }      

      describe "Following Sign Out" do
        before { click_link 'Sign Out' }
        it { should have_link 'Sign In' }
      end
    end
  end

  describe "Authourization" do

    describe "For Non-Signed-In Users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "When Attempting to Visit a Protected Page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", :with => user.email
          fill_in "Password", :with => user.password
          click_button "Sign In"
        end

        describe "After Signing In" do

          it "It Should Render the Desired Protected Page" do
            page.should have_selector 'title', :text => 'Edit User'
          end
        end
      end

      describe "In The Users Controller" do

        describe "Visiting The Edit Page" do
          before { visit edit_user_path(user) }
          it { should have_selector 'title', :text => 'Sign In' }
        end

        describe "Submitting To The Update Action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "Visitng The User Index" do
          before { visit users_path }
          it { should have_selector 'title', :text => 'Sign In' }
        end
      end

      describe "In The Microposts Controller" do

        describe "Submitting To The Create Action" do
          before { post microposts_path }
          specify { response.should redirect_to signin_path }
        end

        describe "Submitting To The Destroy Action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to signin_path }
        end
      end
    end

    describe "As The Wrong User" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "Visiting Users#Edit Page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector 'title', :text => full_title('Edit User') }
      end

      describe "Submitting A PUT Request to the Users#Update Action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "As A Non-Admin User" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "Submitting A DELETE Request To The Users#Destroy Action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }

      end 
    end
  end
end