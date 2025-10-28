extends Control

onready var canvaslayer = $"CanvasLayer_UI"
onready var dark_overlay = canvaslayer.get_node("DarkOverlay")
onready var pause_menu = canvaslayer.get_node("Pause Menu")
onready var panel = pause_menu.get_node("Panel")

# Ana menü butonları
onready var resume_btn = panel.get_node("ResumeBtn")
onready var settings_btn = panel.get_node("SettingsBtn")
onready var mainmenu_btn = panel.get_node("MainMenuBtn")

# Ayar kısmı (ayar + label'lar dahil)
onready var settings_section = [
	panel.get_node("ayarlar"),
	panel.get_node("Label_AnaMenu"),
	panel.get_node("Label_OyunIci"),
	panel.get_node("CloseBtn"),
	panel.get_node("FullscreenCheck"),
	panel.get_node("MusicSlider"),
	panel.get_node("SfxSlider")
]

onready var ambience_game = $Ambience

var esc_held := false
var in_settings := false

func _ready():
	print("✅ Pause menü sistemi aktif (FINAL).")
	set_process(true)

	# Pause modları
	for node in [self, canvaslayer, pause_menu, panel, dark_overlay]:
		if node:
			node.pause_mode = Node.PAUSE_MODE_PROCESS

	pause_menu.visible = false
	dark_overlay.visible = false
	get_tree().paused = false

	_hide_settings_section()

	# 🔧 Dark overlay ayarları (tam ekran)
	if dark_overlay is ColorRect:
		dark_overlay.color = Color(0, 0, 0, 0.85)
		dark_overlay.anchor_left = 0
		dark_overlay.anchor_top = 0
		dark_overlay.anchor_right = 1
		dark_overlay.anchor_bottom = 1
		dark_overlay.margin_left = 0
		dark_overlay.margin_top = 0
		dark_overlay.margin_right = 0
		dark_overlay.margin_bottom = 0
		dark_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# 🔹 CanvasLayer sırası → Overlay arkada, Menü önde
	canvaslayer.move_child(dark_overlay, 0)
	canvaslayer.move_child(pause_menu, 1)

	# 🎮 Buton bağlantıları
	resume_btn.connect("pressed", self, "_on_resume_pressed")
	settings_btn.connect("pressed", self, "_on_settings_pressed")
	mainmenu_btn.connect("pressed", self, "_on_mainmenu_pressed")
	panel.get_node("CloseBtn").connect("pressed", self, "_on_close_settings_pressed")

	# 🎵 Oyun müziği ayarı
	if ambience_game and ambience_game.stream:
		var s = ambience_game.stream
		s.loop = true
		ambience_game.stream = s
		ambience_game.play()

	# 🔹 Menü pozisyonunu tam ortala
	yield(get_tree(), "idle_frame")
	_center_pause_menu()

func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE) and not esc_held:
		esc_held = true
		if pause_menu.visible:
			_resume_game()
		else:
			_pause_game()
	elif not Input.is_key_pressed(KEY_ESCAPE):
		esc_held = false

# 🔹 Oyun durdurma
func _pause_game():
	print("⏸️ Oyun durduruldu.")
	pause_menu.visible = true
	dark_overlay.visible = true
	get_tree().paused = true

	if ambience_game:
		ambience_game.stream_paused = true

	in_settings = false
	_hide_settings_section()
	_show_main_buttons()
	_center_pause_menu()

# 🔹 Oyun devam
func _resume_game():
	print("▶️ Oyun devam ediyor.")
	get_tree().paused = false
	pause_menu.visible = false
	dark_overlay.visible = false
	in_settings = false
	_hide_settings_section()

	if ambience_game:
		ambience_game.stream_paused = false

# 🔘 Buton olayları
func _on_resume_pressed():
	_resume_game()

func _on_settings_pressed():
	in_settings = true
	_show_settings_section()
	_hide_main_buttons()

func _on_close_settings_pressed():
	in_settings = false
	_hide_settings_section()
	_show_main_buttons()

func _on_mainmenu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://ana menü.tscn")

# ⚙️ Yardımcı fonksiyonlar
func _hide_settings_section():
	for node in settings_section:
		if node and node.is_inside_tree():
			node.visible = false

func _show_settings_section():
	for node in settings_section:
		if node and node.is_inside_tree():
			node.visible = true

func _hide_main_buttons():
	resume_btn.visible = false
	settings_btn.visible = false
	mainmenu_btn.visible = false

func _show_main_buttons():
	resume_btn.visible = true
	settings_btn.visible = true
	mainmenu_btn.visible = true

# 🧭 Pause menüyü ekran ortasına al (kamera etkilenmesin)
func _center_pause_menu():
	if pause_menu and panel:
		var viewport_size = get_viewport().size
		panel.rect_position = viewport_size / 2 - panel.rect_size / 2
		pause_menu.rect_position = Vector2(0, 0)
	if dark_overlay:
		dark_overlay.rect_position = Vector2(0, 0)
# 🛠️ Pause menü görünürlük hatası fix
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		# Oyun pencereye yeniden odaklanınca görünürlükleri senkronla
		if get_tree().paused and pause_menu:
			pause_menu.visible = true
			dark_overlay.visible = true
			if in_settings:
				_show_settings_section()
			else:
				_hide_settings_section()
