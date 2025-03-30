extends Control

@onready var text_edit: TextEdit
@onready var settings_bar: PopupMenu = $settings_bar
@onready var side_bar: VBoxContainer = $VBoxContainer/HSplitContainer/side_bar
@onready var app_name: Label = $VBoxContainer/HBoxContainer/app_name
@onready var tab_container: TabContainer = $VBoxContainer/HSplitContainer/MarginContainer/VBoxContainer/TabContainer

var note_name : String
var current_tab 
var editing : bool


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	settings()
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
		note_name = save_path.get_file()
		var file = FileAccess.open(save_path,FileAccess.READ)
		if file:
			text_edit.text = file.get_as_text()
			text_edit.name = StringName(note_name)
			file.close()
			print("loaded")
		else:
			print("err")

func settings():
	if settings_bar.is_item_checked(1):
		side_bar.hide()
	else:
		side_bar.show()
	if settings_bar.is_item_checked(2):
		app_name.hide()
	else:
		app_name.show()

func _on_save_btn_2_pressed() -> void:
	file_save(note_name)

func _on_save_btn_pressed() -> void:
	if editing:
		var file_dialog = FileDialog.new()
		file_dialog.access = FileDialog.ACCESS_FILESYSTEM
		file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		file_dialog.add_filter("*.txt","Text Files")
		add_child(file_dialog)
		file_dialog.connect("file_selected",file_save)
		file_dialog.popup_centered()

func _on_load_btn_pressed() -> void:
	if editing:
		var file_dialog = FileDialog.new()
		file_dialog.access = FileDialog.ACCESS_FILESYSTEM
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
	else:
		pass
