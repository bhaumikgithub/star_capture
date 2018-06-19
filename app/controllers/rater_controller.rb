class RaterController < ApplicationController

  def create
    if user_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, current_user, params[:dimension]

      render :json => true
    else
      render :json => false
    end
  end

  def update
    @rate = Rate.find_by(rater_id: current_user.id, rateable_id: params[:id])
    if @rate
      @rate.update(comment: params[:comment])
    else
      flash[:alert] = "Please give rating first"
    end
    @rates = Rate.all.order('created_at DESC')
    respond_to do |format|
      format.js
    end
  end
end
