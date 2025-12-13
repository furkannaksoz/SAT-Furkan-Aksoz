extends Area2D

signal rescue_triggered

onready var door_sfx = null
var is_opened := false
var sound_played := false

func _ready():
	if has_node("Door"):
		door_sfx = $Door

	if not is_connected("body_entered", self, "_on_body_entered"):
		connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	# SADECE PLAYER GEÇİNCE
	if body.name != "player" and body.name != "Player":
		emit_signal("rescue_triggered", body)
		return

	# Kapı açıldıktan sonra geçince 1 kere ses
	if is_opened and not sound_played and door_sfx and door_sfx.stream:
		sound_played = true

		# Loop'u zorla kapat (Stream tipine göre güvenli)
		door_sfx.stream.set("loop", false)
		door_sfx.stream.set("loop_mode", 0) # bazı streamlerde işe yarar

		door_sfx.stop()
		door_sfx.play()

		# 1 kere tetiklensin diye sonra alanı kapat
		if has_node("CollisionShape2D"):
			$CollisionShape2D.set_deferred("disabled", true)

	emit_signal("rescue_triggered", body)

func open():
	print("IgloDoor3.open çağrıldı")
	is_opened = true

	if has_node("Blocker/CollisionShape2D"):
		$Blocker/CollisionShape2D.set_deferred("disabled", true)

	if has_node("Sprite"):
		$Sprite.hide()
