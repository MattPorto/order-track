require "#{Rails.root}/app/business/check_update_business"

namespace :customs do
  task check_updates: :environment do
    CheckUpdateBusiness.new.connect
  end
end
