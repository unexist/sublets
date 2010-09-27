# Testy sublet file
# Created with sur-0.2
configure :testy do |s|
  s.interval = 60
end

HOOKS = [
  :client_create,
  :client_configure,
  :client_focus,
  :client_kill,
  :tag_create,
  :tag_kill,
  :view_create,
  :view_configure,
  :view_focus,
  :view_kill,
  :exit
]

EVENTS = [
  :run,
  :mouse_down,
  :mouse_over,
  :mouse_out
]

(EVENTS | HOOKS).each do |h|
  on h do |s|
    puts h
  end
end
