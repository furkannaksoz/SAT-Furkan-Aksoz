extends Area2D

signal exit_triggered

func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body.name == "player":
		emit_signal("exit_triggered")


func open():
	# Kapıyı aç: collision kapat, görünmez yap
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true

	if has_node("Sprite"):
		$Sprite.hide()
