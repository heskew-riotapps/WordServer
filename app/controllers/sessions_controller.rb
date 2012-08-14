class SessionsController < ApplicationController

        # displays login form
        def new
        end

        # POST login action
        def create
                player = Player.authenticate params[:email], params[:password]
                if player
                        session[:player] = player.id
                        redirect_to root_url, :notice => 'Welcome back, ' + user.username + '!'
                else
                        flash[:notice] = "Please enter valid information."
                        render 'new'
                end
        end

        # DELETE logout action
        def destroy
                session[:player] = nil
                redirect_to root_url
        end

end