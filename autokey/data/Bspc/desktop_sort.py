system.exec_command("Ms=$(bspc query -M) && [ $(echo \"$Ms\"|wc -l) -eq 1 ] && bspc monitor -d 1 2 3 4 5 || I=0; for M in $(echo \"$Ms\"|tr '\n' ' '); do bspc monitor $M -d $((I=I+1)) $((I=I+1)) $((I=I+1)); done", getOutput=False)