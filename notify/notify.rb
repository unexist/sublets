# Notify sublet file
# Created with sur-0.1
configure :notify do |s|
  s.file = ENV["HOME"] + "/notify.log"

  s.watch(s.file)
end

on :run do |s|
  begin
    s.data = File.readlines(s.file).to_s.chop
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end  
end
