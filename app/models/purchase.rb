require 'net/http'
require 'open-uri'

class Purchase < ActiveRecord::Base
	cattr_reader :user

	# before_create :authenticate_api_user
	after_create :create_payment_info_in_easle


	def authenticate_api_user
		easle_api_url = URI("http://easledemo.smarton.co/api/sessions")
		params = {}
		params[:user] = { :email => "admin@smarton.co", :password => "5marton1" }
		response = Net::HTTP.post_form(easle_api_url, params)
		puts "api response -> #{response.body}"
	end

	def create_payment_info_in_easle
		easle_api_url = URI("http://easledemo.smarton.co/website_payment_info")
		puts "url -> #{easle_api_url}"
		params =  { :course_name => self.product_id, :student_name => self.email, :email_id => self.email, :transaction_token => self.charge_id,
		 :amount => self.amount, :currency => self.currency, :gateway => "stripe", status: "success" }

		response = Net::HTTP.post_form(easle_api_url, params) 
		puts "api response -> #{response.body}"
		return response
	end
end
