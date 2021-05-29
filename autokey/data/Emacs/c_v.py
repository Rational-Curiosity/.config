if store.get_global_value("ctrl-space"):
    keyboard.send_keys("<shift>+<page_down>")
else:
    keyboard.send_key("<page_down>")