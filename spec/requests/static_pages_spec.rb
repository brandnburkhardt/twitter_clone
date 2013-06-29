require 'spec_helper'

describe "Static Pages" do

  let(:base_title) { "Twitter Clone Sample App" }

  describe "Home Page" do

    it "should have the h1 'Twitter Clone'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Twitter Clone')
    end

    it "should have the base title" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "#{base_title}")
    end

    it "should not have a custom title" do
      visit '/static_pages/home'
      page.should_not have_selector('title', :text => " | Home")
    end
  end

  describe "Help Page" do

    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "#{base_title} | Help")
    end
  end

  describe "About Page" do

    it "should have the h1 'About'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About')
    end

    it "should have the title 'About'" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "#{base_title} | About")
    end
  end

  describe "Contact Page" do

    it "should have the h1 'Contact Me'" do
      visit '/static_pages/contact'
      page.should have_selector('h1', :text => 'Contact Me')
    end

    it "should have the title 'Contact Me'" do
      visit '/static_pages/contact'
      page.should have_selector('title', :text => "#{base_title} | Contact Me")
    end
  end
end