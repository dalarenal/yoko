# Functions

def point_direction(origin_image, target_image)
  origin_center_x = origin_image.x + origin_image.width / 2
  origin_center_y = origin_image.y + origin_image.height / 2
  target_center_x = target_image.x + target_image.width / 2
  target_center_y = target_image.y + target_image.height / 2

  - Math.atan2(
    origin_center_x - target_center_x,
    origin_center_y - target_center_y
  ) * 180 / Math::PI
end

def set_fullscreen(mode)
  Yoko::Window.fullscreen = mode
end

def set_background_color(red, green, blue)
  Yoko::Renderer.set_draw_color(red, green, blue)
end

def set_mouse_cursor(filename, options = {})
  Yoko::Input::Mouse.cursor = load_sprite(filename, options)
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
