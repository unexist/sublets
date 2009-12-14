#
# Cmus
#
# Author: Brandon Hartshorn
# Contact: sharntehnub@gmail.com
# Description: Shows what song is currently playing in cmus
# Version: 0.1
# Date: Sat Nov 14 13:13 MST 2009
# Tags: Notify
#

class Cmus < Subtle::Sublet
  def initialize
    @file = "/tmp/cmus-status"

    watch @file
  end

  def run
    begin self.data = IO.readlines.first.chop
    rescue => err
      puts err
      self.data = "[BROKE]"
    end
  end
end 
