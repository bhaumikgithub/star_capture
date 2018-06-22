module ApplicationHelper

  def is_category?
    Category.first.present?
  end

  def from_to_date(resource) 
    if resource.start_date.present? && resource.end_date.present?
      date = resource.start_date.strftime("%d %b %Y")+' - '+resource.end_date.strftime("%d %b %Y")
    elsif resource.start_date.present? && !resource.end_date.present?
      date = resource.start_date.strftime("%d %b %Y")
    elsif resource.not_fixed
      date = 'Not fixed '
    end
    date
  end
end
