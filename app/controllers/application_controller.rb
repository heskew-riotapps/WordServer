class ApplicationController < ActionController::Base
  protect_from_forgery
  	#	Rails.logger.info("application controller I18n.locale: #{I18n.locale}")
	#	 I18n.reload!
	#	I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	# Rails.logger.info("application controller I18n.locale: #{I18n.locale}")

	
	#def extract_locale_from_accept_language_header
	#	request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
	#end
end
