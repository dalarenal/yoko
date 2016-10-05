player = nil
can_shoot = true

class Player
  attr_accessor :player, :cannon, :speed

  def initialize
    @player = load_sprite('tank.png', center_x: center_x, center_y: center_y)
    @cannon = load_sprite('cannon.png', center_x: center_x, center_y: center_y)
    @player.x = window.width / 2 - @player.width / 2
    @player.y = window.height / 2 - @player.height / 2
    @cannon.x = @player.x
    @cannon.y = @player.y
    @speed = 2
  end

  def x
    player.x
  end

  def y
    player.y
  end

  def cannon_lenght
    90
  end

  def center_x
    43
  end

  def center_y
    93
  end

  def update
    cannon.angle = point_direction(cannon, mouse.cursor)
    angles = []

    if key_pressed?(:d) && (player.x + player.width) < window.width
      player.x += speed
      angles << 90
    end

    if key_pressed?(:a) && player.x > 0
      player.x -= speed
      angles << 270
    end

    if key_pressed?(:s) && (player.y + player.height) < window.height
      player.y += speed
      angles << 180
    end

    if key_pressed?(:w) && player.y > -20
      player.y -= speed
      if angles.include? 270
        angles << 360
      else
        angles << 0
      end
    end

    if angles.any?
      player.angle = angles.inject(:+) / angles.size
    end

    cannon.x = player.x
    cannon.y = player.y
  end

  def draw
    player.draw
    cannon.draw
  end

  def player
    @player
  end

  def cannon
    @cannon
  end

  def speed
    @speed
  end
end

class Bullet
  attr_accessor :bullet, :move_angle, :speed

  def initialize(origin_image, move_angle)
    @bullet = load_sprite('ball.png', scale: 0.1)
    @move_angle = move_angle - 90
    @bullet.x = origin_image.x + origin_image.center_x - @bullet.width / 2 + origin_image.cannon_lenght * Math.cos(@move_angle * Math::PI / 180)
    @bullet.y = origin_image.y + origin_image.center_y - @bullet.height / 2 + origin_image.cannon_lenght * Math.sin(@move_angle * Math::PI / 180)
    @speed = 9
  end

  def update
    bullet.move(@speed, @move_angle)
  end

  def draw
    bullet.draw
  end

  def bullet
    @bullet
  end
end

class Enemy
  attr_accessor :enemy

  def initialize
    @enemy = load_sprite('ball.png', scale: (rand(5) + 1) / 10.0)
    @enemy.x = rand(window.width)
    @enemy.y = rand(window.height)
    @enemy.animate_loop(:x, rand(window.width), rand(5000) + 5000)
    @enemy.animate_loop(:y, rand(window.height), rand(5000) + 5000)
  end

  def draw
    @enemy.draw
  end
end

bullets = []
enemies = []

config do |conf|
  conf.window.title = 'Rotating Square Example'
  conf.window.width = 1200
  conf.window.height = 900
  #conf.window.fullscreen = :exclusive # :desktop, :exclusive or :windowed (default)
end

load do
  player = Player.new
  mouse.cursor = load_sprite('ball.png', scale: 0.1)
  (rand(10) + 10).times do
    enemies << Enemy.new
  end
end

update do
  player.update

  if mouse_button_pressed?(:left)
    if can_shoot
      bullet = Bullet.new(
        player,
        point_direction(player.player, mouse.cursor)
      )
      bullets << bullet
      can_shoot = false
    end
  else
    can_shoot = true
  end

  bullets.each(&:update)

  bullets.each do |bullet|
    enemies.each do |enemy|
      if bullet.bullet.collides_with? enemy.enemy
        enemy.enemy.scale = 0
        bullet.bullet.scale = 0
      end
    end
  end

  quit if key_pressed? :escape
end

draw do
  player.draw
  bullets.each(&:draw)
  enemies.each(&:draw)
end

quit do
  puts 'Closing our rotating square example!'
end

Yoko.loop
