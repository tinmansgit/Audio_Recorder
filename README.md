# Recording scripts<br/>
<br />
Modified version of BreadOnPenguins original Bash ffmpeg script for taking audio notes<br />
<br />
Setup: Focusrite interfaces (Scarlett 2i2 usb & Saffire Pro24 firewire), c290 webcam, qjackctl, calf-plugins, guitarix, ffmpeg, guvcview<br />
<br />
audio.sh - connects audio input >> calf rack >> ffmpeg<br />
audio+screen.sh - added 2nd ffmpeg block to record desktop<br />
audio+screen+cam.sh - added guvcview block to record web cam<br />
audio+screen+cam+guitar.sh - added 3rd ffmpeg block to record guitar input >> guitarix >> ffmpeg<br />
<br />
Create keybindings to launch each script.<br />
(Sup+a = audio.sh)<br />
(Sup+s = audio+screen.sh)<br />
(Sup+c = audio+screen+cam.sh)<br />
(Sup+g = audio+screen+cam+guitar.sh)<br />
<br />
TODO: upload qjackctl configs for patchage and calf configs<br />
<br />
