# Audio_Recorder
Bash ffmpeg script for taking audio notes<br />
<br />
Create a key combination to Start Recording. Use same key combination again to Stop Recording.<br />
<br />
Use ffmpeg to record audio notes. Creates an ffmpeg input in qjackctl for connecting audio input. Noise floor filter option to strip background noise if needed (-25 high filtering, -75 low filtering). Experiment with what setting works best for your situation. Notify-send messages popup at start and stop of recording.<br />
<br />  
