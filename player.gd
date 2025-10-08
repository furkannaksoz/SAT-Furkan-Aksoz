extends KinematicBody2D


var has_key = false  # Anahtar alındı mı?

# Buraya hareket kodlarını ekleyebilirsin


var speed = 100
var jump_force = -250
var gravity = 400
var velocity = Vector2.ZERO
onready var sprite = $Sprite  # player.tscn'de Sprite node'u

func _ready():
	print("Player hazır! Input map kontrol ediliyor...")
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == 65:
			print("A tuşuna basıldı")
		if event.scancode == 68:
			print("D tuşuna basıldı")
		if event.scancode == 87:
			print("W tuşuna basıldı")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	var right_input = Input.is_action_pressed("move_right")
	var left_input = Input.is_action_pressed("move_left")
	print("Right: ", right_input, " Left: ", left_input, " Velocity.x: ", velocity.x)
	
	if right_input and not left_input:  # Çakışmayı önle
		velocity.x = speed
		sprite.flip_h = false
		print("Sağa hareket: D basılı")
	elif left_input and not right_input:
		velocity.x = -speed
		sprite.flip_h = true
		print("Sola hareket: A basılı")
	else:
		velocity.x = 0
		print("Yatay input yok")
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		print("Zıplama: W basılı")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	print("Son Velocity: ", velocity, " | Position: ", position, " | is_on_floor: ", is_on_floor())
