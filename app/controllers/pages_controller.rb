class PagesController < ApplicationController
  before_filter :get_event_counts

  def get_event_counts
    @high ||= Event.event_count_for(1)
    @medium ||= Event.event_count_for(2)
    @low ||= Event.event_count_for(3)
    @all ||= Event.all(:include => :sig)
  end

  def dashboard
    
    unless @all.blank?
      @g_event_severity ||= open_flash_chart_object(400,200, pie_event_severity_graph_url(:high => @high, :medium => @medium, :low => @low))
      @g_category_information ||= open_flash_chart_object(400,200, bar_event_severity_graph_url(:high => @high, :medium => @medium, :low => @low, :all => @all.size))
    end
    
    @events ||= @all
    @uniq_events ||= Event.all :group => 'signature'
    @uniq_adds ||= Iphdr.find(:all, :group => 'ip_src').uniq.size + Iphdr.find(:all, :group => 'ip_dst').uniq.size
    @categories ||= SigClass.all
    @sensors ||= Sensor.all :include => :events, :order => 'sid ASC'
  end

  def credits
  end

end
