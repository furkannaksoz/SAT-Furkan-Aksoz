extends Node2D

onready var tilemap      = $TileMap
onready var player       = $player
onready var key_node     = $Key2
onready var ally         = $RescuedAlly
onready var rescue_door  = $IgloDoor3     # Kızın kapısı (Area2D)

var has_key = false           # Anahtar alındı mı?
var ally_rescued = false      # Kız gerçekten kurtarıldı mı?


func _ready():
	# Anahtar sinyali
	if key_node and key_node.has_signal("key_picked") \
	and not key_node.is_connected("key_picked", self, "_on_key_picked"):
		key_node.connect("key_picked", self, "_on_key_picked")
	else:
		print("UYARI: Key2 ya da 'key_picked' sinyali yok / bağlanamadı!")

	# Kızın kapısı sinyali (sadece debug için)
	if rescue_door and rescue_door.has_signal("rescue_triggered") \
	and not rescue_door.is_connected("rescue_triggered", self, "_on_rescue_door_entered"):
		rescue_door.connect("rescue_triggered", self, "_on_rescue_door_entered")
	else:
		print("UYARI: IgloDoor3 ya da 'rescue_triggered' sinyali yok / bağlanamadı!")

	# Kızın "kurtarıldı" sinyali (RescuedAlly.gd'den)
	if ally and ally.has_signal("ally_rescued") \
	and not ally.is_connected("ally_rescued", self, "_on_ally_rescued"):
		ally.connect("ally_rescued", self, "_on_ally_rescued")
	else:
		print("UYARI: RescuedAlly ya da 'ally_rescued' sinyali yok / bağlanamadı!")


func _on_key_picked():
	has_key = true
	print("Anahtar alındı!")

	# Anahtar alınınca kızın kapısını aç
	if rescue_door and rescue_door.has_method("open"):
		print("Level2: kız kapısına open() çağırıyorum.")
		rescue_door.call_deferred("open")
	else:
		print("HATA: rescue_door yok veya open() fonksiyonu tanımlı değil!")


func _on_rescue_door_entered(body):
	print("Kurtarma kapısına girildi, body:", body)


func _on_ally_rescued():
	ally_rescued = true
	print("Level2: ally_rescued = TRUE (kız resmen kurtarıldı).")


