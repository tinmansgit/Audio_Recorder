#!/usr/bin/env bash

PIDFILE="/tmp/audpid"
OUTPUT_DIR="~/Audio-Notes"
FILE_PREFIX="Note_"

record() {
    outfile="${OUTPUT_DIR}/${FILE_PREFIX}$(date '+%y-%m-%d-%H%M%S').wav"
    ffmpeg -f jack -i ffmpeg -af "afftdn=nf=-25" "$outfile" > /dev/null 2>&1 &
    proc_pid=$!
    echo "${proc_pid}" > "${PIDFILE}"
    notify-send -u critical "Recording started..."
}

end() {
    if [[ -f "${PIDFILE}" ]]; then
        proc_pid=$(cat "${PIDFILE}")
        if kill -0 "${proc_pid}" 2>/dev/null; then
            kill -15 "${proc_pid}"
            sleep 1
        else
            echo "Process ${proc_pid} is not running."
        fi
        rm -f "${PIDFILE}"
        notify-send -u critical "Recording ended!"
    fi
}

if [[ -f "${PIDFILE}" ]]; then
    proc_pid=$(cat "${PIDFILE}")
    if kill -0 "${proc_pid}" 2>/dev/null; then
        end
        exit 0
    else
        rm -f "${PIDFILE}"
        record
    fi
else
    record
fi
