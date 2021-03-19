//
// Test0006 : XGS 12000
//
// SUBSAMPLING Y TEST
//

import tests_pkg::*;
import driver_pkg::*;
import xgs_athena_pkg::*;



class Test0006 extends CTest;

    parameter AXIS_DATA_WIDTH  = 64;
    parameter AXIS_USER_WIDTH  = 4;

    Cdriver_axil  host;
    virtual axi_stream_interface tx_axis_if;

	Cscoreboard  scoreboard;

    int XGS_Model;

    int EXPOSURE;
	int ROI_X_START;
	int ROI_X_SIZE;
    int ROI_X_END;
	int ROI_Y_START;
	int ROI_Y_SIZE;
    int ROI_Y_END;
    int SUB_X;
	int SUB_Y;
	int REV_X = 0;
	int REV_Y = 0;

    int test_nb_images;


    function new(Cdriver_axil host, virtual axi_stream_interface tx_axis_if);
        super.new("Test0006", host, tx_axis_if);
        this.host       = host;
        this.tx_axis_if = tx_axis_if;
    endfunction

    task run();


        scoreboard     = new(tx_axis_if);

        super.say_hello();

		fork

			// Start the scoreboard
			begin
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

		        super.Vlib.setXGSmodel();
		        super.Vlib.setXGScontroller();
		        super.Vlib.setHISPI();
		        super.Vlib.setHISPI_X_window();
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
				super.Vlib.GenImage_XGS(2);                                   // Le modele XGS cree le .pgm et loade dans le vhdl
				//super.Vlib.GenImage_XGS(0);                                     // Le modele XGS cree le .pgm et loade dans le vhdl
				super.Vlib.XGS_imageSRC.load_image(XGS_Model);                             // Load le .pgm dans la class SystemVerilog


		        ///////////////////////////////////////////////////
				// DPC
				///////////////////////////////////////////////////
                //super.Vlib.DPC_add_list();


		        ///////////////////////////////////////////////////
				// COMMON PARAMETERS FOR GRABS IN THIS TEST
				///////////////////////////////////////////////////
			    EXPOSURE    = 50; // exposure=50us

				ROI_X_START = 0;
				ROI_X_SIZE  = super.Vlib.P_ROI_WIDTH;       // Xsize sans interpolation(pour l'instant)
				ROI_X_END   = ROI_X_START + ROI_X_SIZE - 1;

				ROI_Y_START = 0;           // Doit etre multiple de 4
				ROI_Y_SIZE  = 8;           // Doit etre multiple de 4, // Doit etre multiple de 4, (ROI_Y_START+ROI_Y_SIZE) < (5M:2078, 12M:3102, 16M:4030)
				ROI_Y_END   = ROI_Y_START + ROI_Y_SIZE - 1;

				super.Vlib.Set_X_ROI(ROI_X_START, ROI_X_SIZE);
				super.Vlib.Set_Y_ROI(ROI_Y_START/4, ROI_Y_SIZE/4);
                super.Vlib.Set_EXPOSURE(EXPOSURE); //in us


				///////////////////////////////////////////////////
				// Grab #0 - Aucun Subsampling
				///////////////////////////////////////////////////
				SUB_X       = 0;
				SUB_Y       = 0;
				$display("IMAGE Trigger #0, Xstart=%0d, Xsize=%0d, Ystart=%0d, Ysize=%0d, SubX= %0d, SubY= %0d", ROI_X_START, ROI_X_SIZE, ROI_Y_START, ROI_Y_SIZE, SUB_X, SUB_Y  );
                super.Vlib.Set_SUB(SUB_X, SUB_Y);
                super.Vlib.setDMA('hA0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
                super.Vlib.Set_Grab_Mode(IMMEDIATE, NONE);
				super.Vlib.Grab_CMD();
				test_nb_images++;

				// Prediction
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

                // Wait for end of readout
                super.Vlib.host.wait_events (0, 1, 'hfffffff); // wait for EOF IRQ(connected to input 0 of host)


				///////////////////////////////////////////////////
				// Grab #1 - Subsampling Y
				///////////////////////////////////////////////////

				SUB_X       = 0;
				SUB_Y       = 1;
				$display("IMAGE Trigger #1, Xstart=%0d, Xsize=%0d, Ystart=%0d, Ysize=%0d, SubX= %0d, SubY= %0d", ROI_X_START, ROI_X_SIZE, ROI_Y_START, ROI_Y_SIZE, SUB_X, SUB_Y  );
                super.Vlib.Set_SUB(SUB_X, SUB_Y);
                super.Vlib.setDMA('hB0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
				super.Vlib.Set_Grab_Mode(IMMEDIATE, NONE);
				super.Vlib.Grab_CMD();
				test_nb_images++;

				// Prediction
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

                // Wait for end of readout
                super.Vlib.host.wait_events (0, 1, 'hfffffff); // wait for EOF IRQ(connected to input 0 of host)


				#250us;
		        super.say_goodbye();
		    end

		join_any;

    endtask

endclass
