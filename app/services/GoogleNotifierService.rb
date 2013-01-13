require 'net/https'
require 'uri'

module GoogleNotifierService
 
    class << self
	 def send_notification(notification)

		logger.info "GoogleNotifierService notification = #{notification.inspect}"
		response = GoogleNotifierService.send_notification_to_gcm(notification)
		logger.info "response = #{response.inspect}"

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
			  logger.warn("GCM error=#{ex.message}, destroying gcm_device with id #{notification.device.id}")
			  notification.device.destroy
			when "InvalidRegistration"
			  ex = Gcm::Errors::InvalidRegistration.new(response[:message])
			  logger.warn("#{ex.message}, destroying gcm_device with id #{notification.device.id}")
			  notification.device.destroy
			when "MismatchedSenderId"
			  ex = Gcm::Errors::MismatchSenderId.new(response[:message])
			  logger.warn(ex.message)
			when "NotRegistered"
			  ex = Gcm::Errors::NotRegistered.new(response[:message])
			  logger.warn("#{ex.message}, destroying gcm_device with id #{notification.device.id}")
			  notification.device.destroy
			when "MessageTooBig"
			  ex = Gcm::Errors::MessageTooBig.new(response[:message])
			  logger.warn(ex.message)
			else
			  notification.sent_at = Time.now
			  notification.save!
		  end
		elsif response[:code] == 401
		  raise Gcm::Errors::InvalidAuthToken.new(message_data)
		elsif response[:code] == 503
		  raise Gcm::Errors::ServiceUnavailable.new(message_data)
		elsif response[:code] == 500
		  raise Gcm::Errors::InternalServerError.new(message_data)
		end
    end
	
      def send_notification_to_gcm(notification)
		api_key = configatron.gcm_on_rails.api_key
        #if format == 'json'
          headers = {"Content-Type" => "application/json",
                     "Authorization" => "key=#{api_key}"}

          data = notification.data.merge({:collapse_key => notification.collapse_key}) unless notification.collapse_key.nil?
          data = data.merge({:delay_while_idle => notification.delay_while_idle}) unless notification.delay_while_idle.nil?
          data = data.merge({:time_to_live => notification.time_to_live}) unless notification.time_to_live.nil?
          data = data.to_json
        #else   #plain text format
        #  headers = {"Content-Type" => "application/x-www-form-urlencoded;charset=UTF-8",
        #             "Authorization" => "key=#{api_key}"}
		#
        #  post_data = notification.data[:data].map{|k, v| "&data.#{k}=#{URI.escape(v)}".reduce{|k, v| k + v}}[0]
        #  extra_data = "registration_id=#{notification.data[:registration_ids][0]}"
		#  #extra_data = "registration_id=#{notification.r_id}"
        #  extra_data = "#{extra_data}&collapse_key=#{notification.collapse_key}" unless notification.collapse_key.nil?
        #  extra_data = "#{extra_data}&delay_while_idle=1" if notification.delay_while_idle
        #  data = "#{extra_data}#{post_data}"
        #end

        url_string = configatron.gcm_on_rails.api_url
        url = URI.parse url_string
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        resp, dat = http.post(url.path, data, headers)

        return {:code => resp.code.to_i, :message => dat }
      end

      def open
        configatron.gcm_on_rails.api_key
      end
    end
  end
 
end