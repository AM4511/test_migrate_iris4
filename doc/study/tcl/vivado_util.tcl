# Set the selected object for debug in ILA
proc db {arguments} {
  set_property MARK_DEBUG 1 [get_selected_objects]
}
