################################################
# Add HDL source files
################################################
set HDL_FILESET [get_filesets sources_1]

set FILE_LIST [list \
  [file normalize "${SRC_DIR}/xgs_model_pkg.vhd"] \
  [file normalize "${SRC_DIR}/xgs_hispi.vhd"] \
  [file normalize "${SRC_DIR}/xgs_image.vhd"] \
  [file normalize "${SRC_DIR}/xgs_sensor_config.vhd"] \
  [file normalize "${SRC_DIR}/xgs_spi_i2c.vhd"] \
  [file normalize "${SRC_DIR}/xgs12m_chip.vhd"] \
  [file normalize "${SRC_DIR}/TB_xgs12m_receiver.sv"] \
]

add_files -norecurse -fileset ${HDL_FILESET} $FILE_LIST

set_property used_in_synthesis false [get_files  *xgs12m_receiver_wrapper.vhd]
set_property used_in_synthesis false [get_files  *xgs_model_pkg.vhd]
set_property used_in_synthesis false [get_files  *xgs_hispi.vhd]
set_property used_in_synthesis false [get_files  *xgs_image.vhd]
set_property used_in_synthesis false [get_files  *xgs_sensor_config.vhd]
set_property used_in_synthesis false [get_files  *xgs_spi_i2c.vhd]
set_property used_in_synthesis false [get_files  *xgs12m_chip.vhd]
set_property used_in_synthesis false [get_files *xgs12m_receiver.bd]
set_property used_in_synthesis false [get_files  *TB_xgs12m_receiver.sv]

set_property used_in_implementation false [get_files *xgs12m_receiver.bd]
set_property used_in_implementation false [get_files *TB_xgs12m_receiver.sv]


exec xvhdl --work chip_lib --93_mode ${SRC_DIR}/xgs_model_pkg.vhd
exec xvhdl --work chip_lib --93_mode ${SRC_DIR}/xgs_hispi.vhd
exec xvhdl --work chip_lib --93_mode ${SRC_DIR}/xgs_image.vhd
exec xvhdl --work chip_lib --93_mode ${SRC_DIR}/xgs_sensor_config.vhd
exec xvhdl --work chip_lib --93_mode ${SRC_DIR}/xgs_spi_i2c.vhd
exec xvhdl --work chip_lib --93_mode ${SRC_DIR}/xgs12m_chip.vhd
