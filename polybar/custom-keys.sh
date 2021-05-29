#!/bin/sh

FIFO=~/.config/polybar/keys.fifo

[ -p "$FIFO" ] || mkfifo "$FIFO"
while read EVENT
do
    case "$EVENT" in
    'BBegin chain')
        CHAIN="$LAST_KEY"
        ;;
    'EEnd chain')
        CHAIN=""
        ;;
    TITLE:*)
        TITLE="$(echo "$EVENT" | cut -c7-)"
        ;;
    MODE:*)
        MODE="$(echo "$EVENT" | cut -c6-)"
        ;;
    Hsuper+q)
        case "$TITLE" in
        *-halt)
            TITLE="$(echo $TITLE | cut -d- -f1)"
            ;;
        *)
            if [ -n "$TITLE" ]
            then
                TITLE="$TITLE-halt"
            fi
            ;;
        esac
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