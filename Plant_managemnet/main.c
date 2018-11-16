/*
 * Term_project.c
 *
 * Created: 2017-12-10 오후 1:00:19
 * Author : USER
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdio.h>
#define F_CPU 16000000UL // 16 MHz
#include <util/delay.h>

// motor
#define MOTOR_CW	0x80  // front
#define MOTOR_CCW	0x40  // back
#define MOTOR_STOP1	0x00  // front stop
#define MOTOR_STOP2	0xC0  // back stop

#define CDS_1	   93   // 200/(2000+200) * 1024, 1 lux  = 2000K
#define CDS_5	  482
#define CDS_10	  871   // 200/(35+200) * 1024,   10 lux  = 35K
#define CDS_30    900
#define CDS_50    930
#define CDS_80    960
#define CDS_100   989   // 200/(7+200) * 1024,    100 lux  = 7K

unsigned char digit[11] = {0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7c, 0x07, 0x7f, 0x67, 0x00}; // port G value
unsigned char fnd_sel[4] = {0x01, 0x02, 0x04, 0x08};

#define AM2302_IN    (PINE & (1 << 3)) // PE3
#define AM2302_OUT_1 DDRE |= (1 << 3)  // PE3
#define AM2302_OUT_0 DDRE &= ~(1 << 3) // PE3

unsigned int  half_usec, Temperiture, Humidity;
unsigned char data[5],Temp_sign;

static int putchar0(char c, FILE *stream);	// 1 char Transmit
static FILE mystdout = FDEV_SETUP_STREAM(putchar0, NULL, _FDEV_SETUP_WRITE);

unsigned short read_adc();
void show_adc(unsigned short value);

int adc_state = 0; // swich2 pushed?

unsigned short read_adc()
{
	unsigned char adc_low, adc_high;
	unsigned short value;

	ADCSRA |= (1<<ADSC); 	// ADC start conversion, ADSC = ‘1’
	while ((ADCSRA & (1<<ADIF)) == 0) // ADC conversion complete
	;

	adc_low = ADCL;		// Low value
	adc_high = ADCH;	// High value
	value = (adc_high << 8) | adc_low;  // high+low

	return value;
}

void show_adc(unsigned short value)
{
	if (value <= CDS_1) PORTA = 0xff;        // 8 on
	else if(value <= CDS_5) PORTA = 0xfd;    // 7 on
	else if(value <= CDS_10) PORTA = 0xbd; 	 // 6 on
	else if(value <= CDS_30) PORTA = 0xad;   // 5 on
	else if(value <= CDS_50) PORTA = 0x55;   // 4 on
	else if(value <= CDS_80) PORTA = 0x11;	 // 2 on
	else if (value <= CDS_100) PORTA = 0x01; // 1 on
	else PORTA = 0x00;

	if(adc_state == 1 && value >= CDS_80) {
		printf("The weather is good. I recommend you putting out plant outside.\n\n");
	}
}

// 1 character Transmit function
int putchar0(char c, FILE *stream)
{
	if (c == '\n')
	putchar0('\r', stream);
	while(!(UCSR0A & 0x20)); 	// UCSR0A 5¹ø bit = UDRE
	UDR0 = c;			// 1 character transmit
	return 0;
}

// 1 character receive function
char getchar0()
{
	while (!(UCSR0A & 0x80)); 	// UCSR0A 7¹ø bit = RXC
	return(UDR0);		// 1 character receive
}

void init_uart()
{
	UBRR0H = 0;
	UBRR0L = 8;		// 16Mhz, 115200 baud
	UCSR0B = 0x18;	// Receive(RX), Transmit(TX) Enable
	UCSR0C = 0x06;	// UART Mode, 8 Bit Data, No Parity, 1 Stop Bit
}

// read sensor
void AM2302_rd(void){
	unsigned char i,k;
	
	for(i=0;i<8;i++)
	data[i]=0; // init data array
	
	//host start signal - request data
	AM2302_OUT_1;
	_delay_ms(1);
	AM2302_OUT_0; //
	
	//released time
	// high_time
	TCNT1=0;
	TCCR1B=2;
	while(AM2302_IN)
	;
	TCCR1B=0;
	half_usec = TCNT1;
	
	// measure 30us high (min 20us ~ max 200us) - real : 20us
	if((half_usec < 30) || (half_usec > 410))
	goto AM2302_Error;
	
	//response AM2302
	// low_time
	TCNT1=0;
	TCCR1B=2;
	while(!AM2302_IN)
	;
	TCCR1B=0;
	half_usec=TCNT1;
	
	// measure 80us (min 75us ~ max 85us) - real : 80us
	if((half_usec<140)||(half_usec>180))
	goto AM2302_Error;
	
	// high_time
	TCNT1=0;
	TCCR1B=2;
	while(AM2302_IN);
	TCCR1B=0;
	half_usec = TCNT1;
	
	// measure 80us (min 75us ~ max 85us) - real : 80us
	if((half_usec<140)||(half_usec>180))
	goto AM2302_Error;
	
	//
	for(k=0;k<5;k++){
		for(i=0;i<8;i++){
			//pulse
			// low_time
			TCNT1=0;
			TCCR1B=2;
			while(!AM2302_IN)
			;
			TCCR1B=0;
			half_usec = TCNT1;
			
			// 50us low (min 48us ~ max 55us) - real : 56us, 68us
			if((half_usec < 85) || (half_usec > 150))
			goto AM2302_Error;
			
			// high_time
			TCNT1=0;
			TCCR1B=2;
			while(AM2302_IN)
			;
			TCCR1B=0;
			half_usec = TCNT1;
			
			// 26us & 70us high (min 22us ~ max 75us) - real : 24us,72~76us
			if((half_usec<34)||(half_usec>165))
			goto AM2302_Error;
			
			// high > 48us => 1
			if(half_usec > 96)
			data[k] |= (0x80 >> i);
		}
	}
	
	//Parity(check sum)check
	i = data[0] + data[1] + data[2] + data[3];
	
	//Parity error
	if(i!=data[4])
	goto AM2302_Error;
	
	//data copy
	Humidity = (unsigned int)data[0] * 256 + data[1];
	Temperiture = (unsigned int)data[2] * 256 + data[3];
	
	//Temperiture is '-' or '+'
	if(Temperiture & 0x8000) {
		Temp_sign=1;   // - value
		Temperiture &= 0x7FFF;
	}
	else
	Temp_sign=0;   // + value
	
	return;
	
	AM2302_Error:;
	Humidity=0;
	Temperiture=0;
	Temp_sign=0;
}

void display_fnd() {
	int i=0, k=0;
	int num[4];
	
	num[2] = (Humidity/100)%10;
	num[1] = (Humidity/10)%10;
	num[0] = Humidity%10;
	
	for(k=0; k<150; k++) {
		for(i=0; i<3; i++) {
			PORTC = digit[num[i]];
			PORTG = fnd_sel[i];
			if(i==1) PORTC |= 0x80;
			_delay_ms(5);
		}
	}
	
	PORTC = NULL;
	PORTG = NULL;
}

void ring_buzzer() {
	int i=0;

	// led all on
	PORTA = 0xff;

	DDRB = 0xff;
	// ring buzzer
	for(i=0; i<50; i++) {
		PORTB = 0x10; // ON
		_delay_ms(10);
		PORTB = 0x00; // OFF
		_delay_ms(10);
	}
	DDRB = 0x00;
}


ISR(INT4_vect) {
	char c;
	
	_delay_ms(10);
	if((PINE & 0x10)==0x00) {
		display_fnd();
		printf("Automatic Care Plant Program\n");
		printf("1. Current Temperiture and Humidity\n");
		printf("2. Give water to plant\n");
		printf("3. I don't want to give message\n");
		printf("4. I want to give message\n");
		printf("Select : ");
		
		c = getchar0( );		// 1 character receive
		printf("%c\n", c);		// print original character
		c = c - '0';		    // ASCII = number
		
		if(c == 1) {
			printf("Humidity : %d.%d%%  \n", Humidity/10, Humidity%10);
			if(Temp_sign)
			printf("Temperiture : -%d.%d C  \n", Temperiture/10, Temperiture%10);
			else
			printf("Temperiture : %d.%d C  \n", Temperiture/10, Temperiture%10);
			printf("\n\n");
		}
		else if(c == 2) {
			ring_buzzer();
			move_motor();
			printf("Complete!!\n\n");
		}
		else if(c == 3) {
			adc_state = 0;
			printf("Complete... I will not give you message...\n\n");
		}
		else if(c == 4) {
			adc_state = 1;
			printf("Complete... I will give you message...\n\n");
		}
		
	}
	EIFR |= 1<<4;
}

void move_motor() {
	DDRB = 0xff;
	
	PORTB = MOTOR_CCW;
	_delay_ms(2000);
	PORTB = MOTOR_STOP2;
	_delay_ms(200);
	PORTB = MOTOR_CW;
	_delay_ms(300);
	PORTB = MOTOR_STOP1;
	_delay_ms(200);
	
	DDRB = 0x00;
}

int main(void){
	unsigned short value;
	
	DDRA = 0xff;
	DDRC = 0xff;
	DDRG = 0xff;
	DDRE = 0xcf;
	
	// register set
	ADMUX = 0x00;
	ADCSRA = 0x87;
	
	EICRB = 0x0a;
	EIMSK = 0x30;
	sei();
	
	init_uart();
	stdout = &mystdout;
	
	while(1){
		
		value = read_adc();
		show_adc(value);
		//_delay_ms(10);
		
		AM2302_rd();
		
		if(Humidity/10 < 30) {
			printf("** Plant is dying... I'll give it water!\n\n");
			ring_buzzer();
			move_motor();
		}
		
		display_fnd();
		
		// all off
		PORTA = 0x00;
		PORTC = NULL;
		PORTG = NULL;
		PORTB = 0x00;
		
	}
}
