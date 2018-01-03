class RouterTrackerController < ActionController::Base
  def check_updates
    CheckUpdateBusiness.new.connect
    render json: OrderLocation.last
  end
end
