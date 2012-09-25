class PlayerService

  def self.create(params)
	#check for facebookId if it is sent in
	#make sure nickname and email are unique
	
	@error = Error.new
	@unauthorized = false
  
		if !params[:fb].blank?
			@player = Player.find_by_fb(params[:fb])
			if @player.nil?
				@player = Player.new
				@player.fb = params[:fb] #facebook_id
				#@player.password = ""
			end
	 
			@player.n_v = @player.n_v + 1
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
					@player.password = params[:p_w]
					@player.n_n = params[:n_n] #nickname
					@player.e_m = params[:e_m] #email
					@player.n_v = 1
		
					@player.generate_token("0") #auth_token
					@ok = @player.save
				else
					#validate password here
					if @player.auth(params[:p_w])
						@player.generate_token("1") #do not delete existing tokens  
						#@player.nickname = params[:nickname]
						@player.e_m = params[:e_m] #email
						@player.n_v = @player.n_v + 1
						
						if Player.where( :e_m => params[:e_m], :id.ne => @player.id ).count > 0
						Rails.logger.debug("duplicate email #{params[:e_m].inspect}")
						#if Player.exists?(:e_m => params[:e_m])
							#email is taken
							@error.code = "2"
							#@unauthorized_reason = "2" 
							@unauthorized = true
						else
							@ok = @player.save
						end
						
						@ok = @player.save
					else
					    @error.code = "1"
						#@unauthorized_reason = "1" 
						@unauthorized = true
					end
				end
				
			else
			Rails.logger.debug("player has been found by email inspect #{@player.inspect}")
				#player has been found by email...check password and make sure nickname is not duplicated.
				#if password fails, send login failed error to client
				#error codes via http or just error strings??
				#if @player.authenticate_with_new_token(params[:password])
				
				if @player.auth(params[:p_w])
				Rails.logger.debug("player has been authorized with password #{params[:p_w].inspect}")
					@player.generate_token("1") #do not delete existing tokens  
					@player.n_n = params[:n_n]
					@player.n_v = @player.n_v + 1
					if Player.where( :n_n => params[:n_n], :id.ne => @player.id ).count > 0
					Rails.logger.debug("duplicate nickname #{params[:n_n].inspect}")
					#if Player.exists?(:n_n => params[:n_n], !:id => @player.id )
						#nickname is taken
						@error.code = "3"
						#@unauthorized_reason = "3" 
						@unauthorized = true
					else
						@ok = @player.save
					end
	
					#@ok = @player.save
					 
				else
				Rails.logger.debug("player has not been authorized with password #{params[:p_w].inspect}")
					@error.code = "1"
					#@unauthorized_reason = "1" 
					@unauthorized = true
				end	
			end
		end	
		
		return @player, @unauthorized, @error
	end


end