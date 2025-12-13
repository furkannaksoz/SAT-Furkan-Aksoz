extends KinematicBody2D

signal ally_rescued          # Level2'ye "kız kurtarıldı" haberi

export var chase_speed = 100          # Kızın sağa–sola koşma hızı
export var stop_distance = 20         # X ekseninde bu kadar yakına gelince durur

var player = null
var is_chasing = false
var velocity = Vector2.ZERO
var rescued = false                    # Bu bir kere true olacak


func _ready():
	print("👧 Kız hazır, detection alanı aktif.")
	# Sinyaller editörden bağlanıyor, burada extra connect yok.


func _physics_process(_delta):
	if not is_chasing or player == null or not is_instance_valid(player):
		return

	# SADECE X EKSENİNDE TAKİP (uçma yok)
	var dx = player.global_position.x - global_position.x
	var adx = abs(dx)

	if adx <= stop_distance:
		velocity.x = 0
	else:
		var dir_x = sign(dx)                 # -1 = sola, +1 = sağa (kaçış yönü)
		velocity.x = -dir_x * chase_speed    # 🔁 ters çevir → TAKİP

	velocity.y = 0                          # Yukarı/aşağı hareket yok
	velocity = move_and_slide(velocity, Vector2.UP)

	# Sprite yönü
	if velocity.x > 0:
		if has_node("Sprite"):
			$Sprite.flip_h = false
	elif velocity.x < 0:
		if has_node("Sprite"):
			$Sprite.flip_h = true


func _on_DetectionArea_body_entered(body):
	if body.name == "player" or body.name == "Player":
		player = body
		is_chasing = true
		print("👧 Kız: Player menzile girdi → TAKİP BAŞLADI!")

		if not rescued:
			rescued = true
			emit_signal("ally_rescued")
			print("👧 Kız: ally_rescued sinyali gönderildi.")


func _on_DetectionArea_body_exited(body):
	if body == player:
		is_chasing = false
		player = null
		velocity = Vector2.ZERO
		print("👧 Kız: Player menzilden çıktı → DURDU.")
