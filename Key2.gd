extends Area2D

signal key_picked

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "player":
		emit_signal("key_picked")

		# Diğer sahnedeki gibi: sesi Player'dan çaldır
		if body.has_method("play_key_pickup"):
			body.play_key_pickup()

		queue_free()
