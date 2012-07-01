require 'spec_helper'
require 'player'


describe Player do
  it "can a player be saved" do
    player = Player.new
	
	player.nickname = "test.do.nickname"
	player.email = "test.do.email"
 
	player.save
	
	player_test = Player.find_by_email("test.do.email");
	player_test.nickname.should eq("test.do.nickname")
  end
end