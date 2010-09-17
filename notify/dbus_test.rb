# Notify sublet file
# Created with sur-0.1.112
require "ffi"

class GList
  extend FFI::Library

  ffi_lib("libglib-2.0")

  attr_reader :list, :values, :len

  def initialize(list)
    @list   = list
    @values = []

    unless(list.null?)
      @len = g_list_length(@list)

      (0..(len - 1)).each do |i|
        ptr = g_list_nth_data(@list, i)

        sptr = ptr.read_string rescue "null"

        @values.push(sptr)
      end
    end
  end

  private

  attach_function(:g_list_length,
    :g_list_length, [ :pointer ], :uint
  )

  attach_function(:g_list_nth_data,
    :g_list_nth_data, [ :pointer, :uint ], :pointer
  )
end

class Libnotify
  extend FFI::Library

  ffi_lib("libnotify")

  def initialize(app = "dbus_test")
    notify_init(app)
  end

  def get_server_info
    # Create memory pointers
    ptr_name    = FFI::MemoryPointer.new(:pointer, 1)
    ptr_vendor  = FFI::MemoryPointer.new(:pointer, 1)
    ptr_version = FFI::MemoryPointer.new(:pointer, 1)
    ptr_spec    = FFI::MemoryPointer.new(:pointer, 1)

    notify_get_server_info(ptr_name, ptr_vendor, ptr_version, ptr_spec)

    # Read pointers
    str_name    = ptr_name.read_pointer
    str_vendor  = ptr_vendor.read_pointer
    str_version = ptr_version.read_pointer
    str_spec    = ptr_spec.read_pointer

    { 
      :name    => str_name.null?    ? nil : str_name.read_string,
      :vendor  => str_vendor.null?  ? nil : str_vendor.read_string, 
      :version => str_version.null? ? nil : str_version.read_string,
      :spec    => str_spec.null?    ? nil : str_spec.read_string
    }
  end

  def get_server_caps
    glist = GList.new(notify_get_server_caps)

    glist.values
  end

  private

  attach_function(:notify_init,
    :notify_init, [ :string ], :bool
  )

  attach_function(:notify_get_server_info,
    :notify_get_server_info, [ :pointer, :pointer, :pointer, :pointer ], :bool
  )

  attach_function(:notify_get_server_caps,
    :notify_get_server_caps, [ ], :pointer
  )
end

# Init libnotify
notify = Libnotify.new("notify")

info = notify.get_server_info
caps = notify.get_server_caps

puts <<EOF
Name:         #{info[:name]}
Version:      #{info[:version]}
Spec:         #{info[:spec]}
Vendor:       #{info[:vendor]}
Capabilities: #{caps.join(",")}
EOF

