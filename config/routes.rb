Rails.application.routes.draw do
  get 'check_updates' => 'router_tracker#check_updates'
end
