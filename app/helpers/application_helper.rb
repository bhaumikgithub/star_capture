module ApplicationHelper

  def is_category?
    Category.first.present?
  end
end
