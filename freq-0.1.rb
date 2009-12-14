#
# Freq
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the cpu frequence
# Version: 0.1
# Date: Mon May 18 21:00 CET 2009
# Tags: Proc Multicore
#

class Freq < Subtle::Sublet
  def initialize
    self.interval = 120
  end

  def run
    begin
      data = ""
      file = IO.readlines("/proc/cpuinfo").join

      file.scan(/cpu MHz\s+:\s+([0-9.]+)/) do |freq| 
        data << freq.first.to_i.to_s + " Mhz "
      end

      self.data = data.chop
    rescue => err # Sanitize to prevent unloading
      self.data = "subtle"
      p err
    end  
  end
end
