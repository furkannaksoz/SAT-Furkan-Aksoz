extends KinematicBody2D

export var chase_speed = 90
export var detection_range = 350
export var damage = 1

onready var sprite = $AnimatedSprite
onready var detection_area = $DetectionArea
onready var damage_area = $DamageArea

var player = null
var is_chasing = false
var flip_cooldown = 0.0

func _ready():
	# sinyalleri güvenli bağla
	if not detection_area.is_connected("body_entered", self, "_on_DetectionArea_body_entered"):
		detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
	if not detection_area.is_connected("body_exited", self, "_on_DetectionArea_body_exited"):
		detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	if not damage_area.is_connected("body_entered", self, "_on_DamageArea_body_entered"):
		damage_area.connect("body_entered", self, "_on_DamageArea_body_entered")

	print("🐺 Kurt sahnede, devriyeye hazır.")

func _physics_process(delta):
	if flip_cooldown > 0:
		flip_cooldown -= delta

	# eğer player varsa ve sahnede geçerliyse
	if player and is_instance_valid(player):
		var dist = player.position.x - position.x
		var abs_dist = abs(dist)
		is_chasing = abs_dist <= detection_range

		if is_chasing:
			# 🔹 Kovalama hareketi (artık doğru yöne koşacak)
			var dir = sign(dist)
			position.x -= dir * chase_speed * delta  # 🔁 burada “+” yerine “–” kullanıyoruz

			# 🔹 Sprite yönü — orijinali sağa bakan kurtlar için düz mantık
			if flip_cooldown <= 0:
				var should_face_right = player.position.x > position.x
				sprite.flip_h = not should_face_right  # ters mantığı düzelt
				flip_cooldown = 0.3

			# 🔹 Hitbox’ları yönle hizala
			_update_hitboxes()

			# 🔹 Koşu animasyonu
			if sprite.frames and sprite.frames.has_animation("run"):
				if sprite.animation != "run":
					sprite.play("run")
		else:
			# 🔹 Oyuncu menzilden çıkınca idle animasyonu
			if sprite.frames and sprite.frames.has_animation("idle"):
				if sprite.animation != "idle":
					sprite.play("idle")
	else:
		# 🔹 Kurt bekleme modunda (player yok)
		if sprite.frames and sprite.frames.has_animation("idle"):
			if sprite.animation != "idle":
				sprite.play("idle")


# 🎯 Hitbox yönleri
func _update_hitboxes():
	var detect_pos = 60
	var damage_pos = 28

	if sprite.flip_h:
		detection_area.position.x = -detect_pos
		damage_area.position.x = -damage_pos
	else:
		detection_area.position.x = detect_pos
		damage_area.position.x = damage_pos


# 👁️ Oyuncuyu gör
func _on_DetectionArea_body_entered(body):
	if body.name != "Player":
		return
	print("🐺 Oyuncu algılandı, kovalamaya başladı!")
	player = body
	is_chasing = true


# 👀 Oyuncu uzaklaşırsa
func _on_DetectionArea_body_exited(body):
	if body.name != "Player":
		return
	print("👀 Oyuncu menzilden çıktı, kurt beklemeye geçti.")
	if body == player:
		player = null
		is_chasing = false


# 💥 Temas anında ölüm
func _on_DamageArea_body_entered(body):
	if body == null:
		return
	if body == player or body.has_method("take_damage"):
		print("💥 Kurt oyuncuya saldırdı! Oyun resetleniyor...")
		if body.has_method("take_damage"):
			body.take_damage(damage)
		else:
			get_tree().reload_current_scene()
