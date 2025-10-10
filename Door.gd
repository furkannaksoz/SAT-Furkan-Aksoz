extends Area2D

export(String) var next_scene_path = "res://Level2.tscn"  # Geçiş yapılacak sahne

func _ready():
	# Editörden sinyal bağladıysan buraya connect yazmana gerek yok,
	# ama yazarsan sorun olmaz:
	# connect("body_entered", self, "_on_Door_body_entered")
	pass

func _on_Door_body_entered(body):
	if body.name == "Player" and body.has_key:
		print("Anahtar var, sahne değiştiriliyor...")
		get_tree().change_scene(next_scene_path)
	else:
		print("Oyuncu değil ya da anahtar yok.")
