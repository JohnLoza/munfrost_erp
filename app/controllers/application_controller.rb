class ApplicationController < ActionController::Base
  private

  def after_sign_in_path_for(resource)
    inventory_files_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
