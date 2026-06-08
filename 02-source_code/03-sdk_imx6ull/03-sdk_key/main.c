#include "imx6ul.h"
#include "bsp_clk.h"
#include "bsp_beep.h"
#include "bsp_led.h"
#include "bsp_gpio.h"
#include "bsp_key.h"


/* @description	: main函数
 * @param 		: 无
 * @return 		: 无
 */
int main(void)
{
	int i = 0;
	int keyvalue = 0;
	unsigned char led_state = OFF;

	imx6u_clkinit();	/* 初始化系统时钟 			*/
	clk_enable();		/* 使能所有的时钟 			*/
	led_init();			/* 初始化led 			*/
	beep_init();		/* 初始化beep	 		*/
	key_init();			/* 初始化key 			*/

	// beep_switch(ON);
	delay(500);
	beep_switch(OFF);

	while(1)			
	{	
		keyvalue = key_getvalue();
		if(keyvalue)
		{
			switch ((keyvalue))
			{
				case KEY0_VALUE:
					beep_switch(ON);
					break;
			}
		} else {
			beep_switch(OFF);
		}

		i++;
		if(i==50)
		{
			i = 0;
			led_state = !led_state;
			led_switch(LED0, led_state);
		}
		delay(20);
	}

	return 0;
}
