
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;

library work;
  use work.regfile_pcie2AxiMaster_pack.all;

package int_queue_pak is
  alias INTERRUPT_QUEUE_TYPE       is  work.regfile_pcie2AxiMaster_pack.INTERRUPT_QUEUE_TYPE;     
  alias INIT_INTERRUPT_QUEUE_TYPE  is  work.regfile_pcie2AxiMaster_pack.INIT_INTERRUPT_QUEUE_TYPE;
  alias INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE  is  work.regfile_pcie2AxiMaster_pack.INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE;
  alias to_std_logic_vector        is  work.regfile_pcie2AxiMaster_pack.to_std_logic_vector[work.regfile_pcie2AxiMaster_pack.INTERRUPT_QUEUE_ADDR_HIGH_TYPE return std_logic_vector];
end int_queue_pak;

package body int_queue_pak is
end int_queue_pak;
