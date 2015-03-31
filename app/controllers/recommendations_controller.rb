class RecommendationsController < ApplicationController

  around_filter :shopify_session, except: [:create]

  def show
    @recommendation = Recommendation.find(params[:id])
  end

  def index
    @recommendations = Recommendation.includes(:customer, :product).all
  end

  def create
    product = Product.find_or_create_by(product_params.merge(shop_id: get_shop_id))
    customer = Customer.find_or_create_by(customer_params.merge(shop_id: get_shop_id))
    Recommendation.create recommendation_params.merge(product_id: product.id, customer_id: customer.id)
    redirect_to(:back)
  end

  private

  def customer_params
    params.require(:customer).permit(:customer_id,:name, :email)
  end

  def recommendation_params
    params.require(:recommendation).permit(:email,:comment, :product_id, :product_name, :product_url) 
  end

  def product_params
    params.require(:product).permit(:product_id, :name, :description, :url, :price)
  end

  def get_shop_id
    shop = Shop.find_by(domain: params[:shop][:domain])
    shop.id
  end

end
