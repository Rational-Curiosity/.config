from subprocess import run

p = run("bspc node -z left -20 0", shell=True)
if p.returncode != 0:
    run("bspc node -z right 20 0", shell=True)