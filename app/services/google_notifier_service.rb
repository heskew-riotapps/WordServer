require 'net/https'
require 'uri'

class GoogleNotifierService
  
	def self.send_notification(notification)
		api_key = configatron.gcm_on_rails.api_key #GoogleNotifierService.open #Gcm::Connection.open

		logger.info "notification = #{notification.inspect}"
		response = GoogleNotifierService.send_notification_to_gcm(notification, api_key)
		logger.info "response = #{response.inspect}"

		if response[:code] == 200
			if response[:message].nil?
			# TODO - Making this assumption might not be right. HTTP status code 200 does not really signify success
			# if Gcm servers returned nil for the message
				error = "success"
				message_data = JSON.parse response[:message]
				success = message_data['success']
				error = message_data['results'][0]['error']  if success == 0
			end
		

			case error
				when "MissingRegistration"
					ex = Gcm::Errors::MissingRegistration.new(response[:message])
					logger.warn("GCM MissingRegistration Error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
					# notification.device.destroy
				when "InvalidRegistration"
					ex = Gcm::Errors::InvalidRegistration.new(response[:message])
					logger.warn("GCM InvalidRegistration Error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
					# notification.device.destroy
				when "MismatchedSenderId"
					ex = Gcm::Errors::MismatchSenderId.new(response[:message])
					logger.warn("GCM MismatchSenderId Error=#{ex.message}")
				when "NotRegistered"
					ex = Gcm::Errors::NotRegistered.new(response[:message])
					logger.warn("GCM NotRegistered error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
					#notification.device.destroy
				when "MessageTooBig"
					ex = Gcm::Errors::MessageTooBig.new(response[:message])
					logger.warn("GCM MessageTooBig Error=#{ex.message}")
				else
					notification.sent_at = Time.now
					notification.st = 2 #sent
					notification.save!
			end
		elsif response[:code] == 401
			logger.warn("GCM InvalidAuthToken error")
			#raise Gcm::Errors::InvalidAuthToken.new(message_data)
		elsif response[:code] == 503
			logger.warn("GCM ServiceUnavailable error")
			#raise Gcm::Errors::ServiceUnavailable.new(message_data)
		elsif response[:code] == 500
			logger.warn("GCM InternalServerError error")
			#raise Gcm::Errors::InternalServerError.new(message_data)
		end

	end
	
    def self.send_notification_to_gcm(notification, api_key, format)
        headers = {"Content-Type" => "application/json", "Authorization" => "key=#{api_key}"}

        data = notification.data.merge({:collapse_key => notification.collapse_key}) unless notification.collapse_key.nil?
        data = data.merge({:delay_while_idle => notification.delay_while_idle}) unless notification.delay_while_idle.nil?
        data = data.merge({:time_to_live => notification.time_to_live}) unless notification.time_to_live.nil?
        data = data.to_json

		url_string = configatron.gcm_on_rails.api_url
        url = URI.parse url_string
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        resp, dat = http.post(url.path, data, headers)

        return {:code => resp.code.to_i, :message => dat }
    end

end