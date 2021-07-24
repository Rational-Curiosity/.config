#!/bin/sh

FIFO=~/.config/polybar/keys.fifo

[ -p "$FIFO" ] || mkfifo "$FIFO"
while read EVENT
do
    case "$EVENT" in
    'BBegin chain')
        CHAIN="${F#ff8115}$LAST_KEY%{F-}"
        ;;
    'EEnd chain')
        CHAIN=""
        ;;
    TITLE:*)
        TITLE="$(echo "$EVENT" | cut -c7-)"
        PRE_HALT=""
        ;;
    MODE:*)
        MODE="$(echo "$EVENT" | cut -c6-)"
        ;;
    Hsuper+q)
        if [ -n "$TITLE" ]
        then
            if [ -z "$PRE_HALT" ]
            then
                PRE_HALT="$TITLE"
                TITLE="%{B#af4115}$TITLE%{B-}"
            else
                TITLE="$PRE_HALT"
                PRE_HALT=""
            fi
        else
            continue
        fi
        ;;
    H*)
        LAST_KEY="$(echo "$EVENT" | cut -c2-)"
        continue
        ;;
    *)
        continue
        ;;
    esac
    echo "$TITLE $MODE $CHAIN" | sed 's/^ *//;s/ *$//;s/   */ /g'
done < "$FIFO"