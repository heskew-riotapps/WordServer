class Device
  include MongoMapper::EmbeddedDocument
	 
	key :r_id, String #registration_id
	key :i_a, Boolean, :default => false #is_android
	key :i_ur, Boolean, :default => false #is_unregistered
	key :l_r_d, Time #last_registration_date 
	key :a_t, String #auth_token 
	
	timestamps!

end