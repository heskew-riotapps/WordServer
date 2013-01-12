object @player 

attributes :id, :fb, :f_n, :l_n, :n_n, :n_w, :e_m, :gravatar, :a_t, :o_n_i_a, :l_rf_d

child :opponents do
	attribute :n_g 
	child :player do
		attribute :id, :fb, :f_n, :l_n, :n_n, :gravatar, :n_w
	end
end

child :a_games => :a_games do
  attribute :id, :cr_d, :ch_d, :t, :l_t_a, :l_t_d, :l_t_p, :l_t_pl
  child :player_games do
    attribute :sc, :i_t, :st   
		child :player do
		attribute :id, :fb, :f_n, :l_n, :n_n, :gravatar, :n_w
	end
  end
  child :played_words do
	attribute :w, :t, :player_id, :p_s, :p_d 
  end
end

child :c_games => :c_games do
  attribute :id, :cr_d, :co_d, :ch_d, :t, :st, :l_t_a,:l_t, :l_t_p, :l_t_d, :l_t_pl, :r_v, :r_c
  child :player_games do
    attribute :sc, :st 
		child :player do
		attribute :id, :fb, :f_n, :l_n, :n_n, :gravatar, :n_w
	end
  end
end