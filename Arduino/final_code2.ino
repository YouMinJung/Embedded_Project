#include <SoftwareSerial.h>
#include <Servo.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

#define Triger 2
#define Echo 4
#define BUZZER 11

// set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd(0x27,16,2);

Servo servo;
int value = 0; //servo motor degree

int blueTx = 6;   //Tx 
int blueRx = 5;   //Rx
SoftwareSerial mySerial(blueTx, blueRx);  
String myString=""; // receive string
 
void setup() {
  Serial.begin(9600);   
  mySerial.begin(9600);
  pinMode(13, OUTPUT);  //pin13 = LED

  // servo motor
  servo.attach(7);

  // SR-04
  pinMode(Triger, OUTPUT);
  pinMode(Echo, INPUT);

  // buzzer
  pinMode(BUZZER, OUTPUT); 

  // LCD
  lcd.init(); // initialize the lcd
  lcd.backlight();
  lcd.print("Hello My Car");
}
 
void loop() {
  // pulse 10us create
  digitalWrite(Triger, LOW);
  delayMicroseconds(2);
  digitalWrite(Triger, HIGH);
  delayMicroseconds(10);
  digitalWrite(Triger, LOW);

  long duration = pulseIn(Echo, HIGH);
  long distance = duration/29/2;
  char buf[20];
  snprintf(buf, sizeof(buf), "Distance %4d cm", distance);
  
  lcd.setCursor(0, 2);
  lcd.print(buf);

  // buzzer ring
  if(distance <= 4) {
    tone(BUZZER, 700); 
  }
  else if(4 < distance && distance <= 8) {
    tone(BUZZER, 400); 
  }
  else if(8 < distance) {
    noTone(BUZZER);
  }

  // bluetooth module
  while(mySerial.available()) {
    char myChar = (char)mySerial.read();  // int -> string
    myString += myChar;  
    delay(5);       
  }
  
  if(!myString.equals(""))  {
    Serial.println("input value: "+myString); //시리얼모니터에 myString값 출력

    // LED on/off
    if(myString=="on") {
        digitalWrite(13, HIGH); //LED ON
    } 
    else if(myString=="off") {
        digitalWrite(13, LOW);  //LED OFF
    }
    // servo motor move
    else if(myString=="forward") {
        servo.write(0);
    }
    else if(myString=="backward") {
        servo.write(180);
    }
      
    myString="";  //myString 변수값 초기화
  }
  delay(1000);
}
