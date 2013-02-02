class Device
  include MongoMapper::EmbeddedDocument
	 
	key :r_id, String #registration_id
	#key :i_a, Boolean, :default => false #is_android
	key :i_ur, Boolean, :default => false #is_unregistered
	key :l_r_d, Time #last_registration_date 
	key :a_t, String #auth_token 
	key :a_t_d, Time #auth_token_date, only reset auth_token about once a week, use this data as a guide 
	
	timestamps!

	def is_android
		!self.r_id.blank?
	end
	
end