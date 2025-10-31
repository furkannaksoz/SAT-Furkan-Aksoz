extends KinematicBody2D

# --- Ayarlar (Godot 3.6 sözdizimi) ---
export var chase_speed = 150
export var detection_range = 340
export var damage = 1
export var art_faces_right = true  # Sprite orijinali SAĞA bakıyorsa true, SOLA bakıyorsa false

onready var sprite = $AnimatedSprite
onready var detection_area = $DetectionArea
onready var damage_area = $DamageArea

var player = null
var is_chasing = false
var flip_cooldown = 0.0

func _ready():
	if not detection_area.is_connected("body_entered", self, "_on_DetectionArea_body_entered"):
		detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
	if not detection_area.is_connected("body_exited", self, "_on_DetectionArea_body_exited"):
		detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	if not damage_area.is_connected("body_entered", self, "_on_DamageArea_body_entered"):
		damage_area.connect("body_entered", self, "_on_DamageArea_body_entered")

func _physics_process(delta):
	if flip_cooldown > 0:
		fip_cooldown_step(delta)

	if player and is_instance_valid(player):
		var dist_x = player.position.x - position.x
		var abs_dist = abs(dist_x)
		is_chasing = abs_dist <= detection_range

		if is_chasing:
			var dir = sign(dist_x)               # player sağdaysa +1, soldaysa -1
			position.x += dir * chase_speed * delta

			# --- Doğru yöne dön ---
			if flip_cooldown <= 0.0:
				if art_faces_right:
					sprite.flip_h = (dir < 0)  # orijinal sağa bakıyorsa: sola dönmek için flip_h true
				else:
					sprite.flip_h = (dir > 0)    # orijinal sola bakıyorsa ters kural
				flip_cooldown = 0.25

			_update_hitboxes()

			if sprite.frames and sprite.frames.has_animation("run"):
				if sprite.animation != "run":
					sprite.play("run")
		else:
			_play_idle()
	else:
		_play_idle()

func fip_cooldown_step(delta):
	flip_cooldown -= delta
	if flip_cooldown < 0.0:
		flip_cooldown = 0.0

# İleri yön ve hitbox hizalama (Godot 3.6 uyumlu)
func _forward_sign():
	# flip_h true → görüntü SOLA dönük.
	# art_faces_right true ise: ileri = (flip_h ? -1 : 1)
	# art_faces_right false ise: ileri = (flip_h ?  1 : -1)
	var f = -1 if sprite.flip_h else 1  # <-- burada artık ':' yok, 3.x üçlü operatör bu şekilde
	if not art_faces_right:
		f = -f
	return f

func _update_hitboxes():
	var forward = _forward_sign()
	var detect_pos = 55   # DetectionArea burnun biraz önünde
	var damage_pos = 18   # DamageArea çok yakın temas

	detection_area.position.x = forward * detect_pos
	damage_area.position.x    = forward * damage_pos

func _play_idle():
	if sprite.frames and sprite.frames.has_animation("idle"):
		if sprite.animation != "idle":
			sprite.play("idle")

# Sadece Player’ı kovala
func _on_DetectionArea_body_entered(body):
	if body.name != "Player":
		return
	player = body
	is_chasing = true

func _on_DetectionArea_body_exited(body):
	if body.name != "Player":
		return
	if body == player:
		player = null
		is_chasing = false

# Gerçek temasta öldür
func _on_DamageArea_body_entered(body):
	if body and body.name == "Player":
		get_tree().reload_current_scene()
