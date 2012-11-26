object @game 

  attributes :id, :cr_d, :lp_d, :ch_d, :t, :a_t, :left, :st
  child :player_games do
    attributes :o, :i_t, :sc, :id, :t_l, :l_t, :l_t_p, :l_t_a, :l_t_d, :st, :t_v
		child :player do
		attribute :id, :fb, :f_n, :l_n, :n_n, :gravatar, :n_w
	end
  end
 
