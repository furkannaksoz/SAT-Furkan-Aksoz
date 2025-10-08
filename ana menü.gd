extends Control

func _ready():
	# ─────────────────────────────
	# 🌌 Arka Plan (Degrade efektli)
	# ─────────────────────────────
	var bg = TextureRect.new()
	bg.expand = true
	bg.stretch_mode = TextureRect.STRETCH_SCALE_ON_EXPAND
	bg.texture = _make_vertical_gradient_tex(
		Color(0.20, 0.40, 0.65),  # üst (açık mavi)
		Color(0.10, 0.30, 0.55),  # orta
		Color(0.05, 0.15, 0.35),  # alt
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

	# ❄️ Kar Efekti (Godot 3.6 uyumlu)
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
	var play_btn = $play
	var exit_btn = $exit

	# ✨ Başlık (tam yazı + şık görünüm)
	title.text = "❄️  DONUK YOLCULUK ❄️"
	title.add_color_override("font_color", Color(0.9, 0.98, 1))
	title.add_color_override("font_outline_color", Color(0.5, 0.85, 1))
	title.add_constant_override("outline_size", 4)
	title.set("custom_constants/shadow_offset_x", 3)
	title.set("custom_constants/shadow_offset_y", 3)
	title.set("custom_constants/shadow_as_outline", true)

	# 🔧 YAZININ TAM GÖZÜKMESİ İÇİN SADECE BU KISIM DEĞİŞTİRİLDİ:
	title.rect_size = Vector2(get_viewport_rect().size.x, 120)
	title.align = Label.ALIGN_CENTER
	title.valign = Label.VALIGN_CENTER
	title.rect_position = Vector2(0, 80)
	title.autowrap = false
	# 🔧 (Yazı artık ekran genişliğine göre ortalanır ve asla kesilmez.)

	# Hafif parlayan efekt
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

	var buttons = [play_btn, exit_btn]
	for btn in buttons:
		btn.rect_min_size = Vector2(280, 85)
		btn.add_stylebox_override("normal", sb_normal)
		btn.add_stylebox_override("hover", sb_hover)
		btn.add_stylebox_override("pressed", sb_pressed)
		btn.add_stylebox_override("focus", sb_hover)
		btn.add_color_override("font_color", Color(0.96, 0.99, 1))
		btn.add_color_override("font_color_hover", Color(0.82, 0.96, 1))

		# Hover’da çok hafif büyüme
		var bt = Tween.new()
		add_child(bt)
		bt.interpolate_property(btn, "rect_scale", Vector2(1.0, 1.0), Vector2(1.04, 1.04), 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		bt.interpolate_property(btn, "rect_scale", Vector2(1.04, 1.04), Vector2(1.0, 1.0), 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 1.0)
		bt.start()

	# Buton konumları
	play_btn.rect_position = Vector2(780, 460)
	exit_btn.rect_position = Vector2(780, 570)


# ─────────────────────────────
# 🔹 StyleBoxFlat oluşturucu
# ─────────────────────────────
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


# ─────────────────────────────
# 🎨 Dikey gradient texture üretici
# ─────────────────────────────
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
	get_tree().change_scene("res://scenes/Main.tscn")

# ❌ Exit
func _on_exit_button_pressed():
	get_tree().quit()
