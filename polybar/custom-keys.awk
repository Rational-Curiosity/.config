#!/usr/bin/env -S awk -W interactive -f
BEGIN{
    TITLE=""
    MODE=""
    CHAIN=""
    LAST_KEY=""
}
{if ($0 == "BBegin chain") {
        CHAIN=LAST_KEY
    } else if ($0 == "EEnd chain") {
        CHAIN=""
    } else if ($0 ~ /^TITLE:/) {
        TITLE=substr($0, 7)
    } else if ($0 ~ /^MODE:/) {
        MODE=substr($0, 6)
    } else if ($0 == "Hsuper+q") {
        if (substr(TITLE, length(TITLE) - 4) == "-halt") {
               TITLE=substr(TITLE, 1, length(TITLE) - 4)
           } else if (TITLE != "") {
               TITLE=TITLE "-halt"
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
