module ApplicationHelper

  def is_category?
    Category.first.present?
  end

  def from_to_date(resource) 
    if resource.start_date.present? && resource.end_date.present?
      date = resource.start_date.strftime("%d %b")+' - '+resource.end_date.strftime("%d %b")
    elsif resource.start_date.present? && !resource.end_date.present?
      date = resource.start_date.strftime("%d %b")
    elsif resource.not_fixed
      date = 'Not fixed /'+ resource.duration.to_s+" #{resource.duration_type}"
    end
    date
  end
end
