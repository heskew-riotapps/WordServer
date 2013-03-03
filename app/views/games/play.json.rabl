object @game 

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
  
 