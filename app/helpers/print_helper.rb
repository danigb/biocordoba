module PrintHelper
  def print_data(label, value)
    "<p><label>#{label}</label>#{value}</p>" #if value.present?
  end
end