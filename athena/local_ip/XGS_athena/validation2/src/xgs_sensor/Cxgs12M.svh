/****************************************************************************
 * Cxgs12M.svh
 ****************************************************************************/

/**
 * Class: Cxgs12M
 * 
 * TODO: Add class documentation
 */
class Cxgs12M extends Cxgs_sensor;

	function new(string name="xgs12M");
		super.new(
				.name(name), 
				.model_id('h58),
				.rev_id('h2),
				.numb_of_lane(6),
				.lane_mux_ratio(4),
				.pixel_per_column(174),
				.pixel_rows(3102), 
				.interpolation_width(4), 
				.left_dummy_0(4), 
				.left_black_ref(24),
				.left_dummy_1(4), 
				.roi_width(4096),
                .right_dymmy_0(4),
                .right_black_ref(24),
                .right_dummy_1(4),
                .top_dummy(7), 
                .bottm_dummy_0(4), 
                .bottom_black_ref(24), 
                .bottom_dummy_1(3), 
                .line_ptr_width(2)
                );
	endfunction


endclass


