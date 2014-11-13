class ChargesController < ApplicationController

	def create

	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :card  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :customer    => customer.id,
	    :amount      => params[:amount],
	    :description => 'Rails Stripe customer',
	    :currency    => 'usd'
	  )

	    purchase = Purchase.create(email: params[:stripeEmail], card: params[:stripeToken], 
	      amount: params[:amount], description: charge.description, currency: charge.currency,
	      customer_id: customer.id, product_id: 1, charge_id: charge.id)

	  redirect_to purchase 	  	

	rescue Stripe::CardError => e
	  flash[:error] = e.message
	  redirect_to charges_path
	end
end