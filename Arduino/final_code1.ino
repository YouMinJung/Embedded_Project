
#define Triger 2
#define Echo 4
#define BUZZER 11

void setup() {
  Serial.begin(115200);

  pinMode(Triger, OUTPUT);
  pinMode(Echo, INPUT);
  
  pinMode(BUZZER, OUTPUT); 
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

  Serial.print(distance);
  Serial.print("cm");
  Serial.println();

  if(distance <= 5) {
    tone(BUZZER, 349); // pa
  }
  else if(5 < distance && distance <= 10) {
    tone(BUZZER, 330); // mi
  }
  else if(10 < distance && distance <= 15) {
    tone(BUZZER, 294); // re
  }
  else if(15 < distance && distance <= 20) {
    tone(BUZZER, 262); // do
  }
  else if(distance > 20){
    noTone(BUZZER);
  }
  
  delay(1000);
}
