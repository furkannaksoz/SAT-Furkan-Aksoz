extends Control


func _on_play_button_pressed():
	# Oyunun ana sahnesine geçiş
	get_tree().change_scene("res://scenes/Main.tscn")  # Main.tscn dosya yolunu doğru yazın

func _on_exit_button_pressed():
	# Oyundan çıkış
	get_tree().quit()
