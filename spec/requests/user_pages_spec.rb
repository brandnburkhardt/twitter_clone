require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "Sign Up Page" do
    before { visit signup_path }

    it { should have_selector 'h1', :text => 'Sign Up' }
    it { should have_selector 'title', :text => full_title('Sign Up') }
  end

  describe "SignUp Process" do

    before { visit signup_path }

    let(:submit) { "Create My Account" }

    describe "signup with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "signup with valid information" do
      before do
        fill_in "Name",                  with: "Example User"
        fill_in "Email",                 with: "user@example.com"
        fill_in "Password",              with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email("user@example.com") }

        it { should have_selector 'title', :text => user.name }
        it { should have_selector 'div.alert.alert-success', :text => 'Welcome' }
        it { should have_link 'Sign Out' }
      end
    end
  end

  describe "Profile Page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1)   { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2)   { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_selector 'h1', :text => user.name }
    it { should have_selector 'title', :text => user.name }

    describe "Microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "Follow/Unfollow Button" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "Following A User" do
        before { visit user_path(other_user) }

        it "Should Increment The Followed User Count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "Should Increment The Other User's Followers Count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "Toggling The Button" do
          before { click_button "Follow" }
          it { should have_selector 'input', :value => 'Unfollow' }
        end
      end

      describe "Unfollowing A User" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "Should Decrement The Followed User Count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "Should Decrement The Other User's Follower Count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "Toggling The Button" do
          before { click_button "Unfollow" }
          it { should have_selector 'input', :value => 'Follow' }
        end
      end
    end
  end

  describe "Edit Pages" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "Page" do
      it { should have_selector 'h1', :text => "Update Your Profile" }
      it { should have_selector 'title', :text => "Edit User" }
      it { should have_link 'Change your profile image', :href => 'http://gravatar.com/emails' }
    end

    describe "With Invalid Information" do
      before { click_button 'Save Changes' }

      it { should have_content 'error' }
    end

    describe "With Valid Information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", :with => new_name
        fill_in "Email", :with => new_email
        fill_in "Password", :with => "foobar"
        fill_in "Confirm Password", :with => "foobar"
        click_button "Save Changes"
      end

      it { should have_selector 'title', :text => new_name }
      it { should have_selector 'div.alert.alert-success' }
      it { should have_link 'Sign Out', :href => signout_path }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "Index Page" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: 'Bob', email: "bob@exmaple.com")
      FactoryGirl.create(:user, name: 'Ben', email: "ben@exmaple.com")
      visit users_path
    end

    it { should have_selector 'title', :text => 'All Users' }
    it { should have_selector 'h1',    :text => 'All Users' }

    describe "Pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector 'div.pagination' }

      it "Should List Each User" do
        User.paginate(page: 1).each do |user|
          page.should have_selector 'li', :text => user.name
        end
      end
    end

    describe "Delete Links" do

      it { should_not have_link 'Delete' }

      describe "As An Admin User" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link 'Delete', :href => user_path(User.first) }

        it "Should Be Able To Delete Another User" do
          expect { click_link 'Delete' }.to change(User, :count).by(-1)
        end

        it { should_not have_link 'Delete', :href => user_path(admin) }
      end
    end
  end

  describe "Following/Followers" do
    let(:user)       { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "Followed Users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_selector 'title', :text => full_title('Following') }
      it { should have_selector 'h3', :text => 'Following' }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "Followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_selector 'title', :text => full_title('Followers') }
      it { should have_selector 'h3', :text => 'Followers' }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end