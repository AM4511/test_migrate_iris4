/****************************************************************************
 * Cxgs_sensor.svh
 ****************************************************************************/

/**
 * Class: Cxgs_sensor
 * 
 * TODO: Add class documentation
 */
import driver_pkg::*;

class Cxgs_sensor;

	Cdriver_axil host; 
	string name;
		  
//	P_MODEL_ID       =  16'h0358;
//	P_REV_ID         =  16'h0000;
//	P_NUM_LANES      =  4;
//	P_PXL_PER_COLRAM =  174;
//	P_PXL_ARRAY_ROWS =  2078;
//		  
//	P_INTERPOLATION  =  4;
//	P_LEFT_DUMMY_0   =  50;
//	P_LEFT_BLACKREF  =  34;
//	P_LEFT_DUMMY_1   =  4;
//	P_ROI_WIDTH      =  2592;
//	P_RIGHT_DUMMY_0  =  4;
//	P_RIGHT_BLACKREF =  42;
//	P_RIGHT_DUMMY_1  =  50;
//		  
//	P_TOP_DUMMY       =  7;
//	P_BOTTOM_DUMMY_0  =  4;
//	P_BOTTOM_BLACKREF =  8;
//	P_BOTTOM_DUMMY_1  =  3;
//	P_LINE_PTR_WIDTH  =  2;
	
	
	int model_id;
	int rev_id;
	int numb_of_lane;
	int pixel_per_colomn;
	int pixel_rows;
		  
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
	endfunction




endclass


