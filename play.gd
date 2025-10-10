extends Button

	


signal key_collected

func _on_Area2D_body_entered(body):
	if body.name == "Player":  # Karakterin adı "Player" ise
		emit_signal("key_collected")
		queue_free()  # Anahtarı sahneden kaldır


func _on_play_pressed():
	get_tree().change_scene("res://Main.tscn")  
	pass 
