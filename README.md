# < Embedded_Project > Make Simple Products using Embedded System

<p> Environment : Arduino, ATmel Studio 7 in Windows
<p> Language : C, Assembler

<br><br>

# Microprocessor - 2017.06
<p> 8051을 이용하여 짧은 동요를 연주 </p>
<p> 8051을 이용하여 간단한 움직이는 마리오를 LCD로 구현 </p>

##### Video URL :

<br><br>

# Arduino - 2018.06
<p> Buzzer, 초음파 Sensor를 이용하여 거리에 따라 높낮이가 다른 소리 내기 </p>
<p> LCD, Buzzer, Step Motor, 초음파 Sensor를 이용해 간단한 후방감지 자동차 구현</p>

##### Video URL : https://youtu.be/8en6oMAzOOQ

<br><br>

# Plant Management - 2017.11
<p> ATmega 128을 이용하여 간단한 화분관리기 구현 </p>

![default](https://user-images.githubusercontent.com/21214309/48600458-41f62880-e9af-11e8-8f78-d12adbaa0839.JPG)

##### Function
1) DHT22로 온도, 습도를 측정하여 UART로 출력, 습도의 경우는 FND에도 출력
  * UART의 경우는 Switch1을 누르면 목록(작동 메뉴)가 뜨고 실행 시키고자 하는 동작 번호를 누르면 해당 동작을 수행함
2) UART로 선택할 수 있는 기능
  * 1. 온도와 습도를 출력해 줌
  * 2. 습도와 관계없이 사용자가 화분에 물을 주고 싶다면 줄 수 있도록 함
3) 조도 센서를 이용해 일정 밝기 이상이 되면 UART에 “화분을 내놓을 것을 추천!”이라는 메시지를 출력
  * UART를 통해 메시지를 수신할지 안 할지를 선택할 수 있다.
4) 조도의 밝기에 따라 LED에 불이 들어옴
5) 일정 습도 이하가 되면 자동으로 모터가 동작하여 화분에 물을 줌
6) 모터 동작전에 버저가 울리고 LED가 모두 ON된다. 

##### PDF File : [Embedded_System_project.pdf](https://github.com/YouMinJung/Embedded_Project/files/2588096/Embedded_System_project.pdf)
##### Video URL :
