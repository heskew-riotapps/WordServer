require 'net/https'
require 'uri'

class GoogleNotifierService
  
	def self.send_notification(notification)
		api_key = configatron.gcm_on_rails.api_key #GoogleNotifierService.open #Gcm::Connection.open
		format = "json"
		
		Rails.logger.info "GoogleNotifierService.send_notification notification = #{notification.inspect}"
		response = GoogleNotifierService.send_notification_to_gcm(notification, api_key)
		Rails.logger.info "GoogleNotifierService.send_notification response = #{response.inspect}"

		if response[:code] == 200
			if response[:message].nil?
                # TODO - Making this assumption might not be right. HTTP status code 200 does not really signify success
                # if Gcm servers returned nil for the message
                error = "success"
			elsif format == "json"
				error = ""
				message_data = JSON.parse response[:message]
				success = message_data['success']
				error = message_data['results'][0]['error']  if success == 0
			elsif format == "plain_text"   #format is plain text
				message_data = response[:message]
				error = response[:message].split('=')[1]
			end

			case error
				when "MissingRegistration"
					ex = Gcm::Errors::MissingRegistration.new(response[:message])
					Rails.logger.warn("GCM MissingRegistration Error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
					# notification.device.destroy
					notification.sent_at = Time.now
					notification.st = 3 #error
					notification.e = ex.message
					notification.save
				when "InvalidRegistration"
					ex = Gcm::Errors::InvalidRegistration.new(response[:message])
					Rails.logger.warn("GCM InvalidRegistration Error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
					notification.sent_at = Time.now
					notification.st = 3 #error
					notification.e = ex.message
					notification.save
					# notification.device.destroy
				when "MismatchedSenderId"
					ex = Gcm::Errors::MismatchSenderId.new(response[:message])
					Rails.logger.warn("GCM MismatchSenderId Error=#{ex.message}")
					notification.sent_at = Time.now
					notification.st = 3 #error
					notification.e = ex.message
					notification.save
				when "NotRegistered"
					ex = Gcm::Errors::NotRegistered.new(response[:message])
					Rails.logger.warn("GCM NotRegistered error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
					#notification.device.destroy
					notification.sent_at = Time.now
					notification.st = 3 #error
					notification.e = ex.message
					notification.save
				when "MessageTooBig"
					ex = Gcm::Errors::MessageTooBig.new(response[:message])
					Rails.logger.warn("GCM MessageTooBig Error=#{ex.message}")
				else
					#notification.sent_at = Time.now
					#notification.st = 2 #sent
					
					#Rails.logger.warn("GoogleNotifierService Error=#{error} notification will be deleted")
					#notification.delete ####probably 
			end
		elsif response[:code] == 400
			Rails.logger.warn("GCM Invalid Json error")
			notification.sent_at = Time.now
			notification.st = 3 #error
			notification.e = "GCM Invalid json error"
			notification.save
		elsif response[:code] == 401
			Rails.logger.warn("GCM InvalidAuthToken error")
			notification.sent_at = Time.now
			notification.st = 3 #error
			notification.e = "GCM InvalidAuthToken error"
			notification.save
			#raise Gcm::Errors::InvalidAuthToken.new(message_data)
		elsif response[:code] == 503
			Rails.logger.warn("GCM ServiceUnavailable error")
			notification.sent_at = Time.now
			notification.st = 3 #error
			notification.e = "GCM ServiceUnavailable error"
			notification.save
			#raise Gcm::Errors::ServiceUnavailable.new(message_data)
		elsif response[:code] == 500
			Rails.logger.warn("GCM InternalServerError error")
			notification.sent_at = Time.now
			notification.st = 3 #error
			notification.e = "GCM InternalServerError error"
			notification.save
			#raise Gcm::Errors::InternalServerError.new(message_data)
		end

	end
	
    def self.send_notification_to_gcm(notification, api_key)
        headers = {"Content-Type" => "application/json", "Authorization" => "key=#{api_key}"}

        #data = notification.data.merge({:collapse_key => notification.collapse_key}) unless notification.collapse_key.nil?
        #data = data.merge({:delay_while_idle => notification.delay_while_idle}) unless notification.delay_while_idle.nil?
        #data = data.merge({:time_to_live => notification.time_to_live}) unless notification.time_to_live.nil?
        #data = data.to_json
		data = { :registration_ids => [notification.r_id], :delay_while_idle => notification.delay_while_idle, :collapse_key => notification.collapse_key,
				:time_to_live => notification.time_to_live, :data => notification.data}.to_json

		Rails.logger.warn("GCM send_notification_to_gcm json data=#{data.inspect}")
		
		url_string = configatron.gcm_on_rails.api_url
        url = URI.parse url_string
		
		#Rails.logger.warn("GCM send_notification_to_gcm url=#{url.inspect}")
		
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        resp, dat = http.post(url.path, data, headers)

		Rails.logger.warn("GCM send_notification_to_gcm resp=#{resp.inspect}")
		#Rails.logger.warn("GCM send_notification_to_gcm dat=#{dat.inspect}")
        return {:code => resp.code.to_i, :message => dat }
    end

end