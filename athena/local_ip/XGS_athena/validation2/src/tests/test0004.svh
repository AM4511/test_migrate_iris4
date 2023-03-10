//
// Test0004 : XGS 5000
//
// Test of Acquisition Trigger level Hi and trigger level LO
//

import core_pkg::*;
import driver_pkg::*;



class Test0004 extends Ctest;

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
        super.new("Test0004", host, tx_axis_if);
        this.host       = host;
        this.tx_axis_if = tx_axis_if;
        this.scoreboard = new(tx_axis_if,this);
   endfunction

    task run();



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
                XGS_Model = 5000;
		        host.reset(20);
		        #100us;

		        super.Vlib.setXGS_sensor(XGS_Model);
		        super.Vlib.setXGSmodel();
		        super.Vlib.setXGScontroller();
		        super.Vlib.setHISPI();
		        super.Vlib.setHISPI_X_window();
		        super.Vlib.testI2Csemaphore();
                host.set_output_io (2, 0);
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
				super.Vlib.XGS_imageSRC.load_image(XGS_Model);                                  // Load le .pgm dans la class SystemVerilog


		        ///////////////////////////////////////////////////
				// DPC
				///////////////////////////////////////////////////
                super.Vlib.DPC_add_list();



                ///////////////////////////////////////////////////
				// Common parameters for all grabs on this test
				///////////////////////////////////////////////////
				tx_axis_if.tready_packet_delai_cfg    = 1; //random backpressure
				tx_axis_if.tready_packet_random_min   = 1;
	            tx_axis_if.tready_packet_random_max   = 31;
				//tx_axis_if.tready_packet_delai_cfg    = 0;   // Static backpressure
                //tx_axis_if.tready_packet_delai        = 0;   // tready_packet_delai = 28;  => overrun

				ROI_X_START = 0;
				ROI_X_SIZE  = super.Vlib.P_ROI_WIDTH;       // Xsize sans interpolation(pour l'instant)
				ROI_X_END   = ROI_X_START + ROI_X_SIZE - 1;

				ROI_Y_START = 4;           // Doit etre multiple de 4
				ROI_Y_SIZE  = 8;           // Doit etre multiple de 4, (ROI_Y_START+ROI_Y_SIZE) < (5M:2078, 12M:3102, 16M:4030)
				ROI_Y_END   = ROI_Y_START + ROI_Y_SIZE - 1;

				SUB_X       = 0;
				SUB_Y       = 0;

			    EXPOSURE    = 50; // exposure=50us

				$display("IMAGE Trigger #0, Xstart=%0d, Xsize=%0d, Ystart=%0d, Ysize=%0d", ROI_X_START, ROI_X_SIZE, ROI_Y_START, ROI_Y_SIZE);

				//super.Vlib.Set_X_ROI(ROI_X_START, ROI_X_SIZE);
				super.Vlib.Set_Y_ROI(ROI_Y_START/4, ROI_Y_SIZE/4);
                super.Vlib.Set_SUB(SUB_X, SUB_Y);
                super.Vlib.Set_EXPOSURE(EXPOSURE); //in us


                //////////////////////////////////////////////////////////////
				// Trigger LEVEL HI : 3 images, Signal HI when CMD is sent
				//////////////////////////////////////////////////////////////

				//Set Anput external trigger to HI
                host.set_output_io (2, 1);
                #50us;

                //IMG #1
		        super.Vlib.setDMA('hA0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
		        // DMA TRIM 
		        super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
		        //super.Vlib.Set_DMA_Trim_Y_ROI(0, ROI_Y_SIZE); //No ROI Y in mono
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_HI);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #1
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

                //IMG #2
		        super.Vlib.setDMA('hB0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
		        // DMA TRIM 
		        super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
		        //super.Vlib.Set_DMA_Trim_Y_ROI(ROI_Y_START, ROI_Y_SIZE); //No ROI Y in mono
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_HI);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #2
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

				// Wait for the first image
                super.Vlib.host.wait_events (0, 1, 'hfffffff); // wait for 1 in IRQ(connected to input 0 of host)

				//IMG #3
		        super.Vlib.setDMA('hC0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
		        // DMA TRIM 
		        super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
		        //super.Vlib.Set_DMA_Trim_Y_ROI(ROI_Y_START, ROI_Y_SIZE); //No ROI Y in mono
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_HI);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #3
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);


				// Wait for the last 2 images
                super.Vlib.host.wait_events (0, 2, 'hfffffff); // wait for last 2 IRQ(connected to input 0 of host)

				//Set Anput external trigger to LO
                host.set_output_io (2, 0);
                #500us;


                //////////////////////////////////////////////////////////////
				// Trigger LEVEL LO : 3 images, Signal LO when CMD is sent
				//////////////////////////////////////////////////////////////

				//Set Anput external trigger to HI
                host.set_output_io (2, 0);
                #50us;

                //IMG #1
		        super.Vlib.setDMA('hD0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
		        // DMA TRIM 
		        super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
		        //super.Vlib.Set_DMA_Trim_Y_ROI(0, ROI_Y_SIZE); //No ROI Y in mono
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_LO);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #1
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

                //IMG #2
  		        super.Vlib.setDMA('hE0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
  		        // DMA TRIM 
  		        super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
  		        //super.Vlib.Set_DMA_Trim_Y_ROI(0, ROI_Y_SIZE);
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_LO);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #2
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

				// Wait for the first image
                super.Vlib.host.wait_events (0, 1, 'hfffffff); // wait for 1 in IRQ(connected to input 0 of host)

				//IMG #3
				super.Vlib.setDMA('hF0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
				// DMA TRIM 
				super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
				//super.Vlib.Set_DMA_Trim_Y_ROI(0, ROI_Y_SIZE); //No ROI Y in mono
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_LO);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #3
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

				// Wait for the last 2 images
                super.Vlib.host.wait_events (0, 2, 'hfffffff); // wait for last 2 IRQ(connected to input 0 of host)

				host.set_output_io (2, 0);
				#250us;


                //////////////////////////////////////////////////////////////
				// Trigger LEVEL HI x1, LEVEL LO x1,
				//////////////////////////////////////////////////////////////

				//Set Anput external trigger to LO
                host.set_output_io (2, 0);
                #50us;

                //IMG #1 : Active HI
				super.Vlib.setDMA('hA0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
				// DMA TRIM 
				super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
				//super.Vlib.Set_DMA_Trim_Y_ROI(0, ROI_Y_SIZE); //No ROI Y in mono
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_HI);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #1
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

                //IMG #2 : Active LO
				super.Vlib.setDMA('hB0000000, 'h2000, ROI_X_SIZE/(SUB_X+1), REV_Y, ROI_Y_SIZE);
				// DMA TRIM 
				super.Vlib.Set_DMA_Trim_X_ROI(ROI_X_START, ROI_X_SIZE);
				//super.Vlib.Set_DMA_Trim_Y_ROI(0, ROI_Y_SIZE); //No ROI Y in mono
				super.Vlib.Set_Grab_Mode(HW_TRIG, LEVEL_LO);
				super.Vlib.Grab_CMD();
				test_nb_images++;
				// Prediction #2
				super.Vlib.Gen_predict_img(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y, REV_X, REV_Y);   // This proc generate the super.Vlib.XGS_image to the scoreboard
				scoreboard.predict_img(super.Vlib.XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch, REV_Y);

                #100us;
                host.set_output_io (2, 1);	//trig  HI LEVEL

				// Wait for the first image
                super.Vlib.host.wait_events (0, 1, 'hfffffff); // wait for 1 in IRQ(connected to input 0 of host)

                #100us;
                host.set_output_io (2, 0);	//trig LO LEVEL

				// Wait for the last image
                super.Vlib.host.wait_events (0, 1, 'hfffffff); // wait for last 2 IRQ(connected to input 0 of host)

				#250us;



		        super.say_goodbye();
		    end

		join_any;

    endtask






endclass
