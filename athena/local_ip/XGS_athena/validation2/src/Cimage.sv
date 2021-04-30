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
	  integer pgm_size_x, pgm_size_y, pgm_max;
    shortint image[];
    shortint image_DPC[];

    typedef struct packed{
      int dpc_x, dpc_y, dpc_pat;
	  } DPC_element;

    DPC_element dpc_list[512];

    int dpc_list_count=0;
	  int dpc_pattern_0_cfg=0;
    int dpc_firstlast_line_rem =0;


	function new();

	endfunction


    function CImage copy;
        copy = new;
        copy.pgm_size_x = pgm_size_x; // Fill in data values
        copy.pgm_size_y = pgm_size_y;
        copy.pgm_max = pgm_max;
        copy.image = new[pgm_size_x * pgm_size_y];

        copy.dpc_list               = dpc_list;
        copy.dpc_list_count         = dpc_list_count;
        copy.dpc_pattern_0_cfg      = dpc_pattern_0_cfg;
        copy.dpc_firstlast_line_rem = dpc_firstlast_line_rem;

        // copier l'image un element a la fois
        for (int j = 0; j < (pgm_size_x * pgm_size_y); j += 1) begin
            copy.image[j] = this.image[j];
        end




    endfunction

    task load_image (int XGSmodel);

        integer fileId;
        int i;
        int pixel;

        string chaine;

	      $display("System Verilog load of PGM file in memory");

        if(XGSmodel==5000) begin
          fileId = $fopen( "XGS_image_5000_hex12.pgm", "r" );
        end
        if(XGSmodel==12000) begin
          fileId = $fopen( "XGS_image_12000_hex12.pgm", "r" );
        end
        if(XGSmodel==16000) begin
          fileId = $fopen( "XGS_image_16000_hex12.pgm", "r" );
        end

        //if (fileId)  $display(".PGM File was opened successfully");
        //else         $display(".PGM File was NOT opened successfully");


        // le format est hardcode, le decodage qu'on en fait sera harcode aussi
        i = $fgets(chaine, fileId);
        //$display(" %0d ",chaine.compare("P2\n") );
        if(chaine.compare("P2\n")) begin
            $display("Debut de fichier PGM imprevu: %s", chaine);
            $stop;
        end

        i=$fscanf(fileId, "%0d %0d\n", this.pgm_size_x, this.pgm_size_y);

        i=$fscanf(fileId, "%0d", this.pgm_max);

        // patch pour que ca simule sur la PC a JF
        //if(pgm_size_y > 32) pgm_size_y = 32;

        $display("XSize=%0d, YSize=%0d, Max Pixel Value=%0d", this.pgm_size_x, this.pgm_size_y, this.pgm_max);

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

    // XGS Iris GTX : Image source est toujours 12 bpp, alors cette fonction peux reduire :  12-> 12/10/8 et 10->10/8
    task reduce_bit_depth(input int resolution);

      if (this.pgm_max == 4095) begin
        for (int j = 0; j < (pgm_size_x * pgm_size_y); j += 1) begin
            if(resolution==12)
              image[j] = image[j] >> 0;
            if(resolution==10)
              image[j] = image[j] >> 2;
            if(resolution==8)
              image[j] = image[j] >> 4;
        end
        // Si on divise tout le monde par X, le max aussi descend par X. Ca nous permet de faire une verification plus loin.
        if(resolution==12)
          this.pgm_max = this.pgm_max >> 0;
        if(resolution==10)
          this.pgm_max = this.pgm_max >> 2;
        if(resolution==8)
          this.pgm_max = this.pgm_max >> 4;

      end else if (this.pgm_max == 1023) begin
        for (int j = 0; j < (pgm_size_x * pgm_size_y); j += 1) begin
            if(resolution==10)
              image[j] = image[j] >> 0;
            if(resolution==8)
              image[j] = image[j] >> 2;
        end
        // Si on divise tout le monde par X, le max aussi descend par X. Ca nous permet de faire une verification plus loin.
        if(resolution==10)
          this.pgm_max = this.pgm_max >> 0;
        if(resolution==8)
          this.pgm_max = this.pgm_max >> 2;

      //end else if (this.pgm_max == 255) begin
      //  $display("Image deja a 8 bits, reduce_bit_depth ne fera rien");
      end else begin
        $display("On supporte seulement des reduction 12->10,8 et 10->10,8 : renvoyer ce cas a Javier!");
        $stop();
      end

    endtask : reduce_bit_depth

    // Remove X Dummy, BlacksRefs... etc from image
    function void cropXdummy(input int x_start, x_end);


        int new_size_x;

        // determiner la nouvelle dimension
        new_size_x = x_end - x_start + 1;

        // allouer et copier dans un nouveau array.
        // on presume que crop reduit la dimension tout le temps, il faudrait le verifier
        if(new_size_x > pgm_size_x) begin
            $display("Appel illegal a cropXdummy(), size_x plus grand que le array source");
            $stop();
        end

        //new_image = new[new_size_x*new_size_y];
        for(int y = 0; y < pgm_size_y; y += 1)
            for(int x = 0; x < new_size_x; x += 1)
                image[y * new_size_x + x] = get_pixel(x+x_start,y);

        // replacer dans l'image
        image = new[new_size_x*pgm_size_y](image); // ici il faut faire une reallocation reduite!
        pgm_size_x = new_size_x;
        pgm_size_y = pgm_size_y;

    endfunction : cropXdummy


    // CROP_X
    function void crop_X(input int x_start, input int x_end);

        int new_size_x ;

        // determiner la nouvelle dimension
        new_size_x = x_end - x_start + 1;

        // allouer et copier dans un nouveau array.
        // on presume que crop reduit la dimension tout le temps, il faudrait le verifier
        if(new_size_x > pgm_size_x) begin
            $display("Appel illegal a crop(), size_x plus grand que le array source");
            $stop();
        end

        //new_image = new[new_size_x*new_size_y];
        for(int y = 0; y < pgm_size_y; y += 1)
            for(int x = 0; x < new_size_x; x += 1)
                image[y * new_size_x + x] = get_pixel(x+x_start, y);

        // replacer dans l'image
        image = new[new_size_x*pgm_size_y](image); // ici il faut faire une reallocation reduite!
        pgm_size_x = new_size_x;


    endfunction : crop_X


    // CROP_Y
    function void crop_Y(input int y_start, input int y_end);

        int new_size_y;

        // determiner la nouvelle dimension
        new_size_y = y_end - y_start + 1;

        // allouer et copier dans un nouveau array.
        // on presume que crop reduit la dimension tout le temps, il faudrait le verifier
        if(new_size_y > pgm_size_y) begin
            $display("Appel illegal a crop_Y(), size_y plus grand que le array source");
            $stop();
        end

        //Y CROP : Y_start and Y_size must be multiple of 4 lines
        if(new_size_y % 4 != 0) begin
            $display("Appel illegal a crop_Y(), XGS Y_size doit etre multiple de 4");
            $stop();
        end
        if(y_start % 4 != 0) begin
            $display("Appel illegal a crop_Y(), XGS Y_Start doit etre multiple de 4");
            $stop();
        end

        //new_image = new[pgm_size_x*new_size_y];
        for(int y = 0; y < new_size_y; y += 1)
            for(int x = 0; x < pgm_size_x; x += 1)
                image[y * pgm_size_x + x] = get_pixel(x,y + y_start);

        // replacer dans l'image
        image = new[pgm_size_x*new_size_y](image); // ici il faut faire une reallocation reduite!
        pgm_size_y = new_size_y;

    endfunction : crop_Y




   function void sub_Y(input int y_sub);

        //shortint new_image[];
        int new_size_y, y_factor;

        // determiner la nouvelle dimension
        if(y_sub==1) begin
          new_size_y = pgm_size_y/2;
          y_factor   = 2;

          //new_image = new[pgm_size_x*new_size_y];
          for(int y = 0; y < new_size_y; y += 1)
            for(int x = 0; x < pgm_size_x; x += 1)
                image[y * pgm_size_x + x] = get_pixel(x, y*y_factor);

          // replacer dans l'image
          image = new[pgm_size_x*new_size_y](image); // ici il faut faire une reallocation reduite!
          pgm_size_y = new_size_y;
        end


    endfunction : sub_Y



    function void sub_X(input int x_sub);

        //shortint new_image[];
        int new_size_x, x_factor;

        // determiner la nouvelle dimension
        if(x_sub==1) begin
          new_size_x = pgm_size_x/2;
          x_factor   = 2;

          //new_image = new[new_size_x*pgm_size_y];
          for(int y = 0; y < pgm_size_y; y += 1)
            for(int x = 0; x < new_size_x; x += 1)
                image[y * new_size_x + x] = get_pixel(x*x_factor,y);

          // replacer dans l'image
          image = new[new_size_x*pgm_size_y](image); // ici il faut faire une reallocation reduite!
          pgm_size_x = new_size_x;
        end

    endfunction : sub_X


//    // reverse dans la direction x
//    function void rev_X(input int x_rev);
//
//      if(x_rev==1) begin
//
//        for(int y = 0; y < pgm_size_y; y += 1)
//          for(int x = 0; x < pgm_size_x; x += 1)
//            //image[y * pgm_size_x + x] = get_pixel(pgm_size_x -1 -x, y);
//            image[y * pgm_size_x + x] = image[y * pgm_size_x + pgm_size_x -1 -x];
//      end
//
//    endfunction : rev_X

    // reverse dans la direction x
    function void rev_X(input int x_rev);

    	shortint image_new[];
    	image_new = new[pgm_size_x * pgm_size_y];

    	if(x_rev==1) begin

    		for(int y = 0; y < pgm_size_y; y += 1)
    			for(int x = 0; x < pgm_size_x; x += 1)
    				image_new[y * pgm_size_x + x] = image[y * pgm_size_x + pgm_size_x -1 -x];

    		image = new[pgm_size_x*pgm_size_y](image_new); // ici il faut faire une reallocation augmentee!
   	    end

    	// replacer dans l'image
    	image_new.delete;

    endfunction : rev_X

//    // reverse dans la direction Y
//    function void rev_Y(input int y_rev);
//
//      shortint image_copy[];
//
//      if(y_rev==1) begin
//        image_copy = image;
//        for(int y = 0; y < pgm_size_y; y += 1)
//          for(int x = 0; x < pgm_size_x; x += 1)
//            image[y * pgm_size_x + x] = image_copy[ (pgm_size_y-1-y)*pgm_size_x + x];
//      end
//
//      //delete array
//      image_copy.delete;
//
//    endfunction : rev_Y




    function shortint get_pixel_DPC(input int x, y);
        //return image[y * pgm_size_x + x];
        get_pixel_DPC = image_DPC[y * pgm_size_x + x];
    endfunction : get_pixel_DPC

    function shortint get_pixel(input int x, y);
        //return image[y * pgm_size_x + x];
        get_pixel = image[y * pgm_size_x + x];
    endfunction : get_pixel

    function void set_pixel(input int x, y, input shortint value);
         //$display("Enter SetPixel  x=%0d, y=%0d value=%0d", x, y, value );
         //$display("Image pixel before wrote value=%0d", image[y * pgm_size_x + x] );
         image[y * pgm_size_x + x]= value;
         //$display("Image pixel after wrote value=%0d", image[y * pgm_size_x + x] );
    endfunction

    // c'est juste pour le debug
    task print_pixel(int X, int Y);
        int pixel;
        $display("Pixel(%0d,%0d): 0x%h ", X, Y, get_pixel(X,Y));
    endtask : print_pixel



    //---------------------------------------------------------------------------------------------------------------------
    //  This function adds one DPC pixels to the list
    //---------------------------------------------------------------------------------------------------------------------
    function void DPC_add(input int x, y, pattern);
      dpc_list[dpc_list_count]= '{x, y, pattern};
      $display("System Verilog predictor : Enter DPC_add function : %0d %0d %0d %0d", dpc_list_count, x, y, pattern);
      dpc_list_count++;
    endfunction : DPC_add

    function void DPC_set_pattern_0_cfg(input int DPC_PATTERN0_CFG);
       dpc_pattern_0_cfg = DPC_PATTERN0_CFG;
    endfunction

    function void DPC_set_firstlast_line_rem(input int firstlast_line_rem);
       dpc_firstlast_line_rem = firstlast_line_rem;
    endfunction

    //---------------------------------------------------------------------------------------------------------------------
    //  This task correct dead pixel from one image stored in Class ---- to a new corrected image stored in DPC_grab_image Class.
    //---------------------------------------------------------------------------------------------------------------------
    task Correct_DeadPixels(input int x_start, input int x_end, input int y_start, input int y_end, input int SUB_X, input int SUB_Y);

      int HeadID=0;

      shortint expected_data10=0;

      int Translated_ROIx;
      int Translated_ROIy;

      image_DPC = image;	// fera l'allocation automagiquement!, utilise par get_pixel_DPC pour aller chercher pixels ds image originale

      //$display("Correct_DeadPixels x_start=%0d, x_end=%0d, y_start=%0d, y_end=%0d", x_start, x_end, y_start, y_end);

      if(SUB_Y==1) //Si subsampling, il faut enlever 1 a y_end: la derniere ligne est forcement paire!
        y_end=y_end-1;
      if(SUB_X==1) //Si subsampling, il faut enlever 1 a x_end: la derniere ligne est forcement paire!
        x_end=x_end-1;


      for(int dpc=0; dpc < dpc_list_count; dpc+=1)
      begin
        //$display("Correct_DeadPixels loop %0d/%0d, dpc_firstlast_line_rem=%0d dpc_x=%0d dpc_y=%0d", dpc, dpc_list_count, dpc_firstlast_line_rem, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y );
        if (  (dpc_firstlast_line_rem==0 && dpc_list[dpc].dpc_x >= x_start &&  dpc_list[dpc].dpc_x <= x_end &&  dpc_list[dpc].dpc_y >= y_start &&  dpc_list[dpc].dpc_y <= y_end ) ||
              (dpc_firstlast_line_rem==1 && dpc_list[dpc].dpc_x >= x_start &&  dpc_list[dpc].dpc_x <= x_end &&  dpc_list[dpc].dpc_y >  y_start &&   dpc_list[dpc].dpc_y < y_end )
           )
            //Dont correct corners of image/ROI
            if ( (dpc_list[dpc].dpc_x == x_start &&  dpc_list[dpc].dpc_y == y_start) ||
                 (dpc_list[dpc].dpc_x == x_end   &&  dpc_list[dpc].dpc_y == y_start) ||
                 (dpc_list[dpc].dpc_x == x_start &&  dpc_list[dpc].dpc_y == y_end)   ||
                 (dpc_list[dpc].dpc_x == x_end   &&  dpc_list[dpc].dpc_y == y_end)
              )
              $display("HeadID %0d, Correct_DeadPixels: DPC do not correct coner image pixels", HeadID );
            else
                begin
                    if( (SUB_Y==0 || (SUB_Y==1 && dpc_list[dpc].dpc_y%2==0))  && (SUB_X==0 || (SUB_X==1 && dpc_list[dpc].dpc_x%2==0))  ) begin
                      Translated_ROIx = (dpc_list[dpc].dpc_x - x_start)/(SUB_X+1);
                      Translated_ROIy = (dpc_list[dpc].dpc_y - y_start)/(SUB_Y+1);

                      if(dpc_list[dpc].dpc_x == x_start)
                        correct_pixel(Translated_ROIx, Translated_ROIy, dpc_list[dpc].dpc_pat, dpc_pattern_0_cfg, expected_data10, 1, 0, 0, 0);         // Correct first column of ROI
                      else
                        if(dpc_list[dpc].dpc_y == y_start)
                          correct_pixel(Translated_ROIx, Translated_ROIy, dpc_list[dpc].dpc_pat, dpc_pattern_0_cfg, expected_data10, 0, 0, 1, 0);       // Correct first line of ROI
                        else
                          if (dpc_list[dpc].dpc_y == y_end)
                            correct_pixel(Translated_ROIx, Translated_ROIy, dpc_list[dpc].dpc_pat, dpc_pattern_0_cfg, expected_data10, 0, 0, 0, 1);     // Correct last line of ROI
                          else
                            if( dpc_list[dpc].dpc_x == x_end )
                              correct_pixel(Translated_ROIx, Translated_ROIy, dpc_list[dpc].dpc_pat, dpc_pattern_0_cfg, expected_data10, 0, 1, 0, 0 );  // Correct last colunm of ROI
                            else
                              correct_pixel(Translated_ROIx, Translated_ROIy, dpc_list[dpc].dpc_pat, dpc_pattern_0_cfg, expected_data10, 0, 0, 0, 0);   // Correct rest of image

                      $display("HeadID %0d, Correct_DeadPixels: x=%0d, y=%0d Expected=%0d", HeadID, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y, expected_data10);
                      //DPC_grab_image.set_pixel(Translated_ROIx, Translated_ROIy, expected_data10);
                      set_pixel(Translated_ROIx, Translated_ROIy, expected_data10);
                    end else
                      begin
                        $display("HeadID %0d, Correct_DeadPixels: Pixel x=%0d, y=%0d not corrected because Subsampling Y applied", HeadID, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y);
                      end
                end
        else begin
            $display("HeadID %0d, Correct_DeadPixels: Pixel x=%0d, y=%0d not corrected because out of ROI", HeadID, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y);
        end
      end

    endtask : Correct_DeadPixels



    //----------------------------------------------------------------------------------------
    //  This task takes a x,y and pattern, pixel and returns a corrected pixel from the image
    //----------------------------------------------------------------------------------------
    task correct_pixel(input int x, input int y, input int pattern, input int reg_dcp_pattern0_cfg, output shortint pix_corrected, input int FirstCol, input int LastCol, input int FirstLine, input int LastLine);
      //temp
      int HeadID=0;
      int printinfo=0;

      //if(printinfo==1) $display("Correct_pixel : x=%0d y=%0d pattern=%0d reg_dcp_pattern0_cfg=%0d FirstCol=%0d LastCol=%0d FirstLine=%0d LastLine=%0d ", x,  y,  pattern,  reg_dcp_pattern0_cfg,  FirstCol, LastCol, FirstLine,  LastLine);

      if(pattern==0)
        begin
            if(reg_dcp_pattern0_cfg==1) begin
              pix_corrected  = 1023;
              if(printinfo==1) if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for DEBUG pixel(x=%0d, y=%0d, Pat=%0d) is : %0d bpp10, %0d bpp8", HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else begin
              pix_corrected  = get_pixel_DPC(x,y);
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for DEBUG pixel(x=%0d, y=%0d, Pat=%0d) is current pixel bypass: %0d bpp10, %0d bpp8", HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
        end

      if(pattern==68)
        begin
          if(FirstCol==1 || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
          else
             if(FirstLine==1) begin
               pix_corrected  = get_pixel_DPC(x,y+1) ;
               if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
               end
             else
               if(LastLine==1) begin
                 pix_corrected  = get_pixel_DPC(x,y-1) ;
                 if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for LastLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                 end
               else begin
                 pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1;
                 if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
                 end
        end

      if(pattern==51)
        begin
          if(FirstCol==1) begin
            pix_corrected  = get_pixel_DPC(x+1,y) ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastCol==1) begin
              pix_corrected  = get_pixel_DPC(x-1,y) ;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(FirstLine==1 || LastLine==1 ) begin
                pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else begin
                pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x-1,y+1) + get_pixel_DPC(x+1,y-1) + get_pixel_DPC(x+1,y) ) >> 2;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y), get_pixel_DPC(x-1,y+1), get_pixel_DPC(x+1,y-1), get_pixel_DPC(x+1,y), pix_corrected, pix_corrected>>2 );
                end
        end

      if(pattern==153)
        begin
          if(FirstCol==1) begin
            pix_corrected  = get_pixel_DPC(x+1,y) ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastCol==1) begin
              pix_corrected  = get_pixel_DPC(x-1,y) ;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(FirstLine==1 || LastLine==1 ) begin
                pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else begin
                pix_corrected  = ( get_pixel_DPC(x-1,y-1) + get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) + get_pixel_DPC(x+1,y+1) ) >> 2;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y-1), get_pixel_DPC(x-1,y), get_pixel_DPC(x+1,y), get_pixel_DPC(x+1,y+1), pix_corrected, pix_corrected>>2 );
              end

        end

      if(pattern==170 )
        begin
          if(FirstCol==1) begin
            pix_corrected  = get_pixel_DPC(x+1,y+1) ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastCol==1) begin
              pix_corrected  = get_pixel_DPC(x-1,y+1) ;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(FirstLine==1 ) begin
                pix_corrected  = get_pixel_DPC(x-1,y+1);
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else
                if(LastLine==1 ) begin
                  pix_corrected  = get_pixel_DPC(x+1,y-1);
                  if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                  end
                else  begin
                  pix_corrected  = ( get_pixel_DPC(x-1,y-1) + get_pixel_DPC(x+1,y-1) + get_pixel_DPC(x-1,y+1) + get_pixel_DPC(x+1,y+1) ) >> 2;
                  if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y-1), get_pixel_DPC(x+1,y-1), get_pixel_DPC(x-1,y+1), get_pixel_DPC(x+1,y+1), pix_corrected, pix_corrected>>2 );
                  end
        end


      if(pattern==119)  //6 to 4 conversion
        begin
          if(FirstCol==1 || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
            else
              if(FirstLine==1 || LastLine==1 ) begin
                pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else  begin
                pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x-1,y) + get_pixel_DPC(x,y+1) + get_pixel_DPC(x+1,y) ) >> 2;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x-1,y), get_pixel_DPC(x,y+1), get_pixel_DPC(x+1,y), pix_corrected, pix_corrected>>2 );
                end
        end

     if(pattern==221)  //6 to 4 conversion
        begin
          if(FirstCol==1  || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
          else
            if(FirstLine==1 || LastLine==1 ) begin
              pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else begin
              pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x-1,y) + get_pixel_DPC(x,y+1) + get_pixel_DPC(x+1,y) ) >> 2;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x-1,y), get_pixel_DPC(x,y+1), get_pixel_DPC(x+1,y), pix_corrected, pix_corrected>>2 );
              end
        end


      if(pattern==187)  //6 to 4 conversion
        begin
          if(FirstCol==1) begin
            pix_corrected  = get_pixel_DPC(x+1,y) ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastCol==1) begin
              pix_corrected  = get_pixel_DPC(x-1,y) ;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(FirstLine==1 || LastLine==1 ) begin
                pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else begin
                pix_corrected  = ( get_pixel_DPC(x-1,y-1) + get_pixel_DPC(x+1,y-1) + get_pixel_DPC(x-1,y+1) + get_pixel_DPC(x+1,y+1) ) >> 2;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y-1), get_pixel_DPC(x+1,y-1), get_pixel_DPC(x-1,y+1), get_pixel_DPC(x+1,y+1), pix_corrected, pix_corrected>>2 );
                end
        end

      if(pattern==136)
        begin
          if(FirstCol==1) begin
            pix_corrected  = get_pixel_DPC(x+1,y+1) ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastCol==1) begin
              pix_corrected  = get_pixel_DPC(x-1,y-1) ;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(FirstLine==1 ) begin
                pix_corrected  = get_pixel_DPC(x+1,y+1);
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else
                if(LastLine==1 ) begin
                  pix_corrected  = get_pixel_DPC(x-1,y-1);
                  if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                  end
                else  begin
                  pix_corrected  = ( get_pixel_DPC(x-1,y-1) + get_pixel_DPC(x+1,y+1) ) >> 1;
                  if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y-1), get_pixel_DPC(x+1,y+1), pix_corrected, pix_corrected>>2 );
                  end
        end

      if(pattern==17)
        begin
          if(FirstCol==1) begin
            pix_corrected  = get_pixel_DPC(x+1,y) ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastCol==1) begin
              pix_corrected  = get_pixel_DPC(x-1,y) ;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(FirstLine==1 || LastLine==1 ) begin
                pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else begin
                pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x+1,y-1), get_pixel_DPC(x+1,y+1), pix_corrected, pix_corrected>>2 );
                end
        end

      if(pattern==34)
        begin
          if(FirstCol==1) begin
            pix_corrected  = get_pixel_DPC(x+1,y-1) ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastCol==1) begin
              pix_corrected  = get_pixel_DPC(x-1,y+1) ;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(FirstLine==1 ) begin
                pix_corrected  = get_pixel_DPC(x-1,y+1);
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else
                if(LastLine==1 ) begin
                  pix_corrected  = get_pixel_DPC(x+1,y-1);
                  if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                  end
                else begin
                  pix_corrected  = ( get_pixel_DPC(x+1,y-1) + get_pixel_DPC(x-1,y+1) ) >> 1;
                  if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x+1,y-1), get_pixel_DPC(x-1,y+1), pix_corrected, pix_corrected>>2 );
                  end
        end

      if(pattern==102)
        begin
         if(FirstCol==1 || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
        else
          if(FirstLine==1 ) begin
            pix_corrected  = get_pixel_DPC(x,y+1);
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else
            if(LastLine==1 ) begin
              pix_corrected  = get_pixel_DPC(x,y-1);
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else begin
              pix_corrected  = ( get_pixel_DPC(x-1,y+1) + get_pixel_DPC(x,y+1) + get_pixel_DPC(x+1,y-1) + get_pixel_DPC(x,y-1) ) >> 2;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y+1), get_pixel_DPC(x,y+1), get_pixel_DPC(x+1,y-1), get_pixel_DPC(x,y-1), pix_corrected, pix_corrected>>2 );
              end
        end

      if(pattern==85)
        begin
          if(FirstCol==1 || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
          else
            if(FirstLine==1 || LastLine==1 ) begin
              pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y) , get_pixel_DPC(x+1,y), pix_corrected, pix_corrected>>2 );

              end
            else begin
              pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x-1,y) + get_pixel_DPC(x,y+1) + get_pixel_DPC(x+1,y) ) >> 2;
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x-1,y), get_pixel_DPC(x,y+1), get_pixel_DPC(x+1,y), pix_corrected, pix_corrected>>2 );
              end
        end


      if(pattern==204)
        begin
          if(FirstCol==1 || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
          else
            if(FirstLine==1 ) begin
              pix_corrected  = get_pixel_DPC(x,y+1);
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(LastLine==1 ) begin
                pix_corrected  = get_pixel_DPC(x,y-1);
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else begin
                pix_corrected  = ( get_pixel_DPC(x-1,y-1) + get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) + get_pixel_DPC(x+1,y+1) ) >> 2;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y-1), get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), get_pixel_DPC(x+1,y+1), pix_corrected, pix_corrected>>2 );
                end
        end

      if(pattern==238)  //6 to 4 conversion
        begin
          if(FirstCol==1 || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
          else
            if(FirstLine==1 ) begin
              pix_corrected  = get_pixel_DPC(x,y+1);
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else
              if(LastLine==1 ) begin
                pix_corrected  = get_pixel_DPC(x,y-1);
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ",  HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
                end
              else  begin
                pix_corrected  = ( get_pixel_DPC(x-1,y-1) + get_pixel_DPC(x+1,y-1) + get_pixel_DPC(x-1,y+1) + get_pixel_DPC(x+1,y+1) ) >> 2;
                if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d)/4=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x-1,y-1), get_pixel_DPC(x+1,y-1), get_pixel_DPC(x-1,y+1), get_pixel_DPC(x+1,y+1), pix_corrected, pix_corrected>>2 );
                end
        end

      if(pattern==255)
        begin
         if(FirstCol==1 || LastCol==1) begin
            pix_corrected  = ( get_pixel_DPC(x,y-1) + get_pixel_DPC(x,y+1) ) >> 1 ;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstCol=%0d, lastCol=%0d (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, FirstCol, LastCol, x, y, pattern, get_pixel_DPC(x,y-1), get_pixel_DPC(x,y+1), pix_corrected, pix_corrected>>2 );
            end
        else
          if(FirstLine==1 || LastLine==1 ) begin
            pix_corrected  = ( get_pixel_DPC(x-1,y) + get_pixel_DPC(x+1,y) ) >> 1;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for firstLine/lastline (x=%0d, y=%0d, Pat=%0d) is %0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
          else begin
            pix_corrected  = ( get_pixel_DPC(x+1,y) + get_pixel_DPC(x+1,y-1) + get_pixel_DPC(x,y-1) + get_pixel_DPC(x-1,y-1) +
                               get_pixel_DPC(x-1,y) + get_pixel_DPC(x-1,y+1) + get_pixel_DPC(x,y+1) + get_pixel_DPC(x+1,y+1)     ) >> 3;
            if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d+%0d+%0d+%0d+%0d+%0d+%0d)/8=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern,
                                                                                                          get_pixel_DPC(x+1,y+1), get_pixel_DPC(x+1,y-1), get_pixel_DPC(x,y-1), get_pixel_DPC(x-1,y-1),
                                                                                                          get_pixel_DPC(x-1,y)  , get_pixel_DPC(x-1,y+1), get_pixel_DPC(x,y+1), get_pixel_DPC(x+1,y+1),
                                                                                                          pix_corrected, pix_corrected>>2 );
          end
        end

    endtask : correct_pixel



    // TEMPoraire color on 2LSB mono pipeline
    function void mono_2_color_patch();
        int new_size_x ;
        // determiner la nouvelle dimension, 2 ok 6 skip
        new_size_x = pgm_size_x/4;
        //take 2 skip 6
        for(int y = 0; y < pgm_size_y; y += 1)
            for(int x = 0; x < new_size_x; x += 2) begin

                image[y * new_size_x + x]     = get_pixel(x*4,     y);
                image[y * new_size_x + x + 1] = get_pixel((x*4)+1, y);
            end
        // replacer dans l'image
        image = new[new_size_x*pgm_size_y](image); // ici il faut faire une reallocation reduite!
        pgm_size_x = new_size_x;
    endfunction : mono_2_color_patch



    // TEMPoraire color on 2LSB mono pipeline
    function void mono8_2_mono32();

        shortint image_new[];
        int new_size_x ;

        // determiner la nouvelle dimension, mono8 to mono32
        new_size_x = pgm_size_x*4;

        image_new = new[new_size_x * pgm_size_y];

        for(int y = 0; y < pgm_size_y; y += 1)
            for(int x = 0; x < pgm_size_x; x += 1) begin
                image_new[y * new_size_x + 4*x]     = get_pixel(x,y);
                image_new[y * new_size_x + 4*x + 1] = 0;
                image_new[y * new_size_x + 4*x + 2] = 0;
                image_new[y * new_size_x + 4*x + 3] = 0;
            end
        // replacer dans l'image
        image = new[new_size_x*pgm_size_y](image_new); // ici il faut faire une reallocation augmentee!
        pgm_size_x = new_size_x;

        image_new.delete;

    endfunction : mono8_2_mono32




    //---------------------------------------------------------------------------------------------------------------------
    //  This task correct dead pixel from one COLOR image stored in Class ---- to a new corrected image stored in DPC_grab_image Class.
    //---------------------------------------------------------------------------------------------------------------------
    task Correct_DeadPixelsColor(input int x_start, input int x_end, input int y_start, input int y_end, input int SUB_X, input int SUB_Y);

      int HeadID=0;

      shortint expected_data10=0;

      int Translated_ROIx;
      int Translated_ROIy;

      image_DPC = image;	// fera l'allocation automagiquement!, utilise par get_pixel_DPC pour aller chercher pixels ds image originale

      //$display("Correct_DeadPixels x_start=%0d, x_end=%0d, y_start=%0d, y_end=%0d", x_start, x_end, y_start, y_end);

      if(SUB_Y==1) //Si subsampling, il faut enlever 1 a y_end: la derniere ligne est forcement paire!
        y_end=y_end-1;
      if(SUB_X==1) //Si subsampling, il faut enlever 1 a x_end: la derniere ligne est forcement paire!
        x_end=x_end-1;

      for(int dpc=0; dpc < dpc_list_count; dpc+=1)
      begin
        //$display("Correct_DeadPixels loop %0d/%0d, dpc_firstlast_line_rem=%0d dpc_x=%0d dpc_y=%0d", dpc, dpc_list_count, dpc_firstlast_line_rem, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y );
        if ( dpc_list[dpc].dpc_x >= x_start &&  dpc_list[dpc].dpc_x <= x_end &&  dpc_list[dpc].dpc_y >= y_start &&  dpc_list[dpc].dpc_y <= y_end )
          begin
            if( (SUB_Y==0 || (SUB_Y==1 && dpc_list[dpc].dpc_y%2==0))  && (SUB_X==0 || (SUB_X==1 && dpc_list[dpc].dpc_x%2==0))  ) begin
              Translated_ROIx = (dpc_list[dpc].dpc_x - x_start)/(SUB_X+1);
              Translated_ROIy = (dpc_list[dpc].dpc_y - y_start)/(SUB_Y+1);

              correct_pixelColor(Translated_ROIx, Translated_ROIy, dpc_list[dpc].dpc_pat, dpc_pattern_0_cfg, expected_data10);   // Correct rest of image

              $display("HeadID %0d, Correct_DeadPixels: x=%0d, y=%0d Expected=%0d", HeadID, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y, expected_data10);

              set_pixel(Translated_ROIx, Translated_ROIy, expected_data10);
            end else
              begin
                $display("HeadID %0d, Correct_DeadPixels: Pixel x=%0d, y=%0d not corrected because Subsampling Y applied", HeadID, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y);
              end
          end
        else begin
            $display("HeadID %0d, Correct_DeadPixels: Pixel x=%0d, y=%0d not corrected because out of ROI", HeadID, dpc_list[dpc].dpc_x, dpc_list[dpc].dpc_y);
        end
      end

    endtask : Correct_DeadPixelsColor

    //----------------------------------------------------------------------------------------
    //  This task takes a x,y and pattern, pixel and returns a corrected pixel from the image
    //----------------------------------------------------------------------------------------
    task correct_pixelColor(input int x, input int y, input int pattern, input int reg_dcp_pattern0_cfg, output shortint pix_corrected);
      //temp
      int HeadID=0;
      int printinfo=1;

      //if(printinfo==1) $display("Correct_pixel : x=%0d y=%0d pattern=%0d reg_dcp_pattern0_cfg=%0d FirstCol=%0d LastCol=%0d FirstLine=%0d LastLine=%0d ", x,  y,  pattern,  reg_dcp_pattern0_cfg,  FirstCol, LastCol, FirstLine,  LastLine);

      if(pattern==0)
        begin
            if(reg_dcp_pattern0_cfg==1) begin
              pix_corrected  = 1023;
              if(printinfo==1) if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for DEBUG pixel(x=%0d, y=%0d, Pat=%0d) is : %0d bpp10, %0d bpp8", HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
              end
            else begin
              pix_corrected  = get_pixel_DPC(x,y);
              if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for DEBUG pixel(x=%0d, y=%0d, Pat=%0d) is current pixel bypass: %0d bpp10, %0d bpp8", HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
            end
        end

      if(pattern==1)
        begin
          pix_corrected  = ( get_pixel_DPC(x-2,y) );
          if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) (-2 Left pixel) is %0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
        end

      if(pattern==16)
        begin
          pix_corrected  = ( get_pixel_DPC(x+2,y) );
          if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) (+2 Right pixel) is %0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, pix_corrected, pix_corrected>>2 );
        end

      if(pattern==17)
        begin
          pix_corrected  = ( get_pixel_DPC(x+2,y) + get_pixel_DPC(x-2,y))>>1 ;
          if(printinfo==1) $display("HeadID %0d, DPC SystemVerilog prediction for (x=%0d, y=%0d, Pat=%0d) is (%0d+%0d)/2=%0d bpp10, %0d bpp8 ", HeadID, x, y, pattern, get_pixel_DPC(x+2,y), get_pixel_DPC(x-2,y), pix_corrected, pix_corrected>>2 );
        end

    endtask : correct_pixelColor


    // Bayer demosaic
    function void BayerDemosaic();

        shortint image_new[];
        int new_size_x ;

        // determiner la nouvelle dimension, Mono8 to RGB32 (Bytes)
        new_size_x = pgm_size_x*4;

        image_new = new[new_size_x * pgm_size_y];

        for(int y = 0; y < pgm_size_y; y += 1) begin
            for(int x = 0; x < pgm_size_x-1; x += 1) begin                                             //Last pixel of the line is repeated by bayer (mirror)
                if(y%2==0) begin                                                                       //EVEN LINE
                  if(x%2==0) begin
                    image_new[y * new_size_x + 4*x]     = get_pixel(x+1, y+1);                         //B
                    image_new[y * new_size_x + 4*x + 1] = (get_pixel(x+1, y) + get_pixel(x, y+1))>>1;  //G
                    image_new[y * new_size_x + 4*x + 2] = get_pixel(x, y);                             //R
                    image_new[y * new_size_x + 4*x + 3] = 0;
                  end else begin
                    image_new[y * new_size_x + 4*x]     = get_pixel(x, y+1);                           //B
                    image_new[y * new_size_x + 4*x + 1] = (get_pixel(x, y) + get_pixel(x+1, y+1))>>1;  //G
                    image_new[y * new_size_x + 4*x + 2] = get_pixel(x+1, y);                           //R
                    image_new[y * new_size_x + 4*x + 3] = 0;
                  end
                end else begin                                                                         //ODD LINE
                  if(x%2==0) begin
                    image_new[y * new_size_x + 4*x]     = get_pixel(x+1, y);                           //B
                    image_new[y * new_size_x + 4*x + 1] = (get_pixel(x, y) + get_pixel(x+1, y+1))>>1;  //G
                    image_new[y * new_size_x + 4*x + 2] = get_pixel(x, y+1);                           //R
                    image_new[y * new_size_x + 4*x + 3] = 0;
                  end else begin
                    image_new[y * new_size_x + 4*x]     = get_pixel(x, y);                             //B
                    image_new[y * new_size_x + 4*x + 1] = (get_pixel(x+1, y) + get_pixel(x, y+1))>>1;  //G
                    image_new[y * new_size_x + 4*x + 2] = get_pixel(x+1, y+1);                         //R
                    image_new[y * new_size_x + 4*x + 3] = 0;
                  end
                end
            end

            // Last pixel of the line is repeated by bayer (mirror)
            image_new[y * new_size_x + new_size_x-4 ] = image_new[y * new_size_x + new_size_x-8];
            image_new[y * new_size_x + new_size_x-3 ] = image_new[y * new_size_x + new_size_x-7];
            image_new[y * new_size_x + new_size_x-2 ] = image_new[y * new_size_x + new_size_x-6];
            image_new[y * new_size_x + new_size_x-1 ] = image_new[y * new_size_x + new_size_x-5];

        end //Y

        // replacer dans l'image
        image = new[new_size_x*pgm_size_y](image_new); // ici il faut faire une reallocation augmentee!
        pgm_size_x = new_size_x;

        image_new.delete;

    endfunction : BayerDemosaic


    // Bayer2yuv conversion
    function void Bayer2YUV();

	      // Y Coefficients
        shortint CYr    =	 77;
	      shortint CYg    =	 150;
	      shortint CYb    =	 29;
	      // U Coefficients
	      shortint CUr    = 43;
	      shortint CUg    = 85; 
	      shortint CUb    = 128;
	      // V Coefficients
	      shortint CVr    = 128;
	      shortint CVg    = 107;
	      shortint CVb    = 21 ;
        
        // pixels from RGB32
        shortint B0 ;
        shortint G0 ;
        shortint R0 ;
        shortint B1 ;
        shortint G1 ;
        shortint R1 ;

        // RGB to YUV
        for(int y = 0; y < pgm_size_y; y += 1) begin
            for(int x = 0; x < pgm_size_x-1; x += 8) begin  //jump 2 pixels rgb32   
                B0 = get_pixel(x,   y);
                G0 = get_pixel(x+1, y);
                R0 = get_pixel(x+2, y);

                B1 = get_pixel(x+4, y);
                G1 = get_pixel(x+5, y);
                R1 = get_pixel(x+6, y);

                image[y * pgm_size_x + x + 0] = ((CYr * R0) + (CYg * G0) + (CYb * B0))>>8;                // Y0 = (CYr x R0) + (CYg x G0) + (CYb x B0)
                image[y * pgm_size_x + x + 1] = (-(CUr * R0) - (CUg * G0) + (CUb * B0) + (128<<8))>>8;    // U0 = - (CUr x R0) - (CUg x G0) + (CUb x B0) + 128
                image[y * pgm_size_x + x + 2] = 0;                                                        // 0  
                image[y * pgm_size_x + x + 3] = 0;                                                        // 0
     
                image[y * pgm_size_x + x + 4] = ((CYr * R1) + (CYg * G1) + (CYb * B1))>>8;                // Y1 = (CYr x R1) + (CYg x G1) + (CYb x B1)
                image[y * pgm_size_x + x + 5] = ((CVr * R0) - (CVg * G0) - (CVb * B0) + (128<<8))>>8;     // V0 = (CVr x R0) - (CVg x G0) - (CVb x B0) + 128 
                image[y * pgm_size_x + x + 6] = 0;                                                        // 0  
                image[y * pgm_size_x + x + 7] = 0;                                                        // 0                   
             end  // X
        end // Y
    endfunction : Bayer2YUV



endclass :  CImage
