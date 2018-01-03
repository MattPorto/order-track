class CreaterOrderLocation < ActiveRecord::Migration[5.1]
  create_table :order_locations do |t|
    t.string   :message
    t.datetime :checkout
    t.datetime :created_at
  end

end
