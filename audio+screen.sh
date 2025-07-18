#!/usr/bin/env bash

# logging
debug_log="/home/coder/bin/Bash/Audio+Screen/audio+screen_debug.log"
error_log="/home/coder/bin/Bash/Audio+Screen/audio+screen_error.log"

current_time=$(date +%H%M)

log_debug() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - DEBUG: $message" >> "$debug_log"
}

log_error() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $message" >> "$error_log"
}

PIDFILE1="/tmp/vidpid"
PIDFILE2="/tmp/audpid"
OUTPUT_DIR="/media/coder/460GB/Audio+Screen-Notes"
FILE_PREFIX="A+S_Note-"

record() {
    local outfile_video="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+x%y-%m-%d-%H%M%S').mkv"
    local outfile_audio="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+x%y-%m-%d-%H%M%S').wav"
    
    ffmpeg -s "$(xdpyinfo | awk '/dimensions/{print $2}')" -f x11grab -r 30 -i :0.0 -c:v h264 -qp 0 "$outfile_video" > /dev/null 2>&1 &
    echo $! > "${PIDFILE1}"
	
	jack_connect system:capture_2 "Calf Studio Gear-01:Mono Input In #1"
    ffmpeg -f jack -i "ffmpeg" "$outfile_audio" > /dev/null 2>&1 &
    echo $! > "${PIDFILE2}"

    rofi -theme-str "window {width: 400;}" -e "A+S recording started..."
    log_debug "Audio+Screen recording started..."
}

end() {
    if [[ -f "${PIDFILE1}" ]]; then
        local proc_pid=$(cat "${PIDFILE1}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
        else
            log_debug "Video process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE1}"
    fi

    if [[ -f "${PIDFILE2}" ]]; then
        local proc_pid=$(cat "${PIDFILE2}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
        else
            log_debug "Audio process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE2}"
    fi
	jack_disconnect system:capture_2 "Calf Studio Gear-01:Mono Input In #1"
    rofi -e -theme-str "window {width: 400;}" "A+S recording ended!"
    log_debug "Audio+Screen recording ended!"
}

if [[ -f "${PIDFILE1}" || -f "${PIDFILE2}" ]]; then
	log_debug "Closing pid files"
    end
else
	log_debug "Executing record funtion"
    record
fi
