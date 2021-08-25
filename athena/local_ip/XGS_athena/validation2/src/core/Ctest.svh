import core_pkg::*;
import driver_pkg::*;



virtual class Ctest;

   
    string name; 
     
    bit [31:0] linkif_addr;
    Cvlib Vlib;
    Cstatus TestStatus;
    Cdriver_axil  host;
    virtual axi_stream_interface tx_axis_if;


    function new(string name,  Cdriver_axil host, virtual axi_stream_interface tx_axis_if);
        
        this.name       = name;
        this.TestStatus = new();
        
        this.host       = host;  
        this.tx_axis_if = tx_axis_if;


        // Allouer notre lib de test
        this.Vlib = new(host, TestStatus, tx_axis_if);


        
    endfunction
    

           
    pure virtual task run;

    function void say_hello();
        $display("*************************************");
        $display("** %s", this.name);
        $display("*************************************");
    endfunction


    function void say_goodbye();
        $display("*************************************");
        if(this.TestStatus.errors == 0)
        begin
            $display("******* %s PASS  =)     *******",this.name);
        end
        else
        begin
            $display("******* %s FAIL  =(    *******",this.name);
        end
        $display("*************************************");
        $display(" Error   : %d",this.TestStatus.errors);
        $display(" Warning : %d",this.TestStatus.warnings);
        $display("\n\n");
    endfunction

    
endclass : Ctest

// Pour faire un Factory (voir https://fr.wikipedia.org/wiki/Fabrique_(patron_de_conception) ).
// On cree un Proxy pour creer chacun des tests derives
virtual class CtestProxy;
  pure virtual function Ctest createTest(Cdriver_axil host, virtual axi_stream_interface tx_axis_if);
endclass : CtestProxy


CtestProxy factory[CtestProxy];


class objectRegistry#(type T) extends CtestProxy;
  
  // Allocation du test, remplace new()
  virtual function T createTest(Cdriver_axil host, virtual axi_stream_interface tx_axis_if);
    T obj;
    obj = new(host, tx_axis_if);
    return obj;
  endfunction
  
  local static objectRegistry#(T) me = get();

  // Singleton. sert a enregistrer le test dans le factory au premier appel
  static function objectRegistry#(T) get();
    string temp;
    string cmptemp;
    if (me == null) begin
      me = new();
      factory[me] = me;     
    end
    return me;
  endfunction: get
  
endclass : objectRegistry

  

