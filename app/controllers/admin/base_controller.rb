class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  layout 'admin'

  private

  def ensure_admin
    return if current_user.admin?

    flash[:alert] = "You must be an administrator to access this page."
    redirect_to root_path
  end
end
