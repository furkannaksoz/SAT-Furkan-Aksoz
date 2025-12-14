extends KinematicBody2D

# ================== HAREKET & TEMPO ==================
export var chase_speed := 55          # koşu hızı (kaçılabilir)
export var gravity := 900

export var stop_distance := 70         # çok yaklaşınca dur
export var slow_distance := 180        # yaklaşırken yavaşlama başlasın

# ================== SALDIRI AYARLARI ==================
export var attack_cooldown := 1.75  # saldırı arası bekleme
export var attack_windup := 0.50   # saldırı hazırlık (telegraph)
export var kill_delay := 0.25          # animasyon sonrası ölüm

# ================== HITBOX OFFSET ==================
export var detection_offset_x := 90
export var damage_offset_x := 55

export var debug_logs := false

# ✅ TITREME FIX: yön değiştirme eşiği (histerezis)
export var turn_threshold := 24.0  # 20-35 arası deneyebilirsin

# ================== NODELAR ==================
onready var sprite: AnimatedSprite = $AnimatedSprite
onready var detection_area: Area2D = $DetectionArea
onready var damage_area: Area2D = $DamageArea
onready var kill_timer: Timer = $KillTimer

# ================== STATE ==================
var player: Node = null
var is_chasing := false
var vel := Vector2.ZERO

var flip_cooldown := 0.0
var attack_cd := 0.0
var pending_kill := false

# ✅ golem’in “kilitli” baktığı yön (+1 sağ, -1 sol)
var facing_dir := 1


func _ready():
	# sinyaller
	if not detection_area.is_connected("body_entered", self, "_on_DetectionArea_body_entered"):
		detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
	if not detection_area.is_connected("body_exited", self, "_on_DetectionArea_body_exited"):
		detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	if not damage_area.is_connected("body_entered", self, "_on_DamageArea_body_entered"):
		damage_area.connect("body_entered", self, "_on_DamageArea_body_entered")
	if not damage_area.is_connected("body_exited", self, "_on_DamageArea_body_exited"):
		damage_area.connect("body_exited", self, "_on_DamageArea_body_exited")
	if not kill_timer.is_connected("timeout", self, "_on_KillTimer_timeout"):
		kill_timer.connect("timeout", self, "_on_KillTimer_timeout")

	kill_timer.one_shot = true
	kill_timer.wait_time = attack_windup + kill_delay

	# başlangıç yönünü sprite’a göre senkronla
	facing_dir = -1 if sprite.flip_h else 1

	_update_hitboxes(false)
	_play_if_exists("idle")

	if debug_logs:
		print("[GOLEM] Ready")


func _physics_process(delta):
	# cooldownlar
	if attack_cd > 0:
		attack_cd -= delta
	if flip_cooldown > 0:
		flip_cooldown -= delta

	# yerçekimi
	vel.y += gravity * delta

	# ölüm animasyonu oynuyorsa sabit dur
	if pending_kill:
		vel.x = 0
		vel = move_and_slide(vel, Vector2.UP)
		return

	# player referansı
	if player and not is_instance_valid(player):
		player = null
		is_chasing = false

	if player == null:
		player = _find_player()
		if player == null:
			vel.x = 0
			_play_if_exists("idle")
			vel = move_and_slide(vel, Vector2.UP)
			return

	if is_chasing:
		var px = player.global_position.x
		var gx = global_position.x
		var dx = px - gx
		var dist = abs(dx)

		# ✅ SCHMITT TRIGGER: bant içinde yön DEĞİŞTİRME
		# player sağda iyice belirginleşirse sağa, solda belirginleşirse sola, yoksa yön sabit.
		if dx > turn_threshold:
			facing_dir = 1
		elif dx < -turn_threshold:
			facing_dir = -1
		# else: facing_dir değişmez (titreme biter)

		sprite.flip_h = (facing_dir < 0)

		# normal takip (yaklaştıkça yavaşla, dibine girince dur)
		if dist <= stop_distance:
			vel.x = 0
		else:
			var slow_factor = clamp((dist - stop_distance) / slow_distance, 0.35, 1.0)
			vel.x = facing_dir * chase_speed * slow_factor

		_update_hitboxes(true)
		_play_if_exists("move")
	else:
		vel.x = 0
		_update_hitboxes(false)
		_play_if_exists("idle")

	vel = move_and_slide(vel, Vector2.UP)


# ================== HITBOX YÖNETİMİ ==================
func _update_hitboxes(active: bool):
	if not active:
		detection_area.position.x = 0
		damage_area.position.x = 0
		return

	if sprite.flip_h:
		detection_area.position.x = -detection_offset_x
		damage_area.position.x = -damage_offset_x
	else:
		detection_area.position.x = detection_offset_x
		damage_area.position.x = damage_offset_x


# ================== DETECTION ==================
func _on_DetectionArea_body_entered(body):
	if body == null:
		return
	if body != _find_player():
		return

	player = body
	is_chasing = true

	if debug_logs:
		print("[GOLEM] Player detected")


func _on_DetectionArea_body_exited(body):
	if body != player:
		return

	player = null
	is_chasing = false

	if debug_logs:
		print("[GOLEM] Player left")


# ================== DAMAGE / SALDIRI ==================
func _on_DamageArea_body_entered(body):
	if body == null:
		return
	if pending_kill or attack_cd > 0:
		return

	var p = _find_player()
	if body != p:
		return

	# saldırı başlat
	pending_kill = true
	is_chasing = false
	vel.x = 0

	_play_if_exists("attack")

	attack_cd = attack_cooldown
	kill_timer.start()

	if debug_logs:
		print("[GOLEM] ATTACK STARTED")


func _on_DamageArea_body_exited(body):
	if body != _find_player():
		return

	if pending_kill:
		pending_kill = false
		if not kill_timer.is_stopped():
			kill_timer.stop()

		is_chasing = true
		_play_if_exists("move")

		if debug_logs:
			print("[GOLEM] ATTACK CANCELED (player escaped)")


func _on_KillTimer_timeout():
	# oyuncu kaçtıysa öldürme
	if player == null:
		pending_kill = false
		is_chasing = true
		return

	# DamageArea içinde değilse öldürme
	if not damage_area.get_overlapping_bodies().has(player):
		pending_kill = false
		is_chasing = true
		return

	get_tree().reload_current_scene()


# ================== HELPERS ==================
func _find_player():
	var root = get_tree().current_scene
	if root == null:
		return null

	var p = root.get_node_or_null("player")
	if p != null:
		return p
	return root.get_node_or_null("Level2/player")


func _play_if_exists(anim_name: String):
	if sprite and sprite.frames and sprite.frames.has_animation(anim_name):
		if sprite.animation != anim_name:
			sprite.play(anim_name)
