class PlayerService

  def self.create(params)
	#create default nickname if they dont fill it in
	#check for facebookId if it is sent in
		if !params[:fb].blank?
			@player = Player.find_by_fb(params[:fb])
			if @player.nil?
				@player = Player.new
				@player.fb = params[:fb] #facebook_id
				#@player.password = ""
			end
			@player.f_n = params[:f_n] #first_name
			@player.l_n = params[:l_n] #last_name
			@player.e_m = params[:e_m] #email
			@player.generate_token("0") #auth_token
			
			#validate is false so that has_secure_password does not fire and password_digest is not stored for fb users
			@ok = @player.save(:validate => false)  
		else		
			@player = Player.find_by_e_m(params[:e_m])
			if @player.nil?
				@player = Player.find_by_n_n(params[:n_n])
				if @player.nil?
					@player = Player.new
					@player.password = params[:password]
					@player.n_n = params[:n_n] #nickname
					@player.e_m = params[:e_m] #email
		
					@player.generate_token("0") #auth_token
					@ok = @player.save
				else
					#validate password here
					if @player.auth(params[:password])
						@player.generate_token("1") #do not delete existing tokens  
						#@player.nickname = params[:nickname]
						@player.e_m = params[:e_m] #email
						@ok = @player.save
					else
						@unauthorized = true
					end
				end
				
			else
				#player has been found...check password now.
				#if password fails, send login failed error to client
				#error codes via http or just error strings??
				#if @player.authenticate_with_new_token(params[:password])
				if @player.auth(params[:password])
					@player.generate_token("1") #do not delete existing tokens  
					@player.n_n = params[:n_n]
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