//
//

#define _CRT_SECURE_NO_DEPRECATE

#include "osincludes.h"

#include <string>
using std::string;

#include "Pcie.h"

#include "mtxservmanager.h"

#include <iostream>

#include <algorithm>
#include <vector>
using namespace std;




CPcie::CPcie(volatile FPGA_REGFILE_PCIE2AXIMASTER_TYPE& i_rPcie):
	rPcie_ptr(i_rPcie)
{
	memset(&sPcie_ptr, 0, sizeof(sPcie_ptr));
	memcpy(&sPcie_ptr, (const void*)&rPcie_ptr, sizeof(sPcie_ptr));

}


CPcie::~CPcie()
{
    

}

void CPcie::InitBar0Window(void)
{
	//----------------------------------
	// Program Maio PCIe window 0 and 1
	//----------------------------------
	rPcie_ptr.axi_window[0].ctrl.f.enable       = 0;           //pci_bar0_disable           
	rPcie_ptr.axi_window[0].pci_bar0_start.u32  = 0;		   //pci_bar0_start
	rPcie_ptr.axi_window[0].pci_bar0_stop.u32   = 0xfff;	   //pci_bar0_End (4k)
	rPcie_ptr.axi_window[0].axi_translation.u32 = 0x40000000;  //pci_bar0_translation
	rPcie_ptr.axi_window[0].ctrl.f.enable       = 1;           //pci_bar0_enable

    rPcie_ptr.axi_window[1].ctrl.f.enable       = 0;           //pci_bar0_disable           
    rPcie_ptr.axi_window[1].pci_bar0_start.u32  = 0x1000;	   //pci_bar0_start
    rPcie_ptr.axi_window[1].pci_bar0_stop.u32   = 0x1fff;	   //pci_bar0_End (4k)
    rPcie_ptr.axi_window[1].axi_translation.u32 = 0x40010000;  //pci_bar0_translation
    rPcie_ptr.axi_window[1].ctrl.f.enable       = 1;           //pci_bar0_enable
    
    printf("\n");
    printf("Athena PCie Window[0] is range 0x%08X-0x%08X,  System translation 0x%08X\n", rPcie_ptr.axi_window[0].pci_bar0_start.u32, rPcie_ptr.axi_window[0].pci_bar0_stop.u32, rPcie_ptr.axi_window[0].axi_translation.u32);
    printf("Athena PCie Window[1] is range 0x%08X-0x%08X,  System translation 0x%08X\n", rPcie_ptr.axi_window[1].pci_bar0_start.u32, rPcie_ptr.axi_window[1].pci_bar0_stop.u32, rPcie_ptr.axi_window[1].axi_translation.u32);
}

M_UINT32 CPcie::Read_QSPI_ID(void)
{

    M_UINT32 qspiID   = 0;
    M_UINT32 qspiManu = 0;
    //---------------------------------
    // SPI READ IDENTIFICATION ID Jedec command 0x9f
    //---------------------------------
    rPcie_ptr.spi.spiregin.f.spi_enable = 0x1;
    rPcie_ptr.spi.spiregin.f.spidataw   = 0x9f;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    // byte 0 : manufacturer identification
    rPcie_ptr.spi.spiregin.f.spidataw   = 0x0;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x1;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
    printf("QSPI Manufacturer ID is 0x%X  ", rPcie_ptr.spi.spiregout.f.spidatard);
    qspiManu = rPcie_ptr.spi.spiregout.f.spidatard;
    
    if (qspiManu == 0xd5 || qspiManu == 0x90 || qspiManu == 0x9D) printf("Flash SPI is ISSI\n");   
    else if (qspiManu == 0xc2) printf("Flash SPI is MACRONIX\n");    
    else if (qspiManu == 0x01) printf("Flash SPI is SPANSION\n");   
    else if (qspiManu == 0xef) printf("Flash SPI is WINDBOND\n");    
    else if (qspiManu == 0xC8) printf("Flash SPI is GIGADEVICE\n");
    else { printf("\n"); }

    qspiID = 0;

    // byte 1 : device identification
    rPcie_ptr.spi.spiregin.f.spidataw   = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x1;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
    printf("QSPI Device ID is 0x%X\n", rPcie_ptr.spi.spiregout.f.spidatard);
    qspiID = qspiID + (rPcie_ptr.spi.spiregout.f.spidatard << 8);

    // byte 2 : memory capacity
    rPcie_ptr.spi.spiregin.f.spidataw   = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x1;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x1;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
    printf("QSPI Memory Capacity is 0x%X\n\n", rPcie_ptr.spi.spiregout.f.spidatard);
    qspiID = qspiID + (rPcie_ptr.spi.spiregout.f.spidatard & 0xff);

    if (qspiManu == 0xc2 && qspiID == 0x2537) printf("SPI device is MX25U6435E\n\n");
    if ((qspiManu == 0xd5 || qspiManu == 0x90 || qspiManu == 0x9D) && (qspiID == 0x7017)) printf("SPI device is IS25WP064\n\n");    
    if (qspiManu == 0xC8 && qspiID == 0x6017) printf("SPI device is GD25LB64\n\n");
    if(qspiManu == 0xef && qspiID == 0x6017) printf("SPI device is W25Q64\n\n");

    //SPI disable
    rPcie_ptr.spi.spiregin.f.spi_enable = 0x0;
    rPcie_ptr.spi.spiregin.f.spidataw   = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x0;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    return(qspiID);


}



M_UINT32 CPcie::Read_QSPI_DW(M_UINT32 address)
{

    M_UINT32 read32 = 0;
    //---------------------------------
    //  Normal Read Sequence (03h)
    //---------------------------------
    
    // Instruction 
    rPcie_ptr.spi.spiregin.f.spi_enable = 0x1;
    rPcie_ptr.spi.spiregin.f.spidataw   = 0x03;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    // byte 0 : Add MSB
    rPcie_ptr.spi.spiregin.f.spidataw   = (address>>16) & 0xff;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
 

    // byte 1 : Add MID
    rPcie_ptr.spi.spiregin.f.spidataw   = (address >> 8) & 0xff;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    // byte 2 : Add LSB
    rPcie_ptr.spi.spiregin.f.spidataw   = (address >> 0) & 0xff;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    //read 4 bytes mem
    for (int i = 0; i < 3; i++) {
        rPcie_ptr.spi.spiregin.f.spidataw   = 0x0;
        rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
        rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
        rPcie_ptr.spi.spiregin.f.spirw      = 0x1;
        rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
        while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
        read32 = read32 + ( rPcie_ptr.spi.spiregout.f.spidatard << (i*8) );
    }
    for (int i = 3; i < 4; i++) {
        rPcie_ptr.spi.spiregin.f.spidataw   = 0x0;
        rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
        rPcie_ptr.spi.spiregin.f.spicmddone = 0x1;
        rPcie_ptr.spi.spiregin.f.spirw      = 0x1;
        rPcie_ptr.spi.spiregin.f.spitxst    = 0x1;
        while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 
        read32 = read32 + (rPcie_ptr.spi.spiregout.f.spidatard << (i * 8));
    }


    //SPI disable
    rPcie_ptr.spi.spiregin.f.spi_enable = 0x0;
    rPcie_ptr.spi.spiregin.f.spidataw   = 0x0;
    rPcie_ptr.spi.spiregin.f.spisel     = 0x0;
    rPcie_ptr.spi.spiregin.f.spicmddone = 0x0;
    rPcie_ptr.spi.spiregin.f.spirw      = 0x0;
    rPcie_ptr.spi.spiregin.f.spitxst    = 0x0;
    while ((rPcie_ptr.spi.spiregout.u32 & 0x10000) != 0x10000);  //polling for SPIWRTD=1 

    return(read32);


}



//-----------------------
// test general arbiter
//-----------------------
void CPcie::ArbiterTest(void)
{
    // REQ0 -> DONE0
    rPcie_ptr.arbiter.agent[0].f.req = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 1) printf("Arbiter ERROR: ACK_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[0].f.done = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");

    // REQ1 -> DONE1
    rPcie_ptr.arbiter.agent[1].f.req = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 1) printf("Arbiter ERROR: ACK_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[1].f.done = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");

    //REQ0->REQ1->DONE0 ->DONE1
    rPcie_ptr.arbiter.agent[0].f.req = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 1) printf("Arbiter ERROR: ACK_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[1].f.req = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 1) printf("Arbiter ERROR: ACK_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[0].f.done = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 1) printf("Arbiter ERROR: ACK_1 dois etre a 1\n");
    rPcie_ptr.arbiter.agent[1].f.done = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");

    //REQ0->REQ1->DONE1 ->DONE0 (cancel req1 during req0 )
    rPcie_ptr.arbiter.agent[0].f.req = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 1) printf("Arbiter ERROR: ACK_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[1].f.req = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 1) printf("Arbiter ERROR: ACK_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[1].f.done = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 1) printf("Arbiter ERROR: ACK_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[0].f.done = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");

    //REQ1->REQ0->DONE1->DONE0
    rPcie_ptr.arbiter.agent[1].f.req = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 1) printf("Arbiter ERROR: ACK_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[0].f.req = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 1) printf("Arbiter ERROR: ACK_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[1].f.done = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 1) printf("Arbiter ERROR: ACK_0 dois etre a 1\n");
    rPcie_ptr.arbiter.agent[0].f.done = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");

    //REQ1->REQ0->DONE0->DONE1
    rPcie_ptr.arbiter.agent[1].f.req = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 1) printf("Arbiter ERROR: ACK_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[0].f.req = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 1) printf("Arbiter ERROR: ACK_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 1) printf("Arbiter ERROR: REC_0 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[0].f.done = 1;
    if (rPcie_ptr.arbiter.agent[1].f.rec != 1) printf("Arbiter ERROR: REC_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 1) printf("Arbiter ERROR: ACK_1 dois etre a 1\n");
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    rPcie_ptr.arbiter.agent[1].f.done = 1;
    if (rPcie_ptr.arbiter.agent[0].f.rec != 0) printf("Arbiter ERROR: REC_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[0].f.ack != 0) printf("Arbiter ERROR: ACK_0 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.rec != 0) printf("Arbiter ERROR: REC_1 dois etre a 0\n");
    if (rPcie_ptr.arbiter.agent[1].f.ack != 0) printf("Arbiter ERROR: ACK_1 dois etre a 0\n");

}
