extends Area2D

var level = null
onready var door_sfx = null  # <-- SES EKLENDİ


func _ready():
	# Şu an aktif olan sahne (Level2)
	level = get_tree().current_scene

	# SES EKLENDİ
	if has_node("Door"):
		door_sfx = $Door

	if not is_connected("body_entered", self, "_on_body_entered"):
		connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body.name != "player" and body.name != "Player":
		return

	print("IgloDoor2: player kapıya girdi.")

	if level == null:
		print("HATA: Level sahnesi bulunamadı!")
		return

	# --- ANAHTAR KONTROLÜ ---
	var has_key = level.get("has_key")
	if has_key == null or not has_key:
		print("Önce anahtarı almalısın!")
		return

	# --- KIZ KURTARILDI MI? (flag + mesafe fallback) ---
	var rescued_flag = false
	var ally_rescued_val = level.get("ally_rescued")
	if ally_rescued_val != null and ally_rescued_val:
		rescued_flag = true

	var close_enough = false
	if level.has_node("RescuedAlly") and level.has_node("player"):
		var ally_node = level.get_node("RescuedAlly")
		var player_node = level.get_node("player")
		var dist = ally_node.global_position.distance_to(player_node.global_position)
		print("Kapı: kız-player mesafe =", dist)
		if dist < 150:
			close_enough = true

	if not rescued_flag and not close_enough:
		print("Önce kızı kurtarman gerekiyor!")
		return

	# --- HER ŞEY TAMAM → OYUN BİTSİN ---
	print("LEVEL BİTTİ!")
	open()

	# SES EKLENDİ: Oyun kapanmadan sesi duyur
	if door_sfx and door_sfx.stream:
		door_sfx.play()
		yield(get_tree().create_timer(0.7), "timeout")

	get_tree().quit()


func open():
	print("IgloDoor2.open çağrıldı")

	# Üst StaticBody2D (IgloDoor2) çarpışmasını kapat
	var parent = get_parent()
	if parent and parent.has_node("CollisionShape2D"):
		parent.get_node("CollisionShape2D").set_deferred("disabled", true)

	# Üstteki Sprite'ı gizle
	if parent and parent.has_node("Sprite"):
		parent.get_node("Sprite").hide()

	# ExitArea'nın kendi tetik alanını kapat
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
