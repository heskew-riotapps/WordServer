class GamesController < ApplicationController
	def new
		Game.delete_all
		game = Game.new
		game.test = "test"
#		game.letters = [Letter.new(:value => 'S'),Letter.new(:value => 'O')] 
		game.letters << Letter.new(:value => 'l') 
		game.letters << Letter.new(:value => 'K')
		game.letters << Letter.new(:value => ')') 		
		game.save
#		game = Game.create({
#		  :test => 'Sam'
#		  })

		
		
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @post }
		end
	end

  def index
    @games = Game.all 

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
