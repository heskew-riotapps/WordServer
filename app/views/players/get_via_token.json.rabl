object @player 

attributes :id, :fb, :f_n, :l_n, :n_n, :n_w, :e_m, :gravatar, :a_t, :o_n_i_a, :l_rf_d

child :opponents do
	attribute :n_g 
	child :player do
		attribute :id, :fb, :f_n, :l_n, :n_n, :gravatar, :n_w
	end
end
 
 