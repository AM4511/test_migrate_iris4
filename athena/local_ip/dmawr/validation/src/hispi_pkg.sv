/****************************************************************************
 * hispi_pkg.sv
 ****************************************************************************/

/**
 * Package: hispi_pkg
 *
 * TODO: Add package documentation
 */

package hispi_pkg;
	import core_pkg::*;
	import driver_pkg::*;

	typedef class Cscoreboard_hispi;
	typedef class Cdriver_onsemi_xgs;
	typedef class Csensor_msg_channel;
	typedef class CmsgSendFrame;
	
	`include "hispi_registerfile.svh"
	`include "Cscoreboard_hispi.svh"
	`include "Cdriver_onsemi_xgs.svh"
        `include "Csensor_msg_channel.svh"
	`include "CmsgSendFrame.svh"

endpackage : hispi_pkg








