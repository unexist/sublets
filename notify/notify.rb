# Notify sublet file
# Created with sur-0.2.168

require "/home/unexist/projects/subtlext-dbus/subtlext_dbus.so"

DBUS_NAME  = "org.freedesktop.Notifications"
DBUS_PATH  = "/org/freedesktop/Notifications"
DBUS_IFACE = "org.freedesktop.Notifications"

# Sublet
configure :notify do |s| # {{{
  s.messages = []

  # DBus
  s.dbus = Subtlext::DBus.new(Subtlext::DBus::SESSION)

  s.dbus.request_name(DBUS_NAME)
  s.dbus.add_match({path: DBUS_PATH, interface: DBUS_IFACE})

  s.dbus.interface DBUS_IFACE do
    method "Notify" do |args|
      s.messages << args

      reply ""
    end

    method "GetServerInformation" do |args|
      reply [ "subtle", "http://subtle.subforge.org", "0.0", "0.9" ]
    end

    method "GetCapabilities" do |args|
      reply "body"
    end
  end

  # Initial run
  s.dbus.update

  # Get colors
  colors = Subtlext::Subtle.colors

  # Get config values
  font = s.config[:font] || "-*-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
  fg   = Subtlext::Color.new(s.config[:foreground] || colors[:sublets_fg])
  bg   = Subtlext::Color.new(s.config[:background] || colors[:sublets_bg])
  s.hl = Subtlext::Color.new(s.config[:highlight]  || colors[:focus_fg])

  # Icon
  s.icon = Subtlext::Icon.new("info.xbm")

  # Window
  s.win = Subtlext::Window.new(:x => 0, :y => 0, :width => 1, :height => 1) do |w|
    w.name        = "Sublet notify"
    w.font        = font
    w.foreground  = fg
    w.background  = bg
    w.border_size = 0
  end

  # Font metrics
  s.font_height = s.win.font_height
  s.font_y      = s.win.font_y

  # Watch socket
  s.watch(s.dbus.socket)

  s.data = s.icon.to_s
end # }}}

on :watch do |s| # {{{
  # Fetch messages
  s.dbus.update

  unless(s.messages.empty?)
    s.data = "%s%s" % [ s.hl, s.icon ]
  end
end # }}}

on :mouse_over do |s| # {{{
  # Show and print messages
  unless(s.messages.empty?)
    x      = 0
    y      = 0
    width  = 0
    height = 0

    s.win.clear

    # Write each message and calculate window width
    s.messages.each_index do |i|
      size    = s.win.write(2, height + s.font_y, s.messages[i][3][0..50])
      width   = size if(size > width) #< Get widest
      height += s.font_height
    end

    # Orientation
    screen_geom = s.screen.geometry
    sublet_geom = s.geometry

    # X position
    if(sublet_geom.x + width > screen_geom.x + screen_geom.width)
      x = screen_geom.x + screen_geom.width - width #< x + width > screen width
    else
      x = sublet_geom.x #< Sublet x
    end

    # Y position
    if(sublet_geom.y + height > screen_geom.y + screen_geom.height)
      y = screen_geom.y + screen_geom.height - height #< Bottom
    else
      y = sublet_geom.y + sublet_geom.height #< Top
    end

    s.win.geometry = [ x, y, width, height ]

    s.win.show
  end
end # }}}

on :mouse_out do |s| # {{{
  # Hide window
  unless(s.messages.empty?)
    s.win.hide
    s.messages = []
    s.data     = s.icon.to_s
  end
end # }}}

on :unload do |s| # {{{
  # Tidy up
  s.win.kill unless(s.win.nil?)
end # }}}
