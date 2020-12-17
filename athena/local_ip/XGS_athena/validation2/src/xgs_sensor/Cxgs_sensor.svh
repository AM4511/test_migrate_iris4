/****************************************************************************
 * Cxgs_sensor.svh
 ****************************************************************************/

/**
 * Class: Cxgs_sensor
 * 
 * TODO: Add class documentation
 */
import driver_pkg::*;
import image_pkg::*;

class Cxgs_sensor;

	Cdriver_axil host; 
	string name;

	int model_id;
	int rev_id;
	int numb_of_lane;
	int lane_mux_ratio;
	int pixel_per_colomn;
	int pixel_rows;
	int x_size;
	int y_size;
		  
	int interpolation_width;
	int left_dummy_0;
	int left_black_ref;
	int left_dummy_1;
	int roi_width;
	int right_dymmy_0;
	int right_black_ref;
	int right_dummy_1;
		  
	int top_dummy;
	int bottm_dummy_0;
	int bottom_black_ref;
	int bottom_dummy_1;
	int line_ptr_width;
	
	function new(
		Cdriver_axil host, 
		string name, 
		int model_id,
		int rev_id, 
		int numb_of_lane, 
		int lane_mux_ratio,
		int pixel_per_column,
		int pixel_rows,
		int interpolation_width,
		int left_dummy_0,
		int left_black_ref,
		int left_dummy_1,
		int roi_width,
		int right_dymmy_0,
		int right_black_ref,
		int right_dummy_1,
		int top_dummy,
		int bottm_dummy_0,
		int bottom_black_ref,
		int bottom_dummy_1,
		int line_ptr_width
		);
		
		this.host = host;
		this.name = name;
		this.model_id = model_id;
		this.rev_id = rev_id;
		this.numb_of_lane = numb_of_lane;
		this.lane_mux_ratio = lane_mux_ratio;
		this.pixel_per_colomn = pixel_per_colomn;
		this.pixel_rows = pixel_rows;
		this.interpolation_width = interpolation_width;
		this.left_dummy_0=left_dummy_0;
		this.left_black_ref=left_black_ref;
		this.left_dummy_1=left_dummy_1;
		this.roi_width=roi_width;
		this.right_dymmy_0=right_dymmy_0;
		this.right_black_ref=right_black_ref;
		this.right_dummy_1=right_dummy_1;
		this.top_dummy=top_dummy;
		this.bottm_dummy_0=bottm_dummy_0;
		this.bottom_black_ref=bottom_black_ref;
		this.bottom_dummy_1=bottom_dummy_1;
		this.line_ptr_width=line_ptr_width;
		
		// Calculated parameters
		this.x_size = this.pixel_per_colomn*this.numb_of_lane*this.lane_mux_ratio*2;
		this.y_size=this.pixel_rows;

	endfunction

	
	function Cimage get_image();
		Cimage sensor_image;
		int xgs_model;
		case (this.model_id)
			'h58: begin
				xgs_model = 12000;
			end
			'h358: begin
				xgs_model = 5000;
			end
			'h258: begin
				xgs_model = 16000;
			end
			default: begin
				return null;
			end
		endcase
		sensor_image = new();
		sensor_image.load_image(xgs_model);	
		return sensor_image;
	endfunction


endclass


