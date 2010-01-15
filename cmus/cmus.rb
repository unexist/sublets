# Cmus sublet file
# Created with sur-0.1
configure :cmus do |s|
  s.file = "/tmp/cmus-status"

  s.watch(s.file)
end

on :run do |s|
  begin 
    s.data = IO.readlines(s.file).first.chop
  rescue => err
    puts err
    s.data = "[BROKE]"
  end
end 
