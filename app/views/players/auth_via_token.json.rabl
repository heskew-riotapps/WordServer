object @player 

attributes :id, :fb, :f_n, :l_n, :n_n, :n_w, :e_m, :gravatar, :a_t

child :a_games do
  attribute :id, :cr_d, :lp_d, :ch_d, :t
  child :player_games do
    attribute :sc
		child :player do
		attribute :f_n, :l_n, :n_n, :gravatar, :n_w
	end
  end
end