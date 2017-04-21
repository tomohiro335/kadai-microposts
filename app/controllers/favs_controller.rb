class FavsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    target_micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(target_micropost)
    flash[:success] = '対象のマイクロポストをお気に入り登録しました。'
redirect_back(fallback_location: root_path)
  end

  def destroy
    target_micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(target_micropost)
    flash[:success] = '対象のマイクロポストのお気に入りを解除しました。'
    redirect_back(fallback_location: root_path)
  end
end
