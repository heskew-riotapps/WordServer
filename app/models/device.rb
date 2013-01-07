class Device
  include MongoMapper::EmbeddedDocument
	 
	key :r_id, String #registration_id
	key :i_a, Boolean #is_android
	key :l_r_d, Time #last_registration_date 
	key :a_t, String #auth_token 
	
	timestamps!

end