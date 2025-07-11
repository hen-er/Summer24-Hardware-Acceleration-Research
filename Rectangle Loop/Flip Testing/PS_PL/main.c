
#define __MICROBLAZE__ 

#include "xparameters.h"
#include <stdio.h>
#include <stdlib.h>
#include "xil_types.h"
#include <sys/_intsup.h>
#include <xgpio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xstatus.h"
#include "xuartlite.h"

/* Constant Definitions */
#define XPAR_AXI_UARTLITE_0_DEVICE_ID 0
#define UARTLITE_DEVICE_ID  XPAR_AXI_UARTLITE_0_DEVICE_ID



/*Function Prototypes*/
int UARTLite_Init_SelfTest(u16 DeviceID);


/* Variable Definitions */
XUartLite UartLite0; // instance of AXI UARTlite core
XGpio GpioToPC; //input to modue
XGpio GpioFromPC;


int main() {
    init_platform();

    print("DEBUG: initialized platform\r\n");

    /*
    variable declarations
    */
    int Status; //for status checks on uart and gpios
    
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

    Status = XGpio_Initialize(&GpioToPC, XPAR_AXI_GPIO_0_BASEADDR);
    if (Status != XST_SUCCESS) {
        xil_printf("GPIO Initialization Failed\r\n");
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(&GpioToPC, 1, 0); //operating on channel 1, direction mask 0 indicates output

    Status = XGpio_Initialize(&GpioFromPC, XPAR_AXI_GPIO_0_BASEADDR);
    if (Status != XST_SUCCESS) {
        xil_printf("GPIO Initialization Failed\r\n");
        return XST_FAILURE;
    }

    XGpio_SetDataDirection(&GpioFromPC, 2, 1); //operating on channel 2, direction mask 1 indicates input

    print("DEBUG: in main. Peripherals ready.");

    /*while (1) {
        numBytes = XUartLite_Recv(&UartLite0, &input, 1);
        if (numBytes > 0){
            XGpio_DiscreteWrite(&GpioToPC, 1, input);
            xil_printf("DEBUG: Received data: %0x\r\n", input);
        }
    }*/

    while (1) {
        // 4) Receive 2 bytes from UART
        u8 buf[2];
        int bytes = 0;
        while (bytes < 2) {
            bytes += XUartLite_Recv(&UartLite0, buf + bytes, 2 - bytes);
        }

        // Pack into 16-bit little-endian
        u16 cmd = (buf[1] << 8) | buf[0];
        xil_printf("CPU → FPGA: 0x%04X\r\n", cmd);

        // 5) Drive the 'from_pc' GPIO
        XGpio_DiscreteWrite(&GpioToPC, 1, cmd);

        xil_printf("Toggle 'start' switch now...\r\n");

        // 6) Wait a short while for FPGA to process
        //    (your design sees the switch and pulses start_p internally)
        for (volatile int i = 0; i < 1000000; i++);

        // 7) Read back the result
        u16 result = (u16)XGpio_DiscreteRead(&GpioFromPC, 2);
        xil_printf("FPGA → CPU: 0x%04X\r\n\n", result);
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
