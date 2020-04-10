/****************************************************************************
 * Cfield.svh
 ****************************************************************************/

/**
 * Class: Cfield
 *
 * TODO: Add class documentation
 */
class Cfield extends Cnode;
	static typedef enum {RW,RO,STATIC,WAC,RW2S, RW2C} ACC_TYPES;
	int lsb;
	int size;
	ACC_TYPES access_type = RW;
	int value;

	function new(string name = "", int lsb = 0, int size = 1,	ACC_TYPES access_type = RW, longint value = 0);
		super.new(name);
	endfunction


endclass


