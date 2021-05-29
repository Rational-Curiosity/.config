import subprocess as sp

p = sp.run("bspc node -z bottom 0 -20", shell=True)
if p.returncode != 0:
    sp.run("bspc node -z top 0 20", shell=True)