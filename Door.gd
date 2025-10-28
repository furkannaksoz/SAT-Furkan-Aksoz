extends Area2D

export(String) var next_scene_path = "res://Level2.tscn"  # Geçiş yapılacak sahne

func _ready():
	# Eğer sinyal manuel bağlıysa gerek yok ama güvenlik için kontrolü bırakıyoruz
	if not is_connected("body_entered", self, "_on_Door_body_entered"):
		connect("body_entered", self, "_on_Door_body_entered")

func _on_Door_body_entered(body):
	if body.name == "Player" and body.has_key:
		print("Anahtar var, kapı açılıyor...")
		if body.has_method("play_door_open"):
			body.play_door_open()  # Kapı sesi çal
		yield(get_tree().create_timer(0.7), "timeout")  # Ses tam çalsın
		get_tree().change_scene(next_scene_path)
	else:
		print("Oyuncu değil ya da anahtar yok.")
