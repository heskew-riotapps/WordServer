class PlayerService

  def self.create(params)
	#create default nickname if they dont fill it in
	#check for facebookId if it is sent in
		if !params[:fb].blank?
			@player = Player.find_by_fb(params[:fb])
			if @player.nil?
				@player = Player.new
				@player.fb = params[:fb]
				@player.password = "useless"
				@player.email = params[:email]
				@player.f_name = params[:f_name]
				@player.l_name = params[:l_name]
				@player.email = params[:email]

#			@player = Player.create({
#					:password => "useless", #won't be used for fb users.  cannot figure out optional has_secure_password at the moment
#					:fb => params[:fb],
#					:email => params[:email],
#					:f_name => params[:f_name],
#					:l_name => params[:l_name]})
			else
				@player.f_name = params[:f_name]
				@player.l_name = params[:l_name]
				@player.email = params[:email]
			end
			
			@player.generate_token(:auth_token)
			@ok = @player.save
		else		
			@player = Player.find_by_email(params[:email])
			if @player.nil?
				@player = Player.find_by_nickname(params[:n_name])
				if @player.nil?
					@player = Player.new
					@player.password = params[:password]
					@player.n_name = params[:n_name]
					@player.email = params[:email]
				#@player = Player.create({
				#		:nickname => params[:nickname],
				#		:email => params[:email],
				#		:f_name => params[:f_name],
				#		:l_name => params[:l_name],
				#		:password => params[:password]
				#	})
					@player.generate_token(:auth_token)
					@ok = @player.save
				else
					#validate password here
					if @player.authenticate_with_new_token(params[:password])
						#@player.generate_session_token
						#@player.nickname = params[:nickname]
						@player.email = params[:email]
						@ok = @player.save
						#@ok = @player.update_attributes(params)
					else
						@unauthorized = true
					end
				end
				
			else
				#player has been found...check password now.
				#if password fails, send login failed error to client
				#error codes via http or just error strings??
				if @player.authenticate_with_new_token(params[:password])
					#@player.generate_session_token
					@player.n_name = params[:n_name]
					#@player.email = params[:email]
					@ok = @player.save
					#@ok = @player.update_attributes(params)
				else
					@unauthorized = true
				end	
			end
		end	
		
		return @player
	end


end