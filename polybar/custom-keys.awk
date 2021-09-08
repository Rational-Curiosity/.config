#!/usr/bin/env -S awk -W interactive -f
BEGIN{
    TITLE=""
    MODE=""
    CHAIN=""
    LAST_KEY=""
    PRE_COLOR=""
    CHAIN_COLOR="%{B#af4115}%{F#81ff15}"
    TMP=""
    I = 0
}
{if ($0 == "BBegin chain") {
        if (LAST_KEY == "super+Print") {
            CHAIN=CHAIN_COLOR "{Clipb,Win,Area,Interac}" "%{F-}%{B-}"
        } else if (LAST_KEY == "super+a") {
            CHAIN=CHAIN_COLOR "{Close,Kill,Tiled,Qpseudo,Sfloat,Fullscreen,Mark,Xlock,strickY,Zprivate}" "%{F-}%{B-}"
        } else if (LAST_KEY == "super+ctrl+x") {
            CHAIN=CHAIN_COLOR "{Auto,1max,2 2048x1152,3 2560x1440,4 3200x1800,5 3840x2160}" "%{F-}%{B-}"
        } else if (LAST_KEY == "super+t") {
            CHAIN=CHAIN_COLOR "{Toggle,Notify,+focused,-focused,Inc unfocus,Dec unfocus}" "%{F-}%{B-}"
        } else if (LAST_KEY == "ctrl+c") {
            CHAIN=CHAIN_COLOR "{ctrl+c,ctrl+e,ctrl+d,Tabs}" "%{F-}%{B-}"
        } else if (LAST_KEY == "ctrl+x") {
            CHAIN=CHAIN_COLOR "{ctrl+Save,ctrl+Close,Kill tab,4+tab,5+win}" "%{F-}%{B-}"
        } else {
            CHAIN=CHAIN_COLOR LAST_KEY "%{F-}%{B-}"
        }
    } else if ($0 == "EEnd chain") {
        CHAIN=""
    } else if ($0 ~ /^TITLE:/) {
        TITLE=substr($0, 7)
        PRE_COLOR=""
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
    } else if ($0 ~ /^COLOR:/) {
        if (TITLE != "") {
            if (PRE_COLOR == "") {
                PRE_COLOR=TITLE
                TITLE="%{B" substr($0, 7) "}" TITLE "%{B-}"
            } else {
                TITLE=PRE_COLOR
                PRE_COLOR=""
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
