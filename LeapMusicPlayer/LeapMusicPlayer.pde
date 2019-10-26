import beads.*;
import java.util.Arrays; 
import java.util.LinkedList;
import de.voidplus.leapmotion.*;
import java.nio.file.Files;

AudioContext ac;
PowerSpectrum ps;
LeapMotion leap;

//Music file path
String musicPath;

//Data stucture for all songs
DoublyLinkedList<String> songs;

//Iterator for accessing which song to play (supports previous and next)
public ListIterator<String> playlist;

//Boolean to pause music
boolean paused = false;

//Float to set volume
float volume = 0.5;

//Stores filepath of current song
String song; 

//Records time since last gesture to ensure interactions don't trigger twice on the same gesture
int gestureTimeBuffer;

//Sets visual colors for presentation
color fore = color(255, 102, 204);
color back = color(0,0,0);



void setup() {
  size(960,960);
  ac = new AudioContext();
  
  leap = new LeapMotion(this).allowGestures();
  
  //Written with Windows file paths, feel free to change on Mac/Linux
  musicPath = sketchPath("..\\Snippets\\");
  
  createPlaylist();
  setupAudioContext();
  
  gestureTimeBuffer = millis();
  
}

//Construct a Double Linked List to store the playlist of songs
void createPlaylist() {
 songs = new DoublyLinkedList<String>();
 File folder = new File(musicPath);
 File[] listOfFiles = folder.listFiles();
 for (File file : listOfFiles) {
  if (file.isFile()) {
    songs.add(file.getName());
  }
 }
 
 //Ensure first and last songs are linked to each other so that the playlist loops
 songs.makeCircular();
 
 playlist = songs.iterator();
 printPlaylist();

}

//Debug function to check if playlist was successfully constructed.
void printPlaylist() {
  //Ensures to check if the playlist 'loops', i.e the final song continues into the first song
   for (int i = 0; i < songs.size() * 2; i++){
    System.out.println(i + ": " + playlist.next().toString()); 
   }
 }

void nextSong() {
  song = playlist.next().toString();
  System.out.println("Skipped Song");
  playSong(song);
}

void prevSong() {
  song = playlist.previous().toString();
  System.out.println("Previous Song");
  playSong(song);
}

void restartSong() {
  System.out.println("Restarted Song");
  playSong(song);
}

void volumeUp() {
  if (volume < 5){
    volume += 0.005;
    ac.out.setGain(volume);
  }
}

void volumeDown() {
  if (volume > 0){
    volume -= 0.005;
    ac.out.setGain(volume);
  }
}

void playSong(String song) {
  ac.out.clearInputConnections();
  Sample sample = SampleManager.sample(musicPath + song);
  SamplePlayer player = new SamplePlayer(ac, sample);
  player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  Gain ga = new Gain(ac, 2, volume);
  ga.addInput(player);
  ac.out.setGain(volume);
  ac.out.addInput(ga);
  System.out.println("Now playing: " + song);
}

void setupAudioContext(){
  nextSong();
   
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  FFT fft = new FFT();
  ps = new PowerSpectrum();
  sfs.addListener(fft);
  fft.addListener(ps);
  ac.out.addDependent(sfs);
  
  ac.start();
}



void leapOnSwipeGesture(SwipeGesture g, int state){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector positionStart    = g.getStartPosition();
  PVector direction        = g.getDirection();
  float   speed            = g.getSpeed();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();
  int wait = 10000;
  

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
      break;
    case 3: // Stop
    if (finger.getType() == 1 ){
        if (getDirection(direction) == "Left") {
           if (millis() - gestureTimeBuffer <= wait){
             prevSong(); 
           }
            else{
             restartSong();
            }
        }
        if (getDirection(direction) == "Right"){
           nextSong();
        }
        gestureTimeBuffer = millis();
       
      }
      break;
  }
}

String getDirection(PVector direction) {
  if(direction.x > 0)
    return "Right";
  else
    return "Left";
  
}

void leapOnKeyTapGesture(KeyTapGesture g){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector position         = g.getPosition();
  PVector direction        = g.getDirection();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();

  if (finger.getType() == 1){
   paused = !paused;
   ac.out.pause(paused); 
   println("Paused song: " + paused);
  }
}

void leapOnCircleGesture(CircleGesture g, int state){
  int     id               = g.getId();
  Finger  finger           = g.getFinger();
  PVector positionCenter   = g.getCenter();
  float   radius           = g.getRadius();
  float   progress         = g.getProgress();
  long    duration         = g.getDuration();
  float   durationSeconds  = g.getDurationInSeconds();
  int     direction        = g.getDirection();

  switch(state){
    case 1: // Start
      break;
    case 2: // Update
    
    if (durationSeconds > 0.1){
      switch(direction){
        case 0: // Anticlockwise/Left gesture
          if (finger.getType() == 1 && !paused){
            volumeDown();
          }
          break;
        case 1: // Clockwise/Right gesture
          if (finger.getType() == 1 && !paused){
            volumeUp();
          }
          //println("Volume Changed");
          break;
      }
    }
    
  }
}

//Draw equilizer to visually aid music player
void draw()
{
  background(back);
  stroke(fore);
  
  if(ps == null) return;
  float[] features = ps.getFeatures();
  if(features != null) {
    //scan across the pixels
    for(int i = 0; i < width; i++) {
      int featureIndex = i * features.length / width;
      int vOffset = height - 1 - Math.min((int)(features[featureIndex] * height), height - 1);
      line(i,height,i,vOffset);
    }
  }
}