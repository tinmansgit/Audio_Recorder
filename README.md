# Recording scripts<br/>
<br />
Modified version of BreadOnPenguins original Bash ffmpeg script for taking audio notes<br />
<br />
Setup: Focusrite interface, c290 webcam, qjackctl, calf-plugins, ffmpeg, guvcview<br />
<br />
audio.sh - connects audio input >> calf rack >> ffmpeg<br />
audio+screen.sh - added 2nd ffmpeg block to record desktop<br />
audio+screen+cam.sh - added guvcview block to record web cam<br />
audio+screen+cam+guitar.sh - added 3rd ffmpeg block to record guitar input >> guitarix >> ffmpeg<br />
<br />
For post production of audio & video I use kdenlive.<br />
Tip: when running the scripts with audio & cam be sure to snap some kind of visual/audio marker at the begining of the recording to give you an alignment point in kdenlive.<br />
<br />
