#!/usr/bin/env bash

# logging
debug_log="/home/coder/bin/Bash/Audio/audio_debug.log"
error_log="/home/coder/bin/Bash/Audio/audio_error.log"

current_time=$(date +%H%M)

log_debug() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - DEBUG: $message" >> "$debug_log"
}

log_error() {
    local message=$1
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $message" >> "$error_log"
}

PIDFILE="/tmp/audpid"
OUTPUT_DIR="/media/coder/460GB/Audio-Notes"
FILE_PREFIX="Audio_Note-"

record() {
    outfile="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+%y-%m-%d-%H%M%S').wav"
	jack_connect system:capture_2 "Calf Studio Gear-01:Mono Input In #1"
	ffmpeg -f jack -i "ffmpeg" -af "afftdn=nr=10:nf=-80:tn=1" "$outfile" > /dev/null 2>&1 &
    proc_pid=$!
    echo "${proc_pid}" > "${PIDFILE}"
    rofi -e "Audio recording started..."
    log_debug "Audio recording started..."
}

end() {
    if [[ -f "${PIDFILE}" ]]; then
        proc_pid=$(cat "${PIDFILE}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
            sleep 1
        else
            log_debug "Process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE}"
		jack_disconnect system:capture_2 "Calf Studio Gear-01:Mono Input In #1"
        rofi -e "Audio recording ended!"
        log_debug "Audio recording ended!"
    fi
}

if [[ -f "${PIDFILE}" ]]; then
	log_debug "Closing pid file"
    end
else
	log_debug "Executing record funtion"
    record
fi
