NDSummary.OnToolTipsLoaded("SystemverilogClass:xil_axi_slv_mem_model",{1046:"<div class=\"NDToolTip TClass LSystemverilog\"><div class=\"NDClassPrototype\" id=\"NDClassPrototype1046\"><div class=\"CPEntry TClass Current\"><div class=\"CPName\">xil_axi_slv_mem_model</div></div></div><div class=\"TTSummary\">AXI Memory Model class. It is an associate array of Systemverilog. The write transaction can write to the memory and the read transaction can read data from the memory. These two features are implemented in the Slave VIP and Passthrough VIP in runtime slave mode. At the same time, the memory model has backdoor APIs for user to access memory directly. Please refer PG267 section about Simple SRAM Memory Model for more details.</div></div>",1048:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1048\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function new</span>(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PType first\"><span class=\"SHKeyword\">string</span>&nbsp;</td><td class=\"PName\">name&nbsp;</td><td class=\"PDefaultValueSeparator\">=&nbsp;</td><td class=\"PDefaultValue last\"><span class=\"SHString\">&quot;unnamed_xil_axi_slv_mem_model&quot;</span></td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Constructor to create an AXI slave memory model, ~name~ is instance name.</div></div>",1049:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1049\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> set_bresp_delay_policy(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_memory_delay_policy_t&nbsp;</td><td class=\"PName last\">in</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets BRESP delay policy of xil_axi_slv_mem_model.</div></div>",1050:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1050\" class=\"NDPrototype NoParameterForm\"><span class=\"SHKeyword\">virtual function</span> xil_axi_memory_delay_policy_t get_bresp_delay_policy()</div><div class=\"TTSummary\">Returns the current value of the BRESP delay policy of xil_axi_slv_mem_model.</div></div>",1051:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1051\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> set_inter_beat_gap_delay_policy(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_memory_delay_policy_t&nbsp;</td><td class=\"PName last\">in</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets RDATA delay policy of xil_axi_slv_mem_model.</div></div>",1052:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1052\" class=\"NDPrototype NoParameterForm\"><span class=\"SHKeyword\">virtual function</span> xil_axi_memory_delay_policy_t get_inter_beat_gap_delay_policy()</div><div class=\"TTSummary\">Returns the current value of the RDATA delay policy of xil_axi_slv_mem_model.</div></div>",1053:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1053\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> set_memory_fill_policy(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_memory_fill_policy_t&nbsp;</td><td class=\"PName last\">default_fill_type</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets default memory content fill type of xil_axi_slv_mem_model.</div></div>",1054:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1054\" class=\"NDPrototype NoParameterForm\"><span class=\"SHKeyword\">virtual function</span> xil_axi_memory_fill_policy_t get_memory_fill_policy()</div><div class=\"TTSummary\">Gets default memory content fill type of xil_axi_slv_mem_model.</div></div>",1055:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1055\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">virtual function void</span> set_default_memory_value(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input logic&nbsp;</td><td class=\"PType\">[C_AXI_WDATA_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>]&nbsp;</td><td class=\"PName last\">value</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets default memory value of xil_axi_slv_mem_model.</div></div>",1056:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1056\" class=\"NDPrototype NoParameterForm\"><span class=\"SHKeyword\">virtual function</span> logic [C_AXI_WDATA_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] get_default_memory_value()</div><div class=\"TTSummary\">Returns default memory value of xil_axi_slv_mem_model.</div></div>",1057:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1057\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> set_inter_beat_gap(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">in&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets inter beat gap value of xil_axi_slv_mem_model.</div></div>",1058:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1058\" class=\"NDPrototype NoParameterForm\"><span class=\"SHKeyword\">function</span> xil_axi_uint get_inter_beat_gap()</div><div class=\"TTSummary\">Returns inter beat gap value of xil_axi_slv_mem_model.</div></div>",1059:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1059\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> set_inter_beat_gap_range(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">min,</td></tr><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">max&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets inter beat gap range of xil_axi_slv_mem_model.</div></div>",1060:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1060\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> get_inter_beat_gap_range(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">output&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">min,</td></tr><tr><td class=\"PModifierQualifier first\">output&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">max&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Gets inter beat gap range of xil_axi_slv_mem_model.</div></div>",1061:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1061\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> set_bresp_delay(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">in&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets BRESP delay value of xil_axi_slv_mem_model.</div></div>",1062:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1062\" class=\"NDPrototype NoParameterForm\"><span class=\"SHKeyword\">function</span> xil_axi_uint get_bresp_delay()</div><div class=\"TTSummary\">Returns BRESP delay value of xil_axi_slv_mem_model.</div></div>",1063:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1063\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> set_bresp_delay_range(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">min,</td></tr><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">max&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Sets BRESP delay range of xil_axi_slv_mem_model.</div></div>",1064:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1064\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> get_bresp_delay_range(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">output&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">min,</td></tr><tr><td class=\"PModifierQualifier first\">output&nbsp;</td><td class=\"PType\">xil_axi_uint&nbsp;</td><td class=\"PName last\">max&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Gets BRESP delay range of xil_axi_slv_mem_model.</div></div>",1065:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1065\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> backdoor_memory_write(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_ulong&nbsp;</td><td class=\"PName last\">addr,</td></tr><tr><td class=\"PModifierQualifier first\">input logic&nbsp;</td><td class=\"PType\">[C_AXI_WDATA_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>]&nbsp;</td><td class=\"PName last\">payload,</td></tr><tr><td class=\"PModifierQualifier first\">input logic&nbsp;</td><td class=\"PType\">[C_AXI_WDATA_WIDTH/<span class=\"SHNumber\">8</span>-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>]&nbsp;</td><td class=\"PName last\">strb&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Back door write data to memory.</div></div>",1066:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1066\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> backdoor_memory_write_4byte(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_ulong&nbsp;</td><td class=\"PName last\">addr,</td></tr><tr><td class=\"PModifierQualifier first\">input logic&nbsp;</td><td class=\"PType\">[<span class=\"SHNumber\">31</span>:<span class=\"SHNumber\">0</span>]&nbsp;</td><td class=\"PName last\">payload,</td></tr><tr><td class=\"PModifierQualifier first\">input logic&nbsp;</td><td class=\"PType\">[<span class=\"SHNumber\">3</span>:<span class=\"SHNumber\">0</span>]&nbsp;</td><td class=\"PName last\">strb&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Back door write data to memory in 4 byte chunks.&nbsp; It will write to the memory with address(addr) with VIP\'s data_width bits wide data(payload) and data_width/8 bits wide strobe(strb). Default strobe is all on {4{1\'b1}}.&nbsp; It will truncate the address if the addr user give is out of range.&nbsp; It will give fatal message if strobe bits is asserted at lower bits than address offset.</div></div>",1067:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1067\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function</span> bit[C_AXI_WDATA_WIDTH-<span class=\"SHNumber\">1</span>:<span class=\"SHNumber\">0</span>] backdoor_memory_read(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_ulong&nbsp;</td><td class=\"PName last\">addr&nbsp;</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Back door read data from the address(addr) of memory.</div></div>",1068:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1068\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function</span> bit[<span class=\"SHNumber\">31</span>:<span class=\"SHNumber\">0</span>] backdoor_memory_read_4byte(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">xil_axi_ulong&nbsp;</td><td class=\"PName last\">addr</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Back door read data from the address(addr) of memory in 4 byte chunks.</div></div>",1069:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1069\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function</span> axi_transaction fill_rd_reactive(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">axi_transaction&nbsp;</td><td class=\"PName last\">t</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Fill in read data channel from memory model.</div></div>",1070:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1070\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> fill_wr_reactive(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\"><span class=\"SHKeyword\">inout</span>&nbsp;</td><td class=\"PType\">axi_transaction&nbsp;</td><td class=\"PName last\">t</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Fill in write bresponse channel.</div></div>",1071:"<div class=\"NDToolTip TFunction LSystemverilog\"><div id=\"NDPrototype1071\" class=\"NDPrototype WideForm CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">function void</span> write_transaction_to_memory(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PModifierQualifier first\">input&nbsp;</td><td class=\"PType\">axi_transaction&nbsp;</td><td class=\"PName last\">t</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div><div class=\"TTSummary\">Write transaction to memory.</div></div>"});