# Notify sublet file
# Created with sur-0.1
configure :notify do |s|
  s.file = ENV["HOME"] + "/notify.log"

  s.watch(s.file)
  s.hide
end

on :watch do |s|
  begin
    s.data = File.readlines(s.file).join.chop
    s.show
  rescue => err # Sanitize to prevent unloading
    s.data = ""
    s.hide
    p err
  end  
end

on :run do |s|
  # Do nothing
end
