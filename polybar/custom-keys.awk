#!/usr/bin/env -S awk -W interactive -f
BEGIN{
    TITLE=""
    MODE=""
    CHAIN=""
    LAST_KEY=""
    PRE_HALT=""
    TMP=""
    I = 0
}
{if ($0 == "BBegin chain") {
        CHAIN="%{B#af4115}%{F#81ff15}" LAST_KEY "%{F-}%{B-}"
    } else if ($0 == "EEnd chain") {
        CHAIN=""
    } else if ($0 ~ /^TITLE:/) {
        TITLE=substr($0, 7)
        PRE_HALT=""
    } else if ($0 ~ /^MODE:/) {
        TMP=substr($0, 6, 1)
        if (TMP == "+") {
            TMP=substr($0, 7)
            I = index(MODE, TMP)
            if (I > 0) {
                MODE=substr(MODE, 1, I-1) substr(MODE, I+length(TMP)) TMP
            } else {
                MODE=MODE TMP
            }
        } else if (TMP == "-") {
            TMP=substr($0, 7)
            I = index(MODE, TMP)
            if (I > 0) {
                MODE=substr(MODE, 1, I-1) substr(MODE, I+length(TMP))
            }
        } else if (TMP == "!") {
            TMP=substr($0, 7)
            I = index(MODE, TMP)
            if (I > 0) {
                MODE=substr(MODE, 1, I-1) substr(MODE, I+length(TMP))
            } else {
                MODE=MODE TMP
            }
        } else {
            MODE=substr($0, 6)
        }
    } else if ($0 == "Hsuper+q") {
        if (TITLE != "") {
            if (PRE_HALT == "") {
                PRE_HALT=TITLE
                TITLE="%{B#af4115}" TITLE "%{B-}"
            } else {
                TITLE=PRE_HALT
                PRE_HALT=""
            }
        } else {
            next
        }
    } else if ($0 ~ /^H/) {
        LAST_KEY=substr($0, 2)
        next
    } else {
        next
    }
    OUTPUT=TITLE " " MODE " " CHAIN
    sub(/^ */, "", OUTPUT)
    sub(/ *$/, "", OUTPUT)
    gsub(/  +/, " ", OUTPUT)
    print OUTPUT
    # fflush(stdout)
}
