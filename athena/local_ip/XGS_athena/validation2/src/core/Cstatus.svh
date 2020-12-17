/****************************************************************************
 * Cstatus.svh
 ****************************************************************************/

/**
 * Class: Cstatus
 *
 * TODO: Add class documentation
 */
class Cstatus;
	integer timestamp;
	string message;
	int errors;
	int warnings;

	function new(int errors = 0, int warnings = 0, string message = "UNKNOWN");
		this.timestamp = $time;
		this.message = message;
		this.errors = errors;
		this.warnings = warnings;
	endfunction

	function string to_string();
		string s;
		$sformat(s,"%t, %s",this.timestamp, this.message);
		return s;
	endfunction

	function void print();
		$display("%s",this.to_string());
	endfunction


endclass