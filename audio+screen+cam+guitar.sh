#!/usr/bin/env bash

# logging
debug_log="/home/coder/bin/Bash/Audio+Screen+Cam+Guitar/audio+screen+cam+guitar_debug.log"
error_log="/home/coder/bin/Bash/Audio+Screen+Cam+Guitar/audio+screen+cam+guitar_error.log"

current_time=$(date +%H%M)

log_debug() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - DEBUG: $message" >> "$debug_log"
}

log_error() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $message" >> "$error_log"
}

# variable list
PIDFILE1="/tmp/campid"
PIDFILE2="/tmp/screenpid"
PIDFILE3="/tmp/audiopid"
PIDFILE4="/tmp/gtrpid"
OUTPUT_DIR="/media/coder/460GB/Audio+Screen+Cam+Guitar-Notes"
FILE_PREFIX="A+S+C+G_Note-"

# record function
record() {
	# set path and filename for Cam, Screen, Audio & Guitar files
    local outfile_cam="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+x%y-%m-%d-%H%M%S').cam.mkv"
    local outfile_video="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+x%y-%m-%d-%H%M%S').screen.mkv"
    local outfile_audio="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+x%y-%m-%d-%H%M%S').audio.wav"
    local outfile_guitar="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+x%y-%m-%d-%H%M%S').guitar.wav"
    
    # start cam app, wait 2 seconds for a clean start, xdotool section
    # acts as keyboard inputing Shift +V to start recording the cam
    guvcview --gui=gtk3 --video="$outfile_cam" > /dev/null 2>&1 &
    echo $! > "${PIDFILE1}"
	sleep 1
	WINDOW_ID=$(xdotool search --onlyvisible --class guvcview)
	if [ -z "$WINDOW_ID" ]; then
		log_debug "No visible window found for guvcview."
	else
		# Send Shift + V to guvcview to start recording
		xdotool key --window $WINDOW_ID shift+v
		log_debug "Sent Shift + V input to guvcview"
	fi
	
	# start an ffmpeg instance to record screen
	ffmpeg -s "$(xdpyinfo | awk '/dimensions/{print $2}')" -f x11grab -r 30 -i :0.0 -c:v h264 -qp 0 "$outfile_video" > /dev/null 2>&1 &
    echo $! > "${PIDFILE2}"
    
	# start an ffmpeg instance to setup connection and record mic  
	jack_connect system:capture_2 "Calf Studio Gear-01:Mono Input In #1"
    ffmpeg -f jack -i "ffmpeg" "$outfile_audio" > /dev/null 2>&1 &
    echo $! > "${PIDFILE3}"
    
	# start an ffmpeg instance to setup connection and record guitar via guitarix app
	jack_connect system:capture_1 "gx_head_amp:in_0"
	ffmpeg -f jack -i "guitarix" "$outfile_guitar" > /dev/null 2>&1 &
    echo $! > "${PIDFILE4}"
    
	# spit out a starting message to screen
    rofi -theme-str "window {width: 400;}" -e "A+S+C+G recording STARTED..."
    log_debug "Audio+Screen+Cam+Guitar recording STARTED..."
}

# end all 4 pid's
end() {
    if [[ -f "${PIDFILE1}" ]]; then
        local proc_pid=$(cat "${PIDFILE1}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
        else
            log_debug "Cam process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE1}"
    fi

    if [[ -f "${PIDFILE2}" ]]; then
        local proc_pid=$(cat "${PIDFILE2}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
        else
            log_debug "Screen process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE2}"
    fi

    if [[ -f "${PIDFILE3}" ]]; then
        local proc_pid=$(cat "${PIDFILE3}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
        else
            log_debug "Audio process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE3}"
        jack_disconnect system:capture_2 "Calf Studio Gear-01:Mono Input In #1"
    fi
    
	if [[ -f "${PIDFILE4}" ]]; then
        local proc_pid=$(cat "${PIDFILE4}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
        else
            log_debug "Guitar process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE4}"
		jack_disconnect system:capture_1 "gx_head_amp:in_0"
    fi
    
    rofi -theme-str "window {width: 400;}" -e "A+S+C+G recording ENDED!"
    log_debug "Audio+Screen+Cam+Guitar recording ENDED!"
}

# check if any of the 4 pid's are running and if they are run the end function
# if they are not running then run the record function
if [[ -f "${PIDFILE1}" || -f "${PIDFILE2}" || -f "${PIDFILE3}" || -f "${PIDFILE4}" ]]; then
	log_debug "Closing pid files"
    end
else
	log_debug "Executing record funtion"
    record
fi
