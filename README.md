# Leap-Music-Player
Play and control your music using gesture controls! This was developed as a prototype for a smart ring with the same functionality, to prove that gesture based controls for controlling music would be viable.
![Leap-Music-Player Screenshot](LeapMusicPlayer.png?raw=true "LeapMusicPlayer")

# Setup

The following hardware and software is required in order to run the Leap Music Player.

Leap Motion Controller (https://www.leapmotion.com)
Processing 3.3.6 (https://www.leapmotion.com) with libraries:

-    Beads
-    Leap Motion library for Processing

*All libraries available within Processing's internal library viewer.*

# Usage:

- Plug in Leap motion, orient it to face towards the Ceiling, oriented perpedicular to the screen you're viewing
- Open LeapMusicPlayer/LeapMusicPlayer.pde in Processing 
-- LeapMusicPlayer depends upon DoubleLinkedList.pde, however Processing should automatically load DoubleLinkedList.pde in a different tab
- Use gestures in range of the leap motion's FOV to control your music.

# Gestures
* It is easiest for the leap to recognize gestures with one finger extended. I.e pretend you're pointing at the screen  
- Tap: Play/Pause music. Tap to pause music. Tap again to play!
- Swipe Right: Skip music. Swipe right to skip to the next song.
- Swipe Left: Rewind/Skip (backwards) music. Swipe left once to rewind to the start of the song. Swipe again to Skip to the previously played song. Continue swiping left to continuously skip to the previously played song.
- Circle Clockwise: Volume up. Create small circles clockwise to increase the volume.
- Circle Anticlockwise: Volume down. Create small circles anticlockwise to decrease volume.
* Circle Gestures work on every axis, ensure to keep the entirety of the circle within the FOV of the leap motion. Smaller circles work best, imagine you're drawing the outline of a grape.


A demonstration of the gestures can be viewed here:
https://www.youtube.com/watch?v=dVmbgqKYfi8&feature=youtu.be

# Troubleshooting
Q: Leap Motion not detected in Processing

A: Install device drivers from https://www.leapmotion.com/setup/





You can view our mockups / designs for the final product here:
https://www.youtube.com/watch?v=IPdm2zWZ1a8&feature=youtu.be
