player = nil
$bullets = []
$enemies = []

$can_shoot = true

class Player
  attr_accessor :player, :cannon, :max_speed

  def initialize
    @scale = 0.5
    @player = load_sprite('tank.png', center_x: center_x, center_y: center_y, scale: @scale)
    @cannon = load_sprite('cannon.png', center_x: center_x, center_y: center_y, scale: @scale)
    @player.x = window.width / 2 - @player.width / 2
    @player.y = window.height / 2 - @player.height / 2
    @cannon.follow(:x, @player)
    @cannon.follow(:y, @player)
    @max_speed = 2
    @speed = 0
    @direction = 0
    @acceleration = 0.05
  end

  def x
    player.x
  end

  def y
    player.y
  end

  def cannon_lenght
    90 * @scale
  end

  def center_x
    43 * @scale
  end

  def center_y
    93 / 2
  end

  def update
    cannon.angle = point_direction(cannon, mouse.cursor)

    if key_pressed?(:d)
      @direction += (speed / max_speed)
    end

    if key_pressed?(:a)
      @direction -= (speed / max_speed)
    end

    if key_pressed?(:s) && @speed > -max_speed
      @speed -= @acceleration
    elsif key_pressed?(:w) && @speed < max_speed
      @speed += @acceleration
    else
      if @speed > @acceleration
        @speed -= @acceleration * 2
      elsif speed < -@acceleration
        @speed += @acceleration * 2
      else
        @speed = 0
      end
    end

    player.move(@speed, @direction - 90) if @speed != 0
    player.angle = @direction

    cannon.x = player.x
    cannon.y = player.y

    manage_bullets
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

  def max_speed
    @max_speed
  end

  def speed
    @speed
  end

  def speed=(new_speed)
    @speed = new_speed
  end

  def max_speed
    @max_speed
  end

  def direction
    @direction
  end

  def direction=(new_direction)
    @direction = new_direction
  end

  private

  def manage_bullets
    $bullets.each{ |b| b.bullet.visible?(window) ? b.bullet.destroy : "" }
    $bullets.select!{ |b| b.bullet.visible?(window) }
    if mouse_button_pressed?(:left)
      if $can_shoot
        bullet = Bullet.new(
          self,
          point_direction(player, mouse.cursor)
        )
        $bullets << bullet
        $can_shoot = false
      end
    else
      $can_shoot = true
    end

    $bullets.each do |bullet|
      $enemies.each do |enemy|
        if bullet.bullet.collides_with? enemy.enemy
          enemy.enemy.scale = 0
          enemy.enemy.x = -9999
          enemy.enemy.y = -9999
          bullet.bullet.scale = 0
        end
      end
    end

    $enemies.each{ |e| e.enemy.visible?(window) ? e.enemy.destroy : "" }
    $enemies.select!{ |e| e.enemy.visible?(window) }
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
    bullet.animate_infinite(:x, speed * Math.cos(@move_angle * Math::PI / 180))
    bullet.animate_infinite(:y, speed * Math.sin(@move_angle * Math::PI / 180))
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
    $enemies << Enemy.new
  end
end

update do
  player.update

  if $enemies.size == 0
    (rand(10) + 10).times do
      $enemies << Enemy.new
    end
  end

  quit if key_pressed? :escape
end

draw do
  player.draw
  $bullets.each(&:draw)
   $enemies.each(&:draw)
end

quit do
  puts 'Closing our rotating square example!'
end

Yoko.loop
