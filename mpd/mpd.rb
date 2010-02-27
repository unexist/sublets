# Mpd sublet file                                                                                              
# Created with sur-0.1                                                                                            
require "socket"

configure :mpd do |s| # {{{
  # Icons
  s.icons = {
    :play  => Subtle::Icon.new("play.xbm"),
    :pause => Subtle::Icon.new("pause.xbm"),
    :stop  => Subtle::Icon.new("stop.xbm"),
    :prev  => Subtle::Icon.new("prev.xbm"),
    :next  => Subtle::Icon.new("next.xbm"),
    :note  => Subtle::Icon.new("note.xbm")
  }

  # Options
  s.host     = "localhost"
  s.port     = 6600
  s.debug    = true
  s.interval = 999

  # Connect
  if(s.connect(s.host, s.port))
    idle
    watch(self.socket) #< Start socket watching
  end
end # }}}

helper do |s| # {{{

  ## shutdown {{{
  # Shutdown connection
  ##

  def shutdown
    unwatch #< Stop watching socket

    self.socket = nil
    self.state  = :off

    update_status
  end # }}}

  ## connect {{{
  # Open connection to mpd
  # @param [String, #read]  host  Hostname
  # @param [Fixnum, #read]  port  Port
  # @return [Bool] Whether connection succeed
  ##

  def connect(host, port)
    begin
      self.socket = TCPSocket.new(host, port)

      # Handle SIGPIPE
      trap "PIPE" do
        shutdown
        puts "mpd signal: SIGPIPE" if(self.debug)
      end

      safe_read(1) #< Wait for mpd header
      update_status

      true
    rescue
      update_status

      false
    end
  end # }}}

  ## disconnect {{{
  # Send close and shutdown
  ###

  def disconnect
    unless(self.socket.nil?)
      safe_write("close")

      shutdown
    end
  end # }}}

  ## safe_read {{{
  # Read data from socket
  # @param [Fixnum, #read]  timeout  Timeout in seconds
  # @return [String] Read data
  ##

  def safe_read(timeout = 0)
    line = ""

    begin
      sets = select([ self.socket ], nil, nil, timeout)
      line = self.socket.readline unless(sets.nil?) #< No nil is a socket hit

      puts "mpd read: %s" % [ line ] if(self.debug)
    rescue EOFError
      shutdown
      puts "mpd read: EOF" if(self.debug)
    rescue
      shutdown
    end

    line
  end # }}}

  ## safe_write {{{
  # Write dats to socket
  # @param [String, #read]  str  String to write
  ##

  def safe_write(str)
    begin
      self.socket.write("%s\n" % [ str ]) unless(self.socket.nil?)

      puts "mpd write: %s" % [ str ] if(self.debug)
    rescue
      shutdown
    end
  end # }}}

  ## idle {{{
  # Send idle command
  ## 

  def idle
    safe_write("idle player")
  end # }}}

  ## noidle {{{
  # Send noidle command
  ###

  def noidle
    safe_write("noidle")
  end # }}}

  ## get_reply {{{
  # Send command and return reply as hash
  # @oaran [String, #read]  command  Command to send
  # return [Hash] Data hash
  ###

  def get_reply(command)
    hash = {}

    begin
      safe_write(command)

      while
        line = safe_read(1)

        # Check response
        if(line.match(/^OK/))
          break
        elsif((match = line.match(/^ACK \[(.*)\] \{(.*)\} (.*)/)))
          s.state = :error

          puts "mpd error: %s" % [ match[3] ]

          safe_write("clearerror")

          break
        elsif((match = line.match(/^(\w+): (.+)$/)))
          hash[match[1].downcase] = match[2]
        end
      end
    rescue
      hash = {}
    end

    puts hash.inspect if(self.debug)

    hash
  end # }}}

  ## get_status {{{
  # Get mpd status
  # return [Hash]  Status hash
  ###

  def get_status
    unless(self.socket.nil?)
      status = get_reply("status")

      # Convert state
      self.state = case status["state"]
        when "play"  then :play
        when "pause" then :pause
        when "stop"  then :stop
        else :off
      end

      puts "mpd status: %s" % [ status["state"] ] if(self.debug)

      status
    end
  end # }}}

  ## get_ok {{{
  # Get ok or error
  # @param [Fixnum, #read]  timeout  Timeout in seconds
  # @return [Bool] Whether mpd return ok
  ##

  def get_ok(timeout = 0)
    unless(self.socket.nil?)
      line = safe_read(timeout)
      line = safe_read(timeout) if(line.match(/^changed/)) #< Skip changed message

      # Check result
      if(line.match(/^OK/))
        true
      elsif((match = line.match(/^ACK \[(.*)\] \{(.*)\} (.*)/)))
        s.state = :error

        puts "mpd error: %s" % [ match[3] ]

        safe_write("clearerror")

        false
      else
        puts "mpd error: expected ok - got: %s" % [ line ] if(self.debug)

        false
      end
    end
  end # }}}

  ## update_status {{{
  # Update status and set data
  ##

  def update_status
    mesg = "mpd not running"
    icon = :play

    unless(self.socket.nil?)
      get_status

      if(:play == self.state or :pause == self.state)
        song = get_reply("currentsong")

        # Select icon
        icon = case self.state
          when :play  then :pause
          when :pause then :play
        end

        # Sanity?
        artist = song["artist"] || "unknown"
        title  = song["title"]  || File.basename(song["file"])

        mesg = " %s%s - %s" % [ self.icons[:note], artist, title ]
      elsif(:stop == self.state)
        mesg = "mpd stopped"
        icon = :play
      end
    end

    self.data = "%s%s%s%s %s" % [ 
      self.icons[icon], self.icons[:stop], self.icons[:prev], self.icons[:next], mesg
    ]
  end # }}}
end # }}}

on :mouse_down do |s, x, y, b| # {{{
  if(s.socket.nil?)
    connect(s.host, s.port) 

    watch(self.socket)
  else
    noidle
    get_ok(1)
  end

  # Send to socket
  safe_write(
    case x
      when 0..14
        case s.state
          when :stop  then "play"
          when :pause then "pause 0"
          when :play  then "pause 1"
        end
      when 15..28 then "stop"
      when 29..42 then "previous"
      when 43..56 then "next"
    end
  )
end # }}}

on :watch do |s| # {{{
  get_ok(1)
  update_status
  idle
end # }}}
