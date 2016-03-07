require 'spec_helper'

describe "Beerlist page" do
  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(:allow_localhost => true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, :name => "Koff")
    @brewery2 = FactoryGirl.create(:brewery, :name => "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, :name => "Ayinger")
    @style1 = Style.create :name=>"Lager"
    @style2 = Style.create :name=>"Rauchbier"
    @style3 = Style.create :name=>"Weizen"
    @beer1 = FactoryGirl.create(:beer, :name => "Nikolai", :brewery => @brewery1, :style => @style1)
    @beer2 = FactoryGirl.create(:beer, :name => "Fastenbier", :brewery => @brewery2, :style => @style2)
    @beer3 = FactoryGirl.create(:beer, :name => "Lechte Weisse", :brewery => @brewery3, :style => @style3)

    visit ngbeerlist_path
  end
	
  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end
  
  def nth_beer(n)
    find('table tbody').find("tr:nth-child(#{n})")  
  end

  it "shows a known beer", :js => true do
	visit ngbeerlist_path
    save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it "beers are first ordered by name", :js => true do
    visit ngbeerlist_path
    save_and_open_page
    nth_beer(1).should have_content('Fastenbier')
    nth_beer(2).should have_content('Lechte Weisse')
    nth_beer(3).should have_content('Nikolai')
  end

  it "beers are ordered by style when clicking style header", :js => true do
    visit ngbeerlist_path
    save_and_open_page
	click_link "Style"
    nth_beer(1).should have_content('Lager')
    nth_beer(2).should have_content('Rauchbier')
    nth_beer(3).should have_content('Weizen')
  end

  it "beers are ordered by style when clicking style header", :js => true do
    visit ngbeerlist_path
    save_and_open_page
	click_link "Brewery"

    nth_beer(1).should have_content('Ayinger')
    nth_beer(2).should have_content('Koff')
    nth_beer(3).should have_content('Schlenkerla')
  end
end