object @player 

attributes :id, :fb, :f_n, :l_n, :n_n, :n_w, :e_m, :gravatar, :a_t, :o_n_i_a, :l_rf_d

child :alert => :alerts do
	attribute :ti, :t, :id 
end

child :opponents => :opps do
	attribute :n_g, :st 
	child :player do
		attribute :id, :fb, :f_n, :l_n, :n_n, :gravatar, :n_w
	end
end

child :a_games => :a_games do
  attribute :id, :cr_d, :ch_d, :t, :l_t_a, :l_t_d, :l_t_p, :l_t_pl
  child :player_games do
    attribute :sc, :i_t, :st, :player_id   
  end
  child :played_words do
	attribute :w, :t, :player_id, :p_s, :p_d 
  end
end

child :c_games => :c_games do
  attribute :id, :cr_d, :co_d, :ch_d, :t, :st, :l_t_a,:l_t, :l_t_p, :l_t_d, :l_t_pl, :r_v, :r_c
  child :player_games do
    attribute :sc, :st, :player_id    
  end
end

child :game_ => :game_ do
	attributes :id, :cr_d, :ch_d, :t, :a_t, :left, :st, :l_t_a, :l_t_d, :l_t_p, :l_t_pl, :r_v, :r_c 
	  child :player_games do
		attributes :o, :i_t, :sc, :id, :t_l, :st, :t_v, :player_id    
	  end
	  child :played_words do
		attribute :w, :t, :player_id, :p, :p_d 
	  end
	  child :played_tiles do
		attribute :p, :l_, :t_ 
	  end 
	child :chats do
		attribute :t, :player_id, :ch_d 
	  end
end  