class AddColumnsToCategoryTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :category_templates, :entry_fee_foreigner, :jsonb,  default: {required: false, optional: false}
    add_column :category_templates, :allow_like, :jsonb,  default: {required: false, optional: false}
    add_column :category_templates, :allow_comment, :jsonb,  default: {required: false, optional: false}
    add_column :category_templates, :allow_ratings, :jsonb,  default: {required: false, optional: false}
    add_column :category_templates, :allow_ratings_comment, :jsonb,  default: {required: false, optional: false}

  end
end
