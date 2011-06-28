import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;

private static final byte START_OF_CMD = 0x01;
private static final byte END_OF_DATA = 0x20;

Minim minim;
AudioInput in;
FFT fft;
Serial myPort;  // Create object from Serial class
float maxF;
int lastH;

void setup() {
  size(250, 500);
  background ( 0 ) ;
  frameRate(20);

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.linAverages(1);

  String portName = Serial.list()[0];
  println("open serial port: "+portName);
  myPort = new Serial(this, portName, 115200);
}
int xx=0;
void draw() {

  fft.forward(in.mix);

  float f = fft.getAvg(0);
  if (f>maxF) maxF=f;

  //calculate current volume, based on the loudest amplitude
  int h = int(10*f/maxF);
  if (lastH!=h) {
    sendSerial(byte(h));  
    lastH=h;
  }

  fill(0);
  rect (0, 0, width, height );
  fill(100+h*10);
  rect (50, 450, 150, -h*20);

  if (maxF>0.001) maxF -= 0.001;
}

void sendSerial(byte val) {
  byte cmdfull[] = new byte[4];
  cmdfull[0] = START_OF_CMD;
  cmdfull[1] = val;
  cmdfull[2] = val;
  cmdfull[3] = END_OF_DATA;  
  myPort.write(cmdfull);
}

void stop()
{
  in.close();
  minim.stop();
  super.stop();
}

