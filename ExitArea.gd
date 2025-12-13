extends Area2D

# Level2'nin has_key ve ally_rescued değişkenlerine erişeceğiz
var level = null


func _ready():
	level = get_tree().current_scene  # aktif sahne = Level2

	if not is_connected("body_entered", self, "_on_body_entered"):
		connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name != "player" and body.name != "Player":
		return

	print("IgloDoor2: player kapıya girdi.")

	if level == null:
		print("HATA: Level sahnesi bulunamadı!")
		return

	# 1) Anahtar kontrolü
	var has_key = false
	if level.has("has_key"):
		has_key = level.has_key

	if not has_key:
		print("Önce anahtarı almalısın!")
		return

	# 2) Kız gerçekten kurtarıldı mı? (flag + mesafe fallback)
	var rescued_flag = false
	if level.has("ally_rescued"):
		rescued_flag = level.ally_rescued

	var close_enough = false
	if level.has_node("RescuedAlly") and level.has_node("player"):
		var ally = level.get_node("RescuedAlly")
		var player = level.get_node("player")
		var dist = ally.global_position.distance_to(player.global_position)
		print("Kapı: kız-player mesafe =", dist)
		if dist < 150: # kız yanında saymak için tolerans
			close_enough = true

	if not rescued_flag and not close_enough:
		print("Önce kızı kurtarman gerekiyor!")
		return

	# 3) Her şey tamam → oyun bitsin
	print("LEVEL BİTTİ!")
	open()
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
