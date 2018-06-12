class CreateTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :templates do |t|
      t.string :template_name
      t.jsonb :name,  default: {required: false, optional: false}
      t.jsonb :price,  default: {required: false, optional: false}
      t.jsonb :description,  default: {required: false, optional: false}
      t.jsonb :short_description,  default: {required: false, optional: false}
      t.jsonb :image,  default: {required: false, optional: false}
      t.jsonb :multiple_images,  default: {required: false, optional: false}
      t.jsonb :google_map_link,  default: {required: false, optional: false}
      t.jsonb :product_type,  default: {required: false, optional: false}
      t.jsonb :map_location,  default: {required: false, optional: false}
      t.jsonb :location,  default: {required: false, optional: false}
      t.jsonb :mon_to_sat_on,  default: {required: false, optional: false}
      t.jsonb :mon_to_sat_open_time,  default: {required: false, optional: false}
      t.jsonb :mon_to_sat_close_time,  default: {required: false, optional: false}
      t.jsonb :entry_fee_adult,  default: {required: false, optional: false}
      t.jsonb :entry_fee_toddler,  default: {required: false, optional: false}
      t.jsonb :entry_fee_child,  default: {required: false, optional: false}
      t.jsonb :entry_fee_senior_citizen,  default: {required: false, optional: false}
      t.jsonb :ratings,  default: {required: false, optional: false}
      t.jsonb :parking_type,  default: {required: false, optional: false}
      t.jsonb :parking_fees,  default: {required: false, optional: false}

      t.timestamps
    end
  end
end
