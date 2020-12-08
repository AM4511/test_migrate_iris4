//---------------------------------------------------------------------------
// Testbench  
//---------------------------------------------------------------------------
//
//***************************************************************************
//
 

`timescale 1ns / 1ps

import tests_pkg::*;
import driver_pkg::*;



module testbench;

 	parameter AXIL_DATA_WIDTH  = 32;
	parameter AXIL_ADDR_WIDTH  = 11;
  parameter AXIS_DATA_WIDTH  = 64;
	parameter AXIS_USER_WIDTH  = 4;
	parameter GPIO_NUMB_INPUT  = 1;
	parameter GPIO_NUMB_OUTPUT = 2;

  reg tb_CLK;
  reg tb_RESETn;
 
  int nb_errors = 1; // flag d'erreur retourne au .TCL appelant. Par defaut a 1 pour ramasser le cas ou on ne se rend pas a la fin.
  
  // Define Driver
  Cdriver_axil  #(.DATA_WIDTH(AXIL_DATA_WIDTH), .ADDR_WIDTH(AXIL_ADDR_WIDTH), .NUMB_INPUT_IO(GPIO_NUMB_INPUT), .NUMB_OUTPUT_IO(GPIO_NUMB_OUTPUT)) host;
	
  // Define the interfaces
	axi_lite_interface  axil_if();
	axi_stream_interface #(.T_DATA_WIDTH(AXIS_DATA_WIDTH), .T_USER_WIDTH(AXIS_USER_WIDTH)) tx_axis_if();

	io_interface #(GPIO_NUMB_INPUT,GPIO_NUMB_OUTPUT) gpio_if();
  wire [1:0] XGSmodel_sel;

  // Liste de tests
  Test0001 test0001;
  Test0002 test0002;  
  Test0003 test0003;  
  
  // un jour je trouverai comment faire l'auto-registration dans chaque objet...  
  CTest t;
  CTestProxy top_string_factory[string];
  string test_number_string;
  string test_index;

  initial 
  begin       
      tb_CLK = 1'b0;
  end
  
  //------------------------------------------------------------------------
  // Simple Clock Generator
  //------------------------------------------------------------------------
  always #8 tb_CLK = !tb_CLK;

    
  initial begin
  
      $timeformat(-9, 3, " ns", 20);
      
	  	// Initialize classes
		  host = new(axil_if, gpio_if);


      //$display ("%m running the tb");

      // La bonne facon de faire les choses, c'est d'avoir un systeme d'auto-enregistrement pour chaque test.
      // Ca devrait etre fait dans chaque test specialise automagiquement.
      // Considerant que le probleme n'est pas trivial, on va commencer par enregistrer manuellement chaque test, pour faire avancer le reste du projet
      // et je revindrai sur l'auto-registery plus tard.
      // Le concept ici est d'aller chercher un proxy sur l'objet test.  Ainsi on n'alloue pas le test directement, on ne fait que noter son existante dans une table d'indirection.
      // cette table peut ensuite etre utilise pour choisir quel test rouler dynamiquement, au lieu d'etre choisi statiquement a la compilation.
      top_string_factory["Test0001"] = objectRegistry#(Test0001)::get();
      top_string_factory["Test0002"] = objectRegistry#(Test0002)::get();
      top_string_factory["Test0003"] = objectRegistry#(Test0003)::get();

      tb_RESETn = 1'b0;
      repeat(20)@(posedge tb_CLK);
      tb_RESETn = 1'b1;
      @(posedge tb_CLK);
      
      
      repeat(15) @(posedge tb_CLK);
       
      if ($value$plusargs("TestNumber=%s",test_number_string)) begin
        $display("TestNumber= is defined");
        $display("Test is Test%s.",test_number_string);
        $sformat(test_index, "Test%s", test_number_string);
        if (top_string_factory[test_index] != null) begin
          t = top_string_factory[test_index].createTest(host, tx_axis_if);
          t.run();
          // comptabiliser les erreurs pour pouvoir retourner le resultat a l'appelant
          nb_errors = t.TestStatus.errors + t.TestStatus.warnings;
          t = null;
        end else begin
          $display("Numero de test demande %s inexistant dans factory!", test_number_string);
          nb_errors++;
          $stop();
        end
      end else begin
        $display("TestNumber= is not defined, manual test sequence");
                
        // Nouvelle facon de lancer un test specifique: 
        t = top_string_factory["Test0001"].createTest(host, tx_axis_if);        
        t.run();
        t = null;    

        //t = top_string_factory["Test0002"].createTest(host);        
        //t.run();
        //t = null;    

        //t = top_string_factory["Test0003"].createTest(host);        
        //t.run();
        //t = null;    

      end
     

      $display ("Simulation completed");
      $display("Time is %0t",$time); 
      // si on se rend ici, alors on peut se fier aux erreur accumulees dans l'objet liste de tests.
      //nb_errors = testlist.TestStatus.errors;
      $finish;
  end



assign axil_if.clk             = tb_CLK;
assign tx_axis_if.aclk         = tb_CLK;
assign tx_axis_if.areset_n     = axil_if.reset_n;

assign XGSmodel_sel = {gpio_if.output_reg[1], gpio_if.output_reg[0]};

system_top system_top (

	.aclk(axil_if.clk),
	.aclk_reset_n(axil_if.reset_n),
	.aclk_awaddr(axil_if.awaddr),
	.aclk_awprot(axil_if.awprot),
	.aclk_awvalid(axil_if.awvalid),
	.aclk_awready(axil_if.awready),
	.aclk_wdata(axil_if.wdata),
	.aclk_wstrb(axil_if.wstrb),
	.aclk_wvalid(axil_if.wvalid),
	.aclk_wready(axil_if.wready),
	.aclk_bresp(axil_if.bresp),
	.aclk_bvalid(axil_if.bvalid),
	.aclk_bready(axil_if.bready),
	.aclk_araddr(axil_if.araddr),
	.aclk_arprot(axil_if.arprot),
	.aclk_arvalid(axil_if.arvalid),
	.aclk_arready(axil_if.arready),
	.aclk_rdata(axil_if.rdata),
	.aclk_rresp(axil_if.rresp),
	.aclk_rvalid(axil_if.rvalid),
	.aclk_rready(axil_if.rready),

 	.s_axis_tx_tready(tx_axis_if.tready), 
 	.s_axis_tx_tdata(tx_axis_if.tdata),
	.s_axis_tx_tlast(tx_axis_if.tlast),
	.s_axis_tx_tvalid(tx_axis_if.tvalid),
	.s_axis_tx_tuser(tx_axis_if.tuser),  
  
  .irq_dma(gpio_if.input_io[0]),
  .XGSmodel_sel(XGSmodel_sel)

);

endmodule

  