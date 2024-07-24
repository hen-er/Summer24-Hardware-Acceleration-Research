
/*
# TEST application for a PL to PS interconnect
 */

#include <stdio.h>
#include "platform.h"
#include "xgpio.h"
#include "xparameters.h"
#include "xil_printf.h"




int main()
{
    init_platform();

    XGpio input, output;
    int a; //input to NOT gate
    int y; //output of NOT gate

        
XGpio_Initialize(&input, XPAR_AXI_GPIO_0_BASEADDR);
XGpio_Initialize(&output, XPAR_AXI_GPIO_1_BASEADDR);

//code
//for direction mask, 1 means input and 0 means output
XGpio_SetDataDirection(&input, 1, 1);
XGpio_SetDataDirection(&output, 1, 0);

print("DEBUG: code is running");

while(1){
    a = XGpio_DiscreteRead(&input, 1);

    if ( a == 1){
        y = 0;
    }
    else y = 1;

    XGpio_DiscreteWrite(&output, 1, y);

}

    cleanup_platform();
    return 0;
}
