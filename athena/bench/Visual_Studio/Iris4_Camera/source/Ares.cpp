//
//

#define _CRT_SECURE_NO_DEPRECATE

#include "osincludes.h"

#include <string>
using std::string;

#include "Ares.h"

#include "mtxservmanager.h"

#include <iostream>

#include <algorithm>
#include <vector>
using namespace std;




CAres::CAres(volatile FPGA_REGFILE_ARES_TYPE& i_rAres, int AresDetected) :
    rAres_ptr(i_rAres)
{
    //if (AresDetected == 1) {
    //    memset(&sAres_ptr, 0, sizeof(sAres_ptr));
    //    memcpy(&sAres_ptr, (const void*)&rAres_ptr, sizeof(sAres_ptr));
    //}
    

}


CAres::~CAres()
{  

}


M_UINT32 CAres::Read_QSPI_ID(void)
{

    M_UINT32 qspiID   = 0;
    M_UINT32 qspiManu = 0;

 
    //---------------------------------
    // SPI READ IDENTIFICATION ID Jedec command 0x9f
    //---------------------------------
    rAres_ptr.spi.spiregin.f.spi_enable = 0x1;
    rAres_ptr.spi.spiregin.f.spidataw   = 0x9f;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spirw      = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    // byte 0 : manufacturer identification
    rAres_ptr.spi.spiregin.f.spidataw   = 0x0;
    rAres_ptr.spi.spiregin.f.spirw      = 0x1;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
    printf_s("\n\nQSPI Manufacturer ID is 0x%X  ", rAres_ptr.spi.spiregout.f.spidatard);
    qspiManu = rAres_ptr.spi.spiregout.f.spidatard;
    
    if (qspiManu == 0xd5 || qspiManu == 0x90 || qspiManu == 0x9D) printf_s("Flash SPI is ISSI\n");   
    else if (qspiManu == 0xc2) printf_s("Flash SPI is MACRONIX\n");    
    else if (qspiManu == 0x01) printf_s("Flash SPI is SPANSION\n");   
    else if (qspiManu == 0xef) printf_s("Flash SPI is WINDBOND\n");    
    else if (qspiManu == 0xC8) printf_s("Flash SPI is GIGADEVICE\n");
    else { printf_s("\n"); }

    qspiID = 0;

    // byte 1 : device identification
    rAres_ptr.spi.spiregin.f.spidataw   = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spirw      = 0x1;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
    printf_s("QSPI Device ID is 0x%X\n", rAres_ptr.spi.spiregout.f.spidatard);
    qspiID = qspiID + (rAres_ptr.spi.spiregout.f.spidatard << 8);

    // byte 2 : memory capacity
    rAres_ptr.spi.spiregin.f.spidataw   = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x1;
    rAres_ptr.spi.spiregin.f.spirw      = 0x1;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
    printf_s("QSPI Memory Capacity is 0x%X\n\n", rAres_ptr.spi.spiregout.f.spidatard);
    qspiID = qspiID + (rAres_ptr.spi.spiregout.f.spidatard & 0xff);

    if (qspiManu == 0xc2 && qspiID == 0x2537) printf_s("SPI device is MX25U6435E\n\n");
    if ((qspiManu == 0xd5 || qspiManu == 0x90 || qspiManu == 0x9D) && (qspiID == 0x7017)) printf_s("SPI device is IS25WP064\n\n");    
    if (qspiManu == 0xC8 && qspiID == 0x6017) printf_s("SPI device is GD25LB64\n\n");
    if(qspiManu == 0xef && qspiID == 0x6017) printf_s("SPI device is W25Q64\n\n");

    //SPI disable
    rAres_ptr.spi.spiregin.f.spi_enable = 0x0;
    rAres_ptr.spi.spiregin.f.spidataw   = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spirw      = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x0;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    return(qspiID);


}



M_UINT32 CAres::Read_QSPI_DW(M_UINT32 address)
{

    M_UINT32 read32 = 0;
    //---------------------------------
    //  Normal Read Sequence (03h)
    //---------------------------------
    
    // Instruction 
    rAres_ptr.spi.spiregin.f.spi_enable = 0x1;
    rAres_ptr.spi.spiregin.f.spidataw   = 0x03;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spirw      = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    // byte 0 : Add MSB
    rAres_ptr.spi.spiregin.f.spidataw   = (address>>16) & 0xff;
    rAres_ptr.spi.spiregin.f.spirw      = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
 

    // byte 1 : Add MID
    rAres_ptr.spi.spiregin.f.spidataw   = (address >> 8) & 0xff;
    rAres_ptr.spi.spiregin.f.spirw      = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    // byte 2 : Add LSB
    rAres_ptr.spi.spiregin.f.spidataw   = (address >> 0) & 0xff;
    rAres_ptr.spi.spiregin.f.spirw      = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    //read 4 bytes mem
    for (int i = 0; i < 3; i++) {
        rAres_ptr.spi.spiregin.f.spidataw   = 0x0;
        rAres_ptr.spi.spiregin.f.spisel     = 0x0;
        rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
        rAres_ptr.spi.spiregin.f.spirw      = 0x1;
        rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
        while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
        read32 = read32 + ( rAres_ptr.spi.spiregout.f.spidatard << (i*8) );
    }
    for (int i = 3; i < 4; i++) {
        rAres_ptr.spi.spiregin.f.spidataw   = 0x0;
        rAres_ptr.spi.spiregin.f.spisel     = 0x0;
        rAres_ptr.spi.spiregin.f.spicmddone = 0x1;
        rAres_ptr.spi.spiregin.f.spirw      = 0x1;
        rAres_ptr.spi.spiregin.f.spitxst    = 0x1;
        while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
        read32 = read32 + (rAres_ptr.spi.spiregout.f.spidatard << (i * 8));
    }


    //SPI disable
    rAres_ptr.spi.spiregin.f.spi_enable = 0x0;
    rAres_ptr.spi.spiregin.f.spidataw   = 0x0;
    rAres_ptr.spi.spiregin.f.spisel     = 0x0;
    rAres_ptr.spi.spiregin.f.spicmddone = 0x0;
    rAres_ptr.spi.spiregin.f.spirw      = 0x0;
    rAres_ptr.spi.spiregin.f.spitxst    = 0x0;
    while ((rAres_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    return(read32);
    }




//-----------------------
// test general arbiter
//-----------------------
void CAres::ArbiterTest(void)
{
    if (rAres_ptr.arbiter.arbiter_capabilities.f.tag == 0xAAB) {
        // REQ0 -> DONE0
        rAres_ptr.arbiter.agent[0].f.req = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 1) printf_s("Arbiter ERROR: ACK_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        rAres_ptr.arbiter.agent[0].f.done = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");

        // REQ1 -> DONE1
        rAres_ptr.arbiter.agent[1].f.req = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 1) printf_s("Arbiter ERROR: ACK_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        rAres_ptr.arbiter.agent[1].f.done = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");

        //REQ0->REQ1->DONE0 ->DONE1
        rAres_ptr.arbiter.agent[0].f.req = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 1) printf_s("Arbiter ERROR: ACK_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        rAres_ptr.arbiter.agent[1].f.req = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 1) printf_s("Arbiter ERROR: ACK_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        rAres_ptr.arbiter.agent[0].f.done = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 1) printf_s("Arbiter ERROR: ACK_1 dois etre a 1\n");
        rAres_ptr.arbiter.agent[1].f.done = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");

        //REQ0->REQ1->DONE1 ->DONE0 (cancel req1 during req0 )
        rAres_ptr.arbiter.agent[0].f.req = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 1) printf_s("Arbiter ERROR: ACK_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        rAres_ptr.arbiter.agent[1].f.req = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 1) printf_s("Arbiter ERROR: ACK_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        rAres_ptr.arbiter.agent[1].f.done = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 1) printf_s("Arbiter ERROR: ACK_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        rAres_ptr.arbiter.agent[0].f.done = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");

        //REQ1->REQ0->DONE1->DONE0
        rAres_ptr.arbiter.agent[1].f.req = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 1) printf_s("Arbiter ERROR: ACK_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        rAres_ptr.arbiter.agent[0].f.req = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 1) printf_s("Arbiter ERROR: ACK_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        rAres_ptr.arbiter.agent[1].f.done = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 1) printf_s("Arbiter ERROR: ACK_0 dois etre a 1\n");
        rAres_ptr.arbiter.agent[0].f.done = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");

        //REQ1->REQ0->DONE0->DONE1
        rAres_ptr.arbiter.agent[1].f.req = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 1) printf_s("Arbiter ERROR: ACK_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        rAres_ptr.arbiter.agent[0].f.req = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 1) printf_s("Arbiter ERROR: ACK_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 1) printf_s("Arbiter ERROR: REC_0 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        rAres_ptr.arbiter.agent[0].f.done = 1;
        if (rAres_ptr.arbiter.agent[1].f.rec != 1) printf_s("Arbiter ERROR: REC_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 1) printf_s("Arbiter ERROR: ACK_1 dois etre a 1\n");
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        rAres_ptr.arbiter.agent[1].f.done = 1;
        if (rAres_ptr.arbiter.agent[0].f.rec != 0) printf_s("Arbiter ERROR: REC_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[0].f.ack != 0) printf_s("Arbiter ERROR: ACK_0 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.rec != 0) printf_s("Arbiter ERROR: REC_1 dois etre a 0\n");
        if (rAres_ptr.arbiter.agent[1].f.ack != 0) printf_s("Arbiter ERROR: ACK_1 dois etre a 0\n");
    }
    else
      printf_s("No arbiter found in ARES fpga\n");
}
