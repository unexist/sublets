# -*- encoding: utf-8 -*-
# Spotify specification file
# Created with sur-0.2
Sur::Specification.new do |s|
  # Sublet information
  s.name        = "Spotify"
  s.version     = "0.0"
  s.tags        = [ "Music", "DBus" ]
  s.files       = [ "spotify.rb" ]
  s.icons       = [
    "icons/play.xbm",
    "icons/pause.xbm",
    "icons/stop.xbm",
    "icons/prev.xbm",
    "icons/next.xbm"
  ]

  # Sublet description
  s.description = "Just show controls for spotify"
  s.notes       = <<NOTES
This sublet just provides player control icons for spotify.
NOTES

  # Sublet authors
  s.authors     = [ "Christoph Kappel" ]
  s.contact     = "unexist@subforge.org"
  s.date        = "Fri Nov 06 11:10 CET 2015"

  # Sublet config
  #s.config = [
  #  {
  #    :name        => "Value name",
  #    :type        => "Value type",
  #    :description => "Description",
  #    :def_value   => "Default value"
  #  }
  #]

  # Sublet grabs
  s.grabs = {
    :SpotifyPlay     => "Start playback",
    :SpotifyPause    => "Enable pause mode",
    :SpotifyToggle   => "Toggle pause or start playback",
    :SpotifyStop     => "Stop playback",
    :SpotifyPrevious => "Play previous track",
    :SpotifyNext     => "Play next track"
  }

  # Sublet requirements
  # s.required_version = "0.9.2127"
  s.add_dependency("ruby-dbus", "~> 0.11")
end
