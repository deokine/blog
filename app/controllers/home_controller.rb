class HomeController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :find_articles

  def index
    @action = 'home'
  end


  def find_articles
    @pagy, @articles = pagy(Article.published.order(created_at: :desc), page:params[:page], items: 10 )
  end
end
