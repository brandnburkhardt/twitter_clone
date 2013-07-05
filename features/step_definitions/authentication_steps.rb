
Given /^a user visits the signin page$/ do
  visit signin_path  
end

When /^the user submits invalid signin information$/ do
  click_button 'Sign In'
end

Then /^the user should see an error message$/ do
  page.should have_selector 'div.alert.alert-error'
end

Given /^the user has an account$/ do
  @user = User.create(name: "Example User", email: "user@example.com", password: "foobar",
                      password_confirmation: "foobar")
end

When /^the user submits valid signin information$/ do
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Sign In"
end

Then /^the user should see their profile page$/ do
  page.should have_selector 'title', :text => @user.name
end

Then /^the user should see a signout link$/ do
  page.should have_link 'Sign Out', :href => signout_path
end