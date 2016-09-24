def set_fullscreen(mode)
  Yoko::Window.fullscreen = mode
end

def set_mouse_cursor(filename)
  Yoko::Input::Mouse.cursor = load_sprite(filename)
end

def key_pressed?(scancode_name)
  Yoko::Input::Keyboard.key_pressed? scancode_name
end

def mouse_button_pressed?(button_name)
  Yoko::Input::Mouse.button_pressed? button_name
end

def load_sprite(filename, options = {})
  Yoko::Sprite.new(filename, options)
end

def window
  Yoko::Config::Window
end

def mouse
  Yoko::Input::Mouse
end

# Callbacks

def config(&block)
  Yoko.config(&block)
end

def load(&block)
  Yoko.load(&block)
end

def update(&block)
  Yoko.update(&block)
end

def draw(&block)
  Yoko.draw(&block)
end

def quit(&block)
  Yoko.quit(&block)
end
