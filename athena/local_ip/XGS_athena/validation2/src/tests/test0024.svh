///////////////////////////////////////////////////////////////////////////////////////////////
// Test0024 : XGS 12000 : BAYER COLOR DEMOSAIC : RGB32
//
// Description : Send one color frame of 16 lines. Destination buffer is BGR32.
//               (20 from the sensor because of bayer 1-line consumption)
//
///////////////////////////////////////////////////////////////////////////////////////////////
import core_pkg::*;
import driver_pkg::*;



class Test0024 extends Ctest;

    parameter AXIS_DATA_WIDTH  = 64;
    parameter AXIS_USER_WIDTH  = 4;

    Cdriver_axil  host;
    virtual axi_stream_interface tx_axis_if;

	Cscoreboard  scoreboard;

    int XGS_Model;

    int EXPOSURE;
	int XGS_ROI_X_START;
	int XGS_ROI_X_SIZE;
    int XGS_ROI_X_END;
	int XGS_ROI_Y_START;
	int XGS_ROI_Y_SIZE;
    int XGS_ROI_Y_END;
    int TRIM_ROI_Y_START;
    int TRIM_ROI_Y_SIZE;
    int TRIM_ROI_X_START;
    int TRIM_ROI_X_SIZE;
    int DMA_NB_LINE;
    int DMA_PIX_WIDTH;    
    int DMA_LINE_SIZE;

    int SUB_X;
	int SUB_Y;
	int REV_X = 0;
	int REV_Y = 0;

    int test_nb_images;


    function new(Cdriver_axil host, virtual axi_stream_interface tx_axis_if);
        super.new("Test0024", host, tx_axis_if);
        this.host       = host;
        this.tx_axis_if = tx_axis_if;
        this.scoreboard = new(tx_axis_if,this);
    endfunction

    task run();


        super.say_hello();

		fork

			// Start the scoreboard
			begin
				scoreboard.IgnorePrediction=0;  // 1: Dont use rediction, 0: Use rediction
			    scoreboard.run();
			end


			begin

                //-------------------------------------------------
				// SELECTION DU MODELE XGS
                //-------------------------------------------------
                XGS_Model = 12000;

		        host.reset(20);
		        #100us;

		        super.Vlib.setXGS_sensor(XGS_Model);

		        super.Vlib.setXGSmodel(1);  //1=Color, 0 or nothing =Mono
		        super.Vlib.setXGScontroller();
		        super.Vlib.setHISPI();
		        super.Vlib.setHISPI_X_window(1); //All interpolation
		        super.Vlib.testI2Csemaphore();
			    #200us;


		        //-------------------------------------------------
				// Generation de l'image du senseur XGS
				//
				// XGS Image Pattern :
				//   0 : Random 12 bpp
				//   1 : Ramp 12bpp
				//   2 : Ramp 8bpp (MSB, +16pixel 12bpp)
				//
				//--------------------------------------------------
				//super.Vlib.GenImage_XGS(2);                                   // Le modele XGS cree le .pgm et loade dans le vhdl
				super.Vlib.GenImage_XGS(0);                                     // Le modele XGS cree le .pgm et loade dans le vhdl
				super.Vlib.XGS_imageSRC.load_image(XGS_Model);                  // Load le .pgm dans la class SystemVerilog

		        ///////////////////////////////////////////////////
				// BAYER
				///////////////////////////////////////////////////
                super.Vlib.setWB('h1000, 'h1000,  'h1000);  // (B,G,R)
                super.Vlib.setCSC(1);                       // Activate BAYER RGB24

		        ///////////////////////////////////////////////////
				// DPC : COLOR LIST
				///////////////////////////////////////////////////
                super.Vlib.DPC_COLOR_add_list();

				///////////////////////////////////////////////////
				// Trigger ROI #0
				///////////////////////////////////////////////////
				tx_axis_if.tready_packet_delai_cfg    = 1; //random backpressure
				tx_axis_if.tready_packet_random_min   = 1;
	            //tx_axis_if.tready_packet_random_max   = 31;
	            tx_axis_if.tready_packet_random_max   = 10; //backpressure ok!


				//tx_axis_if.tready_packet_delai_cfg    = 0;   // Static backpressure
                //tx_axis_if.tready_packet_delai        = 0;   // tready_packet_delai = 28;  => overrun


                //--------------------------------------------------------------------------------------------------------------------------------------------- 
                // COLOR transform
                // 
                // ** Y **
                // Bayer consumes 1 Line in order to expand RAW to RGB32. In order to have the last line perfect generated, we will transfert 4 lines more
                // from the sensor at the end of the customer ROI. One line will be consummed by Bayer. The trim module will crop the supplementary 3 lines 
                // generated by the bayer in this case.
                //
                // ** X **
                // We always proccess the full X line in the fpga, interpolation included. The DPC when enabled removes the 2 first and 2 last pixels. Bayer
                // do not consume pixels. The Trim module will crop the excedent data
                // 
                //--------------------------------------------------------------------------------------------------------------------------------------------- 


	            ///////////////////////////////////////////////////////
                // Sensor Y ROI
	            ///////////////////////////////////////////////////////
				XGS_ROI_Y_START = 0;           // Doit etre multiple de 4
				XGS_ROI_Y_SIZE  = 16+4;        // Doit etre multiple de 4, (XGS_ROI_Y_START+XGS_ROI_Y_SIZE) < (5M:2078, 12M:3102, 16M:4030), on laisse passer 4 interpolation de plus pour consommation bayer
				XGS_ROI_Y_END   = XGS_ROI_Y_START + XGS_ROI_Y_SIZE - 1;

				XGS_ROI_X_START = 0;
				XGS_ROI_X_SIZE  = super.Vlib.P_ROI_WIDTH;       // Xsize sans interpolation(pour l'instant)
				XGS_ROI_X_END   = XGS_ROI_X_START + XGS_ROI_X_SIZE - 1;

				//Set the XGS sensor Y ROI
				$display("IMAGE Trigger #0, Xstart=%0d, Xsize=%0d, Ystart=%0d, Ysize=%0d", XGS_ROI_X_START, XGS_ROI_X_SIZE, XGS_ROI_Y_START, XGS_ROI_Y_SIZE);
				super.Vlib.Set_Y_ROI(XGS_ROI_Y_START/4, XGS_ROI_Y_SIZE/4);
				
				
				///////////////////////////////////////////////////////
				// Trim module ROI
				///////////////////////////////////////////////////////
				TRIM_ROI_Y_START = 0;
				TRIM_ROI_Y_SIZE  = 16;
				TRIM_ROI_X_START = 0;
				TRIM_ROI_X_SIZE  = super.Vlib.P_ROI_WIDTH; // Units in pixels

				//Set the fpga trim module X-Y ROI
				super.Vlib.Set_X_ROI(TRIM_ROI_X_START, TRIM_ROI_X_SIZE);
				super.Vlib.Set_DMA_Trim_Y_ROI(TRIM_ROI_Y_START, TRIM_ROI_Y_SIZE);


				///////////////////////////////////////////////////////
				// Subsampling
				///////////////////////////////////////////////////////
				SUB_X       = 0;
				SUB_Y       = 0;
				super.Vlib.Set_SUB(SUB_X, SUB_Y);

				///////////////////////////////////////////////////////
				// DMA
				///////////////////////////////////////////////////////
				DMA_NB_LINE   = TRIM_ROI_Y_SIZE;
				DMA_PIX_WIDTH = 4;                           // Units in bytes (4:RGB32)
				DMA_LINE_SIZE = TRIM_ROI_X_SIZE*4/(SUB_X+1); // Units in bytes

				super.Vlib.setDMA('hA0000000, 'h4000, DMA_LINE_SIZE, REV_Y, DMA_NB_LINE);				
                

				///////////////////////////////////////////////////////
				// Exposure
				///////////////////////////////////////////////////////
			    EXPOSURE    = 50; // exposure=50us
                super.Vlib.Set_EXPOSURE(EXPOSURE); //in us

                super.Vlib.P_LINE_PTR_WIDTH=1; // est-ce q ca ameliore?
				
				
                ///////////////////////////////////////////////////////
                // Start the grab
                ///////////////////////////////////////////////////////
				super.Vlib.Set_Grab_Mode(IMMEDIATE, NONE);
				super.Vlib.Grab_CMD();
				test_nb_images++;

				///////////////////////////////////////////////////////
				// Prediction
				///////////////////////////////////////////////////////
				super.Vlib.Gen_predict_img_color(XGS_ROI_X_START, XGS_ROI_X_END , XGS_ROI_Y_START, XGS_ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);


				///////////////////////////////////////////////////
				// Wait for the 1 image
				///////////////////////////////////////////////////
                super.Vlib.host.wait_events (0, 1, 'hfffffff); // wait for 1 in IRQ(connected to input 0 of host)
                #250us;


                ///////////////////////////////////////////////////
                // Stop the test
                ///////////////////////////////////////////////////
		        super.say_goodbye();
		    end

		join_any;

    endtask

endclass
