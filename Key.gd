extends Area2D

func _on_Key_body_entered(body):
	if body.name == "Player":
		body.has_key = true
		if body.has_method("play_key_pickup"):
			body.play_key_pickup()  # Anahtar alma sesi
		queue_free()
