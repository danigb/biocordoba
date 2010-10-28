module PrintHelper
  def print_data(label, value)
    "<p class='print-data'><label>#{label}</label>#{value}</p>" #if value.present?
  end

  def print_calendar(objects, options = {})
    date = options[:date] || Time.now
    options[:days] ||= 1
    start_date = Date.new(date.year, date.month, date.day)
    end_date = Date.new(date.year, date.month, date.day) + (options[:days] - 1)
    week = (options[:days]) == 1 ? "mini_week" : "week"
    week = "mini_without_hour_week" unless options[:without_hours].blank?
    concat(tag("table", :id => week))
    yield WeeklyPrinter.new(objects || [], self, options, start_date, end_date)
    concat("</table>")
  end

end