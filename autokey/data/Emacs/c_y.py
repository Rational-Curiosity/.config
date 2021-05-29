if window.get_active_class() == "Alacritty.Alacritty":
    keyboard.send_keys("<shift>+<insert>")
else:
    keyboard.send_keys("<ctrl>+V")