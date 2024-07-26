/******************************************************************************

<name_of_application>: simple application layer meant to input correctly formatted data to
hamming top module.


The "xgpio.h" file throws error: "In included file: 'xpseudo_asm.h' file not found."
However, that xpseudo_asm.h specific file is useless and so the compiler just ignores the error 
and the application synthesizes fine.

 */

#include <stdio.h>
//#include <stdlib.h>
#include "xil_types.h"
#include <sys/_intsup.h>
#include "platform.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xuartlite.h"
//#include "xgpio.h" 

/* Constant Definitions */
#define XPAR_AXI_UARTLITE_0_DEVICE_ID 0
#define UARTLITE_DEVICE_ID  XPAR_AXI_UARTLITE_0_DEVICE_ID


/*Function Prototypes*/
int UARTLite_Init_SelfTest(u16 DeviceID);

void UARTlite_Test_0(XUartLite *InstancePTR);


/* Variable Definitions */
XUartLite UartLite0; // instance of AXI UARTlite core
XUartLite_Config *UartLite0_Config;

unsigned int TO_RECEIVE = 32;
 /*
Step 1: test whether I am recieving data through the terminal
    - I will check this by testing the XUartLite_Recv function and displaying the result to the terminal using the print function
Step2: depenfing on (a) whether I am recieving data and (b) HOW I am recieving that data, intercept the communication by
storcing the recieved data in a buffer and sending it as an output through the gpio to the module.
*/
int main() {
    init_platform();

    /*
    running some checks on the UART i/f
    */
    int Status;
  
    // perform initialization and tests
    Status = UARTLite_Init_SelfTest(UARTLITE_DEVICE_ID);
    if (Status != XST_SUCCESS)
        {
            print("failed to initalize");
        }


    /*
    manually reseting FIFOs since it doesn't automatically do that
    */
    XUartLite_ResetFifos(&UartLite0); 

    UARTlite_Test_0(&UartLite0);    

    cleanup_platform();
    return 0;
}

/*****************************************************************************/
/**
*
* Description: Receives 32 bytes of data and stores it in a buffer before transmitting the received data back to the terminal. 
*
*
* Arguments: InstancePTR is a pointer to an instance of XUartLite (the AXI UARTlite core)
*
*
* Returns: Void
*
*
* Notes:
*
******************************************************************************/

void UARTlite_Test_0(XUartLite *InstancePTR){
    print("in test 0");
    unsigned int BytesReceived = 0;//counter for each byte we successfully retreat over the interface
    unsigned int totalBytes = 0;//total bytes we receive

    unsigned int BytesTransmitted = 0;
    unsigned int totalBytesTransmitted = 0;

    u8 data_received[TO_RECEIVE];//buffer for the data
    //data_received = malloc(sizeof(u8*) * 8);

    //cout till i receive 32B of data
    while (totalBytes < TO_RECEIVE) {
        
        BytesReceived = XUartLite_Recv(InstancePTR, &data_received[totalBytes], 32); //since this is  non-blocking, it doesn't wait to receive 32B of data thus putting 32B there doesn't matter much
        //xil_printf("%0x", data_received[totalBytes]);//another check

        totalBytes += BytesReceived;

        if (totalBytes == 10) xil_printf("DEBUG: in while first loop, total bytes exceeded 10");

    }

    while (totalBytesTransmitted < TO_RECEIVE) {

        BytesTransmitted = XUartLite_Send(InstancePTR, &data_received[totalBytesTransmitted], 32);
        totalBytesTransmitted += BytesTransmitted;

        if (totalBytesTransmitted == 10) xil_printf("DEBUG: in while second loop, total bytese xceeded 10");

    }

    xil_printf("DEBUT: finished loops. exiting test0");

}

/*****************************************************************************/
/**
*
* Description: Initializes UART Lite and does a self test
*
*
* Arguments: DeviceID is the DeviceId is the Device ID of the UartLite and is the
*		         XPAR_<uartlite_instance>_DEVICE_ID value from xparameters.h.
*
*
* Returns: XST_SUCCESS if successful, otherwise XST_FAILURE.
*
*
* Notes: 		
*
******************************************************************************/
int UARTLite_Init_SelfTest(u16 DeviceID)
{
  int Status;
  
  // perform initialization tests
  Status = XUartLite_Initialize(&UartLite0, DeviceID);
  if (Status != XST_SUCCESS)
  {
    return XST_FAILURE;
  }

  // perform self-test tests
  Status = XUartLite_SelfTest(&UartLite0);
  if (Status != XST_SUCCESS)
  {
    return XST_FAILURE;
  }

  return XST_SUCCESS;
}