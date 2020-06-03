// Fichier imagepkg.sv
//
// Classe Image
// 
// Description:  
// La classe image sert a contenir une image de dimension variable
// Le array est un shortint supportant donc jusqu'a MONO16.
//
// usage:
// task load_image;
// Cette tache charge le fichier ""
// dans l'objet et enregistre la dimension X et Y a partir du fichier dans les variables accessibles:
// objet_image.pgm_size_x;
// objet_image.pgm_size_y;

//
// function CImage copy;
// Fait une deep-copy de l'objet, donc de l'image.
//
// task reduce_bit_depth;
// converti une image 10-bit provenant de load_image en image 8 bits en faisant un shift-right de 2 bits
// Todo: ajouter un parametre pour controler le shift en fonction du type de pixel desire
//
// function crop(input int x_min, x_max, y_min, y_max);
// reduit la dimension de l'image (cropping)
// par exemple, pour ramasser une image 1024x768 en haut a gauche de l'image source
// objet_image.crop(0,1023,0,767);
// todo: cette fonction ne fonctionne que si l'image source est au moins aussi grande que l'image destination. 
// todo: il faudrait ajouter des verifications dans le code
//
// function shortint get_pixel(input int x, y);
// va chercher la valeur du pixel a une coordonne x, y
// todo: ajouter la fonction set_pixel(x,y,valeur) par symetrie
//
// task print_8_pixel;
// affiche en hex la valeur des 8 premier pixels de l'image, pour debug.
//
//
// Exemple d'usage global
//    import Image::*;
//
// Image py_image;     
// Image grab_image;
//
// py_image = new;   // Alloue un objet image
// 
// py_image.load_image(); // charge l'image du fichier PGM
//
//
// grab_image = py_image.copy; // copier l'image de l'objet py_image a l'objet grab_image.
//
// grab_image.reduce_bit_depth; // convertir l'image de grab en 8 bits
//
// grab_image.crop(0,1919,0,7); // reduit l'image a 1920 pixels par 8 lignes
`timescale 1ns / 1ps

class CImage;

    //int i;
    //int pixel;
    shortint image[];
    integer pgm_size_x, pgm_size_y, pgm_max;

	
	function new();
 
	endfunction
	
	
    function CImage copy;
        copy = new; 
        copy.pgm_size_x = pgm_size_x; // Fill in data values
        copy.pgm_size_y = pgm_size_y;
        copy.pgm_max = pgm_max;
        copy.image = new[pgm_size_x * pgm_size_y];
        // copier l'image un element a la fois
        for (int j = 0; j < (pgm_size_x * pgm_size_y); j += 1) begin
            copy.image[j] = this.image[j];
        end

    endfunction

    task load_image ();

        integer fileId;
        int i;
        int pixel;

        string chaine;
    
	    $display("System Verilog load of PGM file in memory");
		
        fileId = $fopen( "C:/work/iris4/athena/local_ip/XGS_athena/validation/mti/XGS_image_hex12.pgm", "r" );   
        //if (fileId)  $display(".PGM File was opened successfully");
        //else         $display(".PGM File was NOT opened successfully");
		
		
        // le format est hardcode, le decodage qu'on en fait sera harcode aussi
        i = $fgets(chaine, fileId);        
        //$display(" %d ",chaine.compare("P2\n") );
        if(chaine.compare("P2\n")) begin
            $display("Debut de fichier PGM imprevu: %s", chaine);
            $stop;
        end
        
        i=$fscanf(fileId, "%d %d\n", this.pgm_size_x, this.pgm_size_y);    
		
        i=$fscanf(fileId, "%d", this.pgm_max);
        
        // patch pour que ca simule sur la PC a JF
        //if(pgm_size_y > 32) pgm_size_y = 32;
        
        $display("XSize=%d, YSize=%d, Max Pixel Value=%d", this.pgm_size_x, this.pgm_size_y, this.pgm_max);    
        
        this.image = new[pgm_size_x * pgm_size_y];
       
        for (int j = 0; j < (this.pgm_size_x * this.pgm_size_y); j += 1) begin
            i=$fscanf(fileId," %h", pixel);
            this.image[j] = pixel;
        end

        // debug: afficher la premiere ligne comme debug
        //for (int j = 0; j < (64); j += 8) begin
        //    $display("%h %h %h %h %h %h %h %h ", image[j], image[j+1], image[j+2], image[j+3], image[j+4], image[j+5], image[j+6], image[j+7] );
        //    pixel = image[j];
        //    image[j] = pixel;
        //end
        
       
        $fclose(fileId);
    endtask : load_image

	
	
    task allocate_image(int size_x, int size_y, int bpp);

        int pixel;

        this.pgm_size_x = size_x;
        this.pgm_size_y = size_y;
		if(bpp==8)
          this.pgm_max = 255;
		if(bpp==10)
          this.pgm_max = 1023;
		if(bpp==12)
          this.pgm_max = 4095;		  
        image = new[pgm_size_x * pgm_size_y];
        
        for (int j = 0; j < (pgm_size_x * pgm_size_y); j += 1) begin
          image[j] = 0;
        end

    endtask : allocate_image
    
    // inspire du code Iris3. 
    // en realite, la version generique devrait reduire le nombre de bit en fonction du type de buffer de sortie (Mono8, mono10, BGR32, etc.)
    // cependant, pour le projet courant, tout est mono8, alors on hardcode a mono8 comme premiere iteration
    task reduce_bit_depth();
    
      if (this.pgm_max == 4095) begin
        for (int j = 0; j < (pgm_size_x * pgm_size_y); j += 1) begin
            image[j] = image[j] >> 4;
        end
        // Si on divise tout le monde par 4, le max aussi descend par 4. Ca nous permet de faire une verification plus loin.
        this.pgm_max = this.pgm_max >> 4;
      end else if (this.pgm_max == 1023) begin
        for (int j = 0; j < (pgm_size_x * pgm_size_y); j += 1) begin
            image[j] = image[j] >> 2;
        end
        // Si on divise tout le monde par 4, le max aussi descend par 4. Ca nous permet de faire une verification plus loin.
        this.pgm_max = this.pgm_max >> 2;
      end else if (this.pgm_max == 255) begin
        $display("Image deja a 8 bits, reduce_bit_depth ne fera rien");
      end else begin
        $display("Ici on a des pixels autre que 8/10/12 bits : renvoyer ce cas a JF ou Javier!");
        $stop();
      end
      
    endtask : reduce_bit_depth 

    function void crop(input int x_min, x_max, y_min, y_max);
        
        //shortint new_image[];
        int new_size_x, new_size_y;    
        
        // determiner la nouvelle dimension
        new_size_x = x_max - x_min + 1;
        new_size_y = y_max - y_min + 1;

        // allouer et copier dans un nouveau array.
        // on presume que crop reduit la dimension tout le temps, il faudrait le verifier
        if(new_size_x > pgm_size_x) begin
            $display("Appel illegal a crop(), size_x plus grand que le array source");
            $stop();
        end
        if(new_size_y > pgm_size_y) begin
            $display("Appel illegal a crop(), size_y plus grand que le array source");
            $stop();
        end
        //new_image = new[new_size_x*new_size_y];
        for(int y = 0; y < new_size_y; y += 1)
            for(int x = 0; x < new_size_x; x += 1)
                image[y * new_size_x + x] = get_pixel(x+x_min,y + y_min);

        // replacer dans l'image
        image = new[new_size_x*new_size_y](image); // ici il faut faire une reallocation reduite!
        pgm_size_x = new_size_x;
        pgm_size_y = new_size_y;
         
    endfunction : crop 

    // reverse dans la direction x
    function void reverse_x();
        
      // tableau qui tient une ligne a la fois.
      shortint old_image[];
      
      old_image = image;  // fera l'allocation automagiquement!
      
      for(int y = 0; y < pgm_size_y; y += 1)
        for(int x = 0; x < pgm_size_x; x += 1)
          //image[y * pgm_size_x + x] = get_pixel(pgm_size_x -1 -x, y);
          image[y * pgm_size_x + x] = old_image[y * pgm_size_x + pgm_size_x -1 -x];

    endfunction : reverse_x 

    function shortint get_pixel(input int x, y);
        //return image[y * pgm_size_x + x];
        get_pixel = image[y * pgm_size_x + x];
    endfunction
    
    function void set_pixel(input int x, y, input shortint value);
         //$display("Enter SetPixel  x=%d, y=%d value=%d", x, y, value );
         //$display("Image pixel before wrote value=%d", image[y * pgm_size_x + x] );
         image[y * pgm_size_x + x]= value;
         //$display("Image pixel after wrote value=%d", image[y * pgm_size_x + x] );        
    endfunction

    // c'est juste pour le debug
    task print_pixel(int X, int Y);
        int pixel;
        $display("Pixel(%d,%d): 0x%h ", X, Y, get_pixel(X,Y));
    endtask : print_pixel
    
endclass :  CImage    


