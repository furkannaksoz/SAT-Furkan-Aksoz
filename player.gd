extends KinematicBody2D

var has_key = false
var speed = 100
var jump_force = -250
var gravity = 400
var velocity = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var sfx_walk = $SFX_Walk
onready var sfx_key = $SFX_Key
onready var sfx_door = $SFX_Door
onready var cam = $Camera2D  # 🎥 Kamera bağlantısı eklendi

func _ready():
	print("🎮 Player aktif — animasyon & ses sistemi başlatıldı")

	# 🎥 Kamera ayarları
	cam.current = true
	cam.smoothing_enabled = true
	cam.smoothing_speed = 5
	cam.zoom = Vector2(0.6, 0.6)     # Yakın görünüm
	cam.offset = Vector2(0, -50)     # Karakterin biraz üstüne hizalama
	print("📸 Kamera aktif: Yakın takip modu devrede.")

func _physics_process(delta):
	velocity.y += gravity * delta

	var moving = false
	
	# 🔹 Yürüyüş kontrolü
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		sprite.flip_h = false
		moving = true
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		sprite.flip_h = true
		moving = true
	else:
		velocity.x = 0

	# 🔹 Zıplama
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		sprite.play("jump")

	# 🔹 Animasyon & ses kontrolü
	if is_on_floor():
		if moving:
			if sprite.animation != "walk" or not sprite.is_playing():
				sprite.play("walk")  # ✅ Basılı tuttuğunda animasyon devam eder
			if not sfx_walk.playing:
				sfx_walk.play()
		else:
			if sprite.animation != "idle":
				sprite.play("idle")
			if sfx_walk.playing:
				sfx_walk.stop()
	else:
		if sprite.animation != "jump":
			sprite.play("jump")
		if sfx_walk.playing:
			sfx_walk.stop()

	velocity = move_and_slide(velocity, Vector2.UP)

# 🔑 Anahtar alma sesi
func play_key_pickup():
	sfx_key.play()
	yield(get_tree().create_timer(1.5), "timeout")  # 1.5 saniye sonra
	sfx_key.stop()

# 🚪 Kapı sesi
func play_door_open():
	if not sfx_door.playing:
		sfx_door.play()
