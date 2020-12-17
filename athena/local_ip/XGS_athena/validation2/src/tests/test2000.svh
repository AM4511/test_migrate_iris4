/**********************************************************************
 * Name : Test2000
 * Target : XGS 12000 MONO
 * 
 * Description : Send a single frame
 *
 **********************************************************************/
import core_pkg::*;
import driver_pkg::*;
import xgs_athena_pkg::*;

import fdkide_pkg::*;
import regfile_xgs_athena_pkg::*;
import athena_pkg::*;
import xgs_pkg::*;
import image_pkg::*;


class Test2000 extends Ctest;
	Cdriver_axil  host;
	virtual axi_stream_interface tx_axis_if;





	function new(Cdriver_axil host, virtual axi_stream_interface tx_axis_if);
		super.new("Test2000", host, tx_axis_if);
		this.host       = host;
		this.tx_axis_if = tx_axis_if;
	endfunction

	task run();
		
		Cimage XGS_imageSRC;
		Cimage XGS_image;
		Cimage XGS_imageDPC;

		//int XGS_Model;

		int EXPOSURE;    
		int ROI_X_START;
		int ROI_X_SIZE;
		int ROI_X_END;
		int ROI_Y_START;
		int ROI_Y_SIZE;
		int ROI_Y_END;
		int SUB_X;
		int SUB_Y;     
		int test_nb_images;

		int i;
		int REG_DPC_PATTERN0_CFG;
		int DPC_PATTERN;
        
		Cscoreboard  scoreboard;
		scoreboard     = new(tx_axis_if);
		
        ////////////////////////////////////////////////////////////
		// Initialize the test
		////////////////////////////////////////////////////////////
		XGS_imageSRC   = new();
		XGS_image      = new();
		XGS_imageDPC   = new();
		//XGS_Model      = 12000;

		super.say_hello();   

		
		////////////////////////////////////////////////////////////
		// Initialize the test
		////////////////////////////////////////////////////////////
		fork

			// Start the scoreboard
			begin
			
				scoreboard.run();
			end  


			begin    
				Cathena athena;
				Cxgs12M xgs_sensor;
				longint dma_fstart;
				int dma_line_pitch;
				int dma_line_size;
				int line_time;
				
				//-------------------------------------------------
				// SELECTION DU MODELE XGS  
				//-------------------------------------------------

				host.reset(20);
				#100us;

				//super.Vlib.setXGS_sensor(XGS_Model);

//				super.Vlib.setDMA('hA0000000, 'h2000);
//				super.Vlib.setXGSmodel();
//				super.Vlib.setXGScontroller();
//				super.Vlib.setHISPI();
//				super.Vlib.setHISPI_X_window();
//				super.Vlib.testI2Csemaphore();
				
				
				
				/////////////////////////////////////////////////////////////
				//  Turn on the XGS controller
				/////////////////////////////////////////////////////////////				
			    // XGS Controller : set the line time (in pixel clock)
			    // LINE_TIME
			    // default in model and in devware is 0xe6  (24 lanes), XGS12M register is 0x16e @32.4Mhz (T=30.864ns)
			    // default              in devware is 0xf4  (18 lanes)
			    // default              in devware is 0x16e (12 lanes)
			    // default              in devware is 0x2dc (6 lanes)
				line_time = 'h02dc;  //[AM] Where should we define this parameter?
				xgs_sensor = new(host, "XGS12M");
				athena = new(host, xgs_sensor);
				
				
				/////////////////////////////////////////////////////////////
				//  Turn on the XGS controller
				/////////////////////////////////////////////////////////////				
				athena.turn_on_xgs();
				
				
				/////////////////////////////////////////////////////////////
				//  Turn on the XGS controller
				/////////////////////////////////////////////////////////////				
				athena.setXGScontroller();

				
				/////////////////////////////////////////////////////////////
				//  Set the DMA
				/////////////////////////////////////////////////////////////				
				dma_fstart = 'hA0000000;
				dma_line_pitch = 'h2000;
				dma_line_size = xgs_sensor.x_size;
				athena.set_dma(dma_fstart, dma_line_pitch, dma_line_size);

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
				athena.GenImage_XGS(0);                                     // Le modele XGS cree le .pgm et loade dans le vhdl
				//XGS_imageSRC.load_image(XGS_Model);                             // Load le .pgm dans la class SystemVerilog			
				XGS_imageSRC = xgs_sensor.get_image();

				///////////////////////////////////////////////////
				// DPC
				///////////////////////////////////////////////////
				REG_DPC_PATTERN0_CFG = 1;

				host.write(super.Vlib.DPC_LIST_CTRL, 0);
				host.write(super.Vlib.DPC_LIST_CTRL, (0<<15)+(1<<13) );                    //DPC_ENABLE= 0, DPC_PATTERN0_CFG=0, DPC_LIST_WRN=1

				DPC_PATTERN = 85; 
				for (i = 0; i < 16; i++)
				begin				
					host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + i );           // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD						
					host.write(super.Vlib.DPC_LIST_DATA1, (i<<16)+i );                     // DPC_LIST_CORR_X = i, DPC_LIST_CORR_Y = i
					host.write(super.Vlib.DPC_LIST_DATA2,  DPC_PATTERN);                   // DPC_LIST_CORR_PATTERN = 0;
					host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + (1<<12) + i ); // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD + SS

					XGS_imageSRC.DPC_add(i, i, DPC_PATTERN);                    // Pour la prediction, ici j'incremente de 1 le nb de DPC a chaque appel          
				end

				DPC_PATTERN  = 170;
				for (i = 16; i < 63; i++)
				begin				
					host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + i );           // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD						
					host.write(super.Vlib.DPC_LIST_DATA1, (i<<16)+i );                     // DPC_LIST_CORR_X = i, DPC_LIST_CORR_Y = i
					host.write(super.Vlib.DPC_LIST_DATA2,  DPC_PATTERN);                   // DPC_LIST_CORR_PATTERN = 0;
					host.write(super.Vlib.DPC_LIST_CTRL,  (1<<15)+(1<<13) + (1<<12) + i ); // DPC_ENABLE= 0, DPC_PATTERN0_CFG=1, DPC_LIST_WRN=1, DPC_LIST_ADD + SS

					XGS_imageSRC.DPC_add(i, i, DPC_PATTERN);                    // Pour la prediction, ici j'incremente de 1 le nb de DPC a chaque appel          
				end

				host.write(super.Vlib.DPC_LIST_CTRL,  (i<<16) + (REG_DPC_PATTERN0_CFG<<15)+(1<<14) );  // DPC_LIST_COUNT() + DPC_PATTERN0_CFG(15), DCP ENABLE(14)=1
				XGS_imageSRC.DPC_set_pattern_0_cfg(REG_DPC_PATTERN0_CFG);                   // Pour la prediction 
				XGS_imageSRC.DPC_set_firstlast_line_rem(0);                                 // Pour la prediction 




				///////////////////////////////////////////////////
				// Trigger ROI #0
				///////////////////////////////////////////////////	           
				ROI_X_START = 0;
				ROI_X_SIZE  = super.Vlib.P_ROI_WIDTH;       // Xsize sans interpolation(pour l'instant) 
				ROI_X_END   = ROI_X_START + ROI_X_SIZE - 1;

				ROI_Y_START = 4;           // Doit etre multiple de 4 
				ROI_Y_SIZE  = 8;           // Doit etre multiple de 4, // Doit etre multiple de 4, (ROI_Y_START+ROI_Y_SIZE) < (5M:2078, 12M:3102, 16M:4030)
				ROI_Y_END   = ROI_Y_START + ROI_Y_SIZE - 1;

				SUB_X       = 0;
				SUB_Y       = 0;

				EXPOSURE    = 50; // exposure=50us

				$display("IMAGE Trigger #0, Xstart=%0d, Xsize=%0d, Ystart=%0d, Ysize=%0d", ROI_X_START, ROI_X_SIZE, ROI_Y_START, ROI_Y_SIZE);
				super.Vlib.host.write(super.Vlib.SENSOR_ROI_Y_START_OFFSET, ROI_Y_START/4);
				super.Vlib.host.write(super.Vlib.SENSOR_ROI_Y_SIZE_OFFSET, ROI_Y_SIZE/4);
				super.Vlib.host.write(super.Vlib.SENSOR_SUBSAMPLING_OFFSET, ((SUB_Y<<3) + SUB_X) ); 				
				super.Vlib.host.write(super.Vlib.EXP_CTRL1_OFFSET, EXPOSURE * (1000.0 /16.0));             // Exposure 50us @100mhz
				super.Vlib.host.write(super.Vlib.GRAB_CTRL_OFFSET, (1<<15)+(1<<8)+1);                      // Grab_ctrl: source is immediate + trig_overlap + grab cmd
				test_nb_images++;

				// Prediction	 	
				XGS_image = XGS_imageSRC.copy;
				XGS_image.reduce_bit_depth(10);                                               // Converti Image 12bpp a 10bpp  
				XGS_image.cropXdummy(super.Vlib.MODEL_X_START, super.Vlib.MODEL_X_END);       // Remove all dummies and black ref, so X is 0 reference!
				XGS_image.crop(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END);
				XGS_image.sub(SUB_X, SUB_Y);

				XGS_imageDPC = XGS_image.copy;				
				XGS_imageDPC.Correct_DeadPixels(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y);	
				XGS_image = XGS_imageDPC.copy;
				XGS_imageDPC = null;				

				XGS_image.reduce_bit_depth(8);                          // Converti Image 10bpp a 8bpp (path DMA)
				scoreboard.predict_img(XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch);

				///////////////////////////////////////////////////
				// Trigger ROI #1
				///////////////////////////////////////////////////	           
				ROI_X_START = 0;
				ROI_X_SIZE  = super.Vlib.P_ROI_WIDTH;       // Xsize sans interpolation(pour l'instant) 
				ROI_X_END   = ROI_X_START + ROI_X_SIZE - 1;

				ROI_Y_START = 0;           // Doit etre multiple de 4 
				ROI_Y_SIZE  = 128;         // Doit etre multiple de 4, // Doit etre multiple de 4, (ROI_Y_START+ROI_Y_SIZE) < (5M:2078, 12M:3102, 16M:4030)
				ROI_Y_END   = ROI_Y_START + ROI_Y_SIZE - 1;

				SUB_X       = 0;
				SUB_Y       = 1;

				EXPOSURE    = 50; // exposure=50us

				$display("IMAGE Trigger #0, Xstart=%0d, Xsize=%0d, Ystart=%0d, Ysize=%0d", ROI_X_START, ROI_X_SIZE, ROI_Y_START, ROI_Y_SIZE);
				super.Vlib.host.write(super.Vlib.SENSOR_ROI_Y_START_OFFSET, ROI_Y_START/4);
				super.Vlib.host.write(super.Vlib.SENSOR_ROI_Y_SIZE_OFFSET, ROI_Y_SIZE/4);
				super.Vlib.host.write(super.Vlib.SENSOR_SUBSAMPLING_OFFSET, ((SUB_Y<<3) + SUB_X) ); 				
				super.Vlib.host.write(super.Vlib.EXP_CTRL1_OFFSET, EXPOSURE * (1000.0 /16.0));             // Exposure 50us @100mhz
				super.Vlib.host.write(super.Vlib.GRAB_CTRL_OFFSET, (1<<15)+(1<<8)+1);                      // Grab_ctrl: source is immediate + trig_overlap + grab cmd
				test_nb_images++;

				// Prediction	 	
				XGS_image = XGS_imageSRC.copy;
				XGS_image.reduce_bit_depth(10);                                               // Converti Image 12bpp a 10bpp  
				XGS_image.cropXdummy(super.Vlib.MODEL_X_START, super.Vlib.MODEL_X_END);       // Remove all dummies and black ref, so X is 0 reference!
				XGS_image.crop(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END);
				XGS_image.sub(SUB_X, SUB_Y);

				XGS_imageDPC = XGS_image.copy;				
				XGS_imageDPC.Correct_DeadPixels(ROI_X_START, ROI_X_END , ROI_Y_START, ROI_Y_END, SUB_X, SUB_Y);	
				XGS_image = XGS_imageDPC.copy;
				XGS_imageDPC = null;				

				XGS_image.reduce_bit_depth(8);                          // Converti Image 10bpp a 8bpp (path DMA)
				scoreboard.predict_img(XGS_image, super.Vlib.fstart, super.Vlib.line_size, super.Vlib.line_pitch);

				///////////////////////////////////////////////////
				// Wait for the 2 images
				///////////////////////////////////////////////////	   
				super.Vlib.host.wait_events (0, 2, 'hfffffff); // wait for 1 in IRQ(connected to input 0 of host)
                
				
				#250us;				
				super.say_goodbye();  
			end

		join_any;	

	endtask
    
endclass
