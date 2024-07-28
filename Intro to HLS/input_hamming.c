/******************************************************************************

input_hamming: simple application layer meant to input correctly formatted data to
hamming top module.


The "xgpio.h" file throws error: "In included file: 'xpseudo_asm.h' file not found."
However, that xpseudo_asm.h specific file is useless and so the compiler just ignores the error 
and the application synthesizes fine.

Notes: This program essentially takes a single input from the keyboard and essentially uses the ASCII as input to the hamming module.
This input is then encoded and decoded by the module and the output is shown in the form of LEDs that reflect the 3rd, 5th, 6th, and 7th binary
digits of the ASCII.

*/

#include <stdio.h>
#include <stdlib.h>
#include "xil_types.h"
#include <sys/_intsup.h>
#include <xgpio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xuartlite.h"

/* Constant Definitions */
#define XPAR_AXI_UARTLITE_0_DEVICE_ID 0
#define UARTLITE_DEVICE_ID  XPAR_AXI_UARTLITE_0_DEVICE_ID


/*Function Prototypes*/
int UARTLite_Init_SelfTest(u16 DeviceID);


/* Variable Definitions */
XUartLite UartLite0; // instance of AXI UARTlite core
XGpio output; //output of the processor, input to the hamming module


int main() {
    init_platform();

    print("DEBUG: initialized platform\r\n");

    /*
    variable declarations
    */
    int Status; //for status checks on uart and gpio
    int numBytes; //for data reception from UART;
    u8 input; //buffer for data received from terminal, input to the processor

    /*
    running some checks on the UART i/f
    perform initialization and tests
    */
    Status = UARTLite_Init_SelfTest(UARTLITE_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        print("failed to initalize\r\n");
    }

    /*
    manually reseting FIFOs since it doesn't automatically do that
    */
    XUartLite_ResetFifos(&UartLite0); 

    /*
    initialize gpio instance for output
    */

    Status = XGpio_Initialize(&output, XPAR_AXI_GPIO_0_BASEADDR);
    if (Status != XST_SUCCESS) {
        xil_printf("GPIO Initialization Failed\r\n");
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(&output, 1, 0); //indicate it as output

    print("DEBUG: in main");

    while (1) {
        numBytes = XUartLite_Recv(&UartLite0, &input, 1);
        if (numBytes > 0){
            XGpio_DiscreteWrite(&output, 1, input);
            xil_printf("DEBUG: Received data: %0x\r\n", input);
        }
    }


    cleanup_platform();
    return 0;
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
