extends Control

@onready var text_edit: TextEdit
@onready var settings_bar: PopupMenu = $settings_bar
@onready var side_bar: MarginContainer = $VBoxContainer/HSplitContainer/MarginContainer2

@onready var app_name: Label = $VBoxContainer/HBoxContainer/app_name
@onready var tab_container: TabContainer = $VBoxContainer/HSplitContainer/MarginContainer/VBoxContainer/TabContainer

var note_name : String
var current_tab 
var editing : bool

var current_dir

func _ready() -> void:
	settings_menu_popup()

func _process(_delta: float) -> void:
	settings_system()
	text_edit = tab_container.get_current_tab_control()
	if tab_container.get_tab_count() > 0:
		editing = true
	else:
		editing = false

func file_save(save_path):
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	if file:
		file.store_line(text_edit.text)
		file.close()
		print("saved")
	else:
		print("err")

func file_load(save_path):
	if FileAccess.file_exists(save_path):
		var text_edit = TextEdit.new()
		tab_container.add_child(text_edit)
		note_name = save_path.get_file()
		var file = FileAccess.open(save_path,FileAccess.READ)
		if file:
			text_edit.text = file.get_as_text()
			text_edit.name = StringName(note_name)
			file.close()
			print("loaded")
		else:
			print("err")

func settings_system():
	if settings_bar.is_item_checked(1):
		side_bar.hide()
	else:
		side_bar.show()
	if settings_bar.is_item_checked(2):
		app_name.hide()
	else:
		app_name.show()
	if settings_bar.is_item_checked(3):
		tab_container.tabs_visible = false
	else:
		tab_container.tabs_visible = true
	if editing:
		if settings_bar.is_item_checked(5):
			text_edit.caret_type = TextEdit.CARET_TYPE_BLOCK
		else:
			text_edit.caret_type = TextEdit.CARET_TYPE_LINE
		if settings_bar.is_item_checked(6):
			text_edit.caret_blink = true
		else:
			text_edit.caret_blink = false
		if settings_bar.is_item_checked(8):
			text_edit.wrap_mode = TextEdit.LINE_WRAPPING_NONE
		else:
			text_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
		if settings_bar.is_item_checked(9):
			text_edit.highlight_current_line = true
		else:
			text_edit.highlight_current_line = false


func settings_menu_popup():
	settings_bar.add_separator("SETTINGS",0)
	settings_bar.add_check_item(" : Hide SideBar",1)
	settings_bar.add_check_item(" : Hide App Name",2)
	settings_bar.add_check_item(" : Hide Tabs",3)
	settings_bar.add_separator("Caret Settings",4)
	settings_bar.add_check_item(" : Change Shape to Block",5)
	settings_bar.add_check_item(" : Toggle Blinking",6)
	settings_bar.add_separator("Tab Settings",7)
	settings_bar.add_check_item(" : Toggle Line Break",8)
	settings_bar.add_check_item(" : Toggle Line Highlight",9)


func _on_save_btn_2_pressed() -> void:  #Quick dave
	file_save(note_name)

func _on_save_btn_pressed() -> void:
	if editing:
		var file_dialog = FileDialog.new()
		file_dialog.access = FileDialog.ACCESS_USERDATA
		file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		file_dialog.add_filter("*.txt","Text Files")
		add_child(file_dialog)
		file_dialog.connect("file_selected",file_save)
		file_dialog.popup_centered()

func _on_load_btn_pressed() -> void:
	var file_dialog = FileDialog.new()
	file_dialog.access = FileDialog.ACCESS_USERDATA
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.add_filter("*.txt","Text Files")
	add_child(file_dialog)
	file_dialog.connect("file_selected",file_load)
	file_dialog.popup_centered()


func _on_close_btn_pressed() -> void:
	if editing:
		current_tab =  tab_container.get_current_tab_control()
		current_tab.queue_free()


func _on_clear_btn_pressed() -> void:
	if editing:
		text_edit.clear()


func _on_setting_btn_pressed() -> void:
	settings_bar.visible = true


func _on_new_btn_pressed() -> void:
	var new_note = TextEdit.new()
	new_note.deselect_on_focus_loss_enabled = false
	new_note.drag_and_drop_selection_enabled =false
	new_note.caret_type = TextEdit.CARET_TYPE_BLOCK
	new_note.highlight_all_occurrences = true
	new_note.draw_tabs = true
	new_note.name = "new note "+str(tab_container.get_tab_count())
	tab_container.add_child(new_note)


func _on_settings_bar_id_pressed(id: int) -> void:
	if id == 1 and settings_bar.is_item_checked(1) == false:
		settings_bar.set_item_checked(1,true)
	elif id == 1 and settings_bar.is_item_checked(1):
		settings_bar.set_item_checked(1,false)
	elif id == 2 and settings_bar.is_item_checked(2) == false:
		settings_bar.set_item_checked(2,true)
	elif id == 2 and settings_bar.is_item_checked(2):
		settings_bar.set_item_checked(2,false)
	elif id == 3 and settings_bar.is_item_checked(3) == false:
		settings_bar.set_item_checked(3,true)
	elif id == 3 and settings_bar.is_item_checked(3):
		settings_bar.set_item_checked(3,false)
	elif id == 5 and settings_bar.is_item_checked(5) == false:
		settings_bar.set_item_checked(5,true)
	elif id == 5 and settings_bar.is_item_checked(5):
		settings_bar.set_item_checked(5,false)
	elif id == 6 and settings_bar.is_item_checked(6) == false:
		settings_bar.set_item_checked(6,true)
	elif id == 6 and settings_bar.is_item_checked(6):
		settings_bar.set_item_checked(6,false)
	elif id == 8 and settings_bar.is_item_checked(8) == false:
		settings_bar.set_item_checked(8,true)
	elif id == 8 and settings_bar.is_item_checked(8):
		settings_bar.set_item_checked(8,false)
	elif id == 9 and settings_bar.is_item_checked(9) == false:
		settings_bar.set_item_checked(9,true)
	elif id == 9 and settings_bar.is_item_checked(9):
		settings_bar.set_item_checked(9,false)
	elif id == 10 and settings_bar.is_item_checked(10) == false:
		settings_bar.set_item_checked(10,true)
	elif id == 10 and settings_bar.is_item_checked(10):
		settings_bar.set_item_checked(10,false)
	else:
		pass
