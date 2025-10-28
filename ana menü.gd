extends Control

onready var settings_panel = $SettingsPanel
onready var play_btn = $play
onready var exit_btn = $exit
onready var settings_btn = $Settings
onready var ambience = $Ambience
onready var music_slider = $SettingsPanel/MusicSlider
onready var sfx_slider = $SettingsPanel/SfxSlider
onready var fullscreen_check = $SettingsPanel/FullscreenCheck

func _ready():
	# ─────────────────────────────
	# 🌌 Arka Plan (Degrade efektli)
	# ─────────────────────────────
	var bg = TextureRect.new()
	bg.expand = true
	bg.stretch_mode = TextureRect.STRETCH_SCALE_ON_EXPAND
	bg.texture = _make_vertical_gradient_tex(
		Color(0.20, 0.40, 0.65),
		Color(0.10, 0.30, 0.55),
		Color(0.05, 0.15, 0.35),
		512
	)
	add_child(bg)
	move_child(bg, 0)
	bg.anchor_left = 0
	bg.anchor_top = 0
	bg.anchor_right = 1
	bg.anchor_bottom = 1
	bg.margin_left = 0
	bg.margin_top = 0
	bg.margin_right = 0
	bg.margin_bottom = 0
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# ❄️ Kar Efekti
	var snow = Particles2D.new()
	var mat = ParticlesMaterial.new()
	mat.gravity = Vector3(0, 45, 0)
	mat.initial_velocity = 22
	mat.direction = Vector3(0, 1, 0)
	mat.spread = PI / 2
	mat.scale = 0.45
	mat.scale_random = 0.4
	mat.color = Color(1, 1, 1, 0.75)
	mat.emission_shape = ParticlesMaterial.EMISSION_SHAPE_BOX
	mat.emission_box_extents = Vector3(960, 540, 0)
	snow.process_material = mat
	snow.amount = 150
	snow.lifetime = 3.8
	snow.speed_scale = 1.1
	snow.emitting = true
	add_child(snow)
	move_child(snow, 1)

	# ─────────────────────────────
	# 🎮 Başlık ve Butonlar
	# ─────────────────────────────
	var title = $Label
	title.text = "❄️  DONUK YOLCULUK ❄️"
	title.add_color_override("font_color", Color(0.9, 0.98, 1))
	title.add_color_override("font_outline_color", Color(0.5, 0.85, 1))
	title.add_constant_override("outline_size", 4)
	title.set("custom_constants/shadow_offset_x", 3)
	title.set("custom_constants/shadow_offset_y", 3)
	title.set("custom_constants/shadow_as_outline", true)
	title.rect_size = Vector2(get_viewport_rect().size.x, 120)
	title.align = Label.ALIGN_CENTER
	title.valign = Label.VALIGN_CENTER
	title.rect_position = Vector2(0, 80)
	title.autowrap = false

	var tw = Tween.new()
	add_child(tw)
	tw.interpolate_property(title, "modulate",
		Color(1, 1, 1, 0.75), Color(1, 1, 1, 1.0),
		1.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tw.interpolate_property(title, "modulate",
		Color(1, 1, 1, 1.0), Color(1, 1, 1, 0.75),
		1.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 1.8)
	tw.start()

	# ─────────────────────────────
	# 🧊 Butonlar
	# ─────────────────────────────
	var sb_normal  = _make_style(Color(0.18, 0.38, 0.55), Color(0.65, 0.9, 1))
	var sb_hover   = _make_style(Color(0.26, 0.55, 0.75), Color(0.75, 0.95, 1))
	var sb_pressed = _make_style(Color(0.14, 0.45, 0.65), Color(0.85, 0.98, 1))

	var buttons = [play_btn, settings_btn, exit_btn]
	for btn in buttons:
		btn.rect_min_size = Vector2(280, 85)
		btn.add_stylebox_override("normal", sb_normal)
		btn.add_stylebox_override("hover", sb_hover)
		btn.add_stylebox_override("pressed", sb_pressed)
		btn.add_stylebox_override("focus", sb_hover)
		btn.add_color_override("font_color", Color(0.96, 0.99, 1))
		btn.add_color_override("font_color_hover", Color(0.82, 0.96, 1))

	# Konumlar
	play_btn.rect_position = Vector2(780, 460)
	settings_btn.rect_position = Vector2(780, 520)
	exit_btn.rect_position = Vector2(780, 590)

	# ─────────────────────────────
	# 🎵 Ambience (arka plan müziği)
	# ─────────────────────────────
	if ambience:
		if ambience.stream:
			var stream = ambience.stream
			if stream is AudioStream:
				stream.loop = true
				ambience.stream = stream
		ambience.volume_db = 0
		ambience.play()

	# ─────────────────────────────
	# ⚙️ Settings Panel
	# ─────────────────────────────
	settings_panel.visible = false
	settings_panel.modulate.a = 0.0

	# Slider ve CheckBox bağlantıları
	music_slider.connect("value_changed", self, "_on_music_volume_changed")
	sfx_slider.connect("value_changed", self, "_on_sfx_volume_changed")
	fullscreen_check.connect("toggled", self, "_on_fullscreen_toggled")

	# Buton sinyalleri
	play_btn.connect("pressed", self, "_on_play_button_pressed")
	exit_btn.connect("pressed", self, "_on_exit_button_pressed")
	settings_btn.connect("pressed", self, "_on_settings_button_pressed")

	var close_btn = settings_panel.get_node("CloseBtn")
	close_btn.connect("pressed", self, "_on_close_settings_pressed")



# 🔹 StyleBoxFlat oluşturucu
func _make_style(bg_col: Color, border_col: Color) -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = bg_col
	sb.border_color = border_col
	sb.set_border_width_all(2)
	sb.corner_radius_top_left = 14
	sb.corner_radius_top_right = 14
	sb.corner_radius_bottom_left = 14
	sb.corner_radius_bottom_right = 14
	sb.content_margin_left = 18
	sb.content_margin_right = 18
	sb.content_margin_top = 12
	sb.content_margin_bottom = 12
	return sb


# 🔹 Dikey gradient texture üretici
func _make_vertical_gradient_tex(top_col: Color, mid_col: Color, bottom_col: Color, height := 512) -> ImageTexture:
	var img = Image.new()
	img.create(1, height, false, Image.FORMAT_RGBA8)
	img.lock()
	for y in range(height):
		var t = float(y) / float(max(1, height - 1))
		var col := Color()
		if t < 0.5:
			var k = t / 0.5
			col = top_col.linear_interpolate(mid_col, k)
		else:
			var k2 = (t - 0.5) / 0.5
			col = mid_col.linear_interpolate(bottom_col, k2)
		img.set_pixel(0, y, col)
	img.unlock()
	var tex = ImageTexture.new()
	tex.create_from_image(img, Texture.FLAG_FILTER)
	return tex


# 🎮 Play
func _on_play_button_pressed():
	get_tree().change_scene("res://Main.tscn")


# ❌ Exit
func _on_exit_button_pressed():
	get_tree().quit()


# ⚙️ Settings açma
func _on_settings_button_pressed():
	settings_panel.visible = true
	var tween = create_tween()
	tween.tween_property(settings_panel, "modulate:a", 1.0, 0.3)


# ↩️ Settings kapama
func _on_close_settings_pressed():
	var tween = create_tween()
	tween.tween_property(settings_panel, "modulate:a", 0.0, 0.3)
	yield(tween, "finished")
	settings_panel.visible = false


# 🎚️ Müzik sesi ayarı
func _on_music_volume_changed(value):
	if ambience:
		ambience.volume_db = lerp(-40, 0, value / 100.0)  # 0–100 arası slider -> dB


# 🎚️ Efekt sesi ayarı
func _on_sfx_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), lerp(-40, 0, value / 100.0))


# 🖥️ Tam ekran
func _on_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
