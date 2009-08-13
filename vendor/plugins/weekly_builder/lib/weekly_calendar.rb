# WeeklyCalendar
module WeeklyHelper
  
  def weekly_calendar(objects, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    date = options[:date] || Time.now
    options[:days] ||= 1
    start_date = Date.new(date.year, date.month, date.day)
    end_date = Date.new(date.year, date.month, date.day) + (options[:days] - 1)
    week = (options[:days]) == 1 ? "mini_week" : "week"
    week = "mini_without_hour_week" unless options[:without_hours].blank?
    concat(tag("div", :id => week))
      yield WeeklyBuilder.new(objects || [], self, options, start_date, end_date)
    concat("</div>")
  end
  
  def weekly_links(options)
    date = options[:date] || Time.now
    start_date = Date.new(date.year, date.month, date.day) 
    end_date = Date.new(date.year, date.month, date.day) + 7
    concat("<a href='?start_date=#{start_date - 7}?user_id='>« Previous Week</a> ")
    concat("#{start_date.strftime("%B %d -")} #{end_date.strftime("%B %d")} #{start_date.year}")
    concat(" <a href='?start_date=#{start_date + 7}?user_id='>Next Week »</a>")
  end
  
  class WeeklyBuilder
    include ::ActionView::Helpers::TagHelper

    def initialize(objects, template, options, start_date, end_date)
      raise ArgumentError, "WeeklyBuilder expects an Array but found a #{objects.inspect}" unless objects.is_a? Array
      @objects, @template, @options, @start_date, @end_date = objects, template, options, start_date, end_date
    
      @hours = ["10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00"]
      @start_hour = 10 
      @end_hour = 19

      if options[:days] > 1
        @header_row = "header_row"
        @day_row = "day_row"
        @grid = "grid"
      else
        @header_row = "mini_header_row"
        @day_row = "mini_day_row"
        @grid = "mini_grid"
      end
    end

    def week(options = {})      
      hours_column(@options[:without_days]) if @options[:without_hours].blank?
      
      concat(tag("div", :id => "hours"))
        days if @options[:without_days].blank?
        
        concat(tag("div", :id => @grid))
          @hours.each do |h|
            concat(tag("div", :id => @day_row))
              (@start_date..@end_date).each_with_index do |day, index|
                to_delete = []
                @objects.each do |event|
                  if event.starts_at.strftime('%j').to_s == day.strftime('%j').to_s
                    if event.starts_at.strftime('%H').to_i == h.to_i
                      concat(tag("div", :id => "week_event", :style =>"left:#{143 * index}px;top:#{left(event.starts_at,options[:business_hours])}px;width:138px;height:#{width(event.starts_at,event.ends_at)}px;", :class => event.pending? ? 'pending' : 'acepted'))
                      truncate = width(event.starts_at,event.ends_at)
                      yield(event,truncate)
                      concat("</div>")

                      to_delete << event
                    end
                  end
                end

                @objects = @objects - to_delete
              end 
            concat("</div>")  
          end
        concat("</div>")
      concat("</div>")
    end
  
    def days      
      concat(tag("div", :id => @header_row)) # id = days
        for day in @start_date..@end_date        
          concat(tag("div", :id => "header_box")) # id = "day"
          # concat(content_tag("b", day.strftime('%A')))
          # concat(tag("br"))
          concat("<a href='/resumen/#{day}' title='Ver resumen del día'>#{day.localize}</a>")
          concat("</div>")
        end
      concat("</div>")      
    end
    
    def hours_column(without_days = false)
      concat(tag("div", :id => "days")) #id = @header_row
        concat(content_tag("div", "&nbsp;", :id => "placeholder")) unless without_days
        for hour in @hours
          concat(content_tag("div", "<b>#{hour}</b>", :id => "day")) # id = header_box
        end
      concat("</div>")
    end
    
    private
    def concat(tag)
      @template.concat(tag)
    end

    def left(starts_at,business_hours)
      if business_hours == "true" or business_hours.blank?
        minutes = starts_at.strftime('%M').to_f * 0.86
      end
    end

    def width(starts_at,ends_at)
      #example 3:30 - 5:30
      # start_hours = starts_at.strftime('%H').to_i * 60 # 3 * 60 = 180
      # start_minutes = starts_at.strftime('%M').to_i + start_hours # 30 + 180 = 210
      # end_hours = ends_at.strftime('%H').to_i * 60 # 5 * 60 = 300
      # end_minutes = ends_at.strftime('%M').to_i + end_hours # 30 + 300 = 330
      # difference =  (end_minutes.to_i - start_minutes.to_i) * 1.07 # (330 - 180) = 150 * 1.25 = 187.5
      difference = (((ends_at - starts_at) / 60) * 0.90).round
      
      unless difference < 15
        width = difference 
      else
        width = 13 #default width (75px minus padding+border)
      end
    end
    
    def truncate_width(width)
      hours = width / 63
      truncate_width = 20 * hours
    end
  end
end
