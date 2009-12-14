#
# Tasks
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the clients per view
# Version: 0.1
# Date: Tue Dec 1 23:00 CET 2009
# Tags: DSL
#

configure :tasks do |s|
  s.interval  = 60
  s.col_norm  = Subtle::Color.new(COLORS[:fg_views])
  s.col_high  = Subtle::Color.new(COLORS[:fg_focus])
  s.clients   = current_view.clients
end

helper do |s|
  def makelist(list)
    out = ""

    # Sort by gravity
    self.clients = list.sort do |a, b|
      if(!a.nil? && !b.nil?)
        a.gravity.id <=> b.gravity.id
      else
        -1
      end
    end

    # Find client with focus
    self.clients.each do |c|
      if(c.has_focus?)
        out << "#{self.col_high}#{c.name} "
      else
        out << "#{self.col_norm}#{c.name} "
      end
    end

    self.data = out.empty? ? "none" : out.chop #< Skip trailing whitespace
  end
end

on :run do |s|
  s.makelist(s.clients)
end

on :client_focus do |s, c|
  s.makelist(s.clients)
end

on :view_configure do |s, v|
  s.makelist(v.clients)
end
