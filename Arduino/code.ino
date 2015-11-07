#include <RFduinoBLE.h>

int motorA[] = {6,5};
int motorB[] = {4,3};

// the setup routine runs once when you press reset:
void setup() {
  pinMode(6, OUTPUT);  
  pinMode(5, OUTPUT);
  pinMode(4, OUTPUT);  
  pinMode(3, OUTPUT);
  analogWrite(6, 0);
  analogWrite(3, 0);

  analogWrite(5, 0);
  analogWrite(4, 0);
  RFduinoBLE.advertisementInterval = 675;
  RFduinoBLE.advertisementData = "-servo";
  RFduinoBLE.begin(); 
               

}

// the loop routine runs over and over again forever:
void loop() {
  Serial.begin(9600);
}

void RFduinoBLE_onReceive(char *data, int len){
  analogWrite(5, (int)data[0]);
  analogWrite(4, (int)data[1]);
}

void RFduinoBLE_onDisconnect(){
  Serial.println("Desconectado");
  analogWrite(5, 0);
  analogWrite(4, 0);
}

void RFduinoBLE_onConnect(){
  Serial.println("Contectado");
  //analogWrite(5, 100);
  //analogWrite(4, 100);
}
