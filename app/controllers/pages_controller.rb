# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  skip_before_action :authenticate_admin!
  def home; end
end
