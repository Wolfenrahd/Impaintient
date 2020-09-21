extends Node

enum FileMode {SAVE_IMAGE};
var fileMode = FileMode.SAVE_IMAGE;

func _ready() -> void:
	pass


func _on_colorPickerButton_color_changed(color: Color) -> void:
	ProgramData.currentColor = color;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode == KEY_0 and event.pressed and not event.echo:
			var image = Image.new();
			image.create($drawCanvas.canvasSize.x, $drawCanvas.canvasSize.y, false, Image.FORMAT_RGBA8);
			
			image.lock();
			for x in $drawCanvas.canvasSize.x:
				for y in $drawCanvas.canvasSize.y:
					image.set_pixel(x, y, $drawCanvas.canvasData[x][y]);
			
			image.save_png("res://textures/test.png");
			image.unlock();
			
			$drawCanvas.canvasData


func _on_resize_image_pressed() -> void:
	$uiLayer/imageDialogue.hide();
	$uiLayer/resizeDialogue.popup();
	$uiLayer/resizeDialogue/panelContainer/marginContainer/vBoxContainer/widthBox.value = $drawCanvas.canvasSize.x;
	$uiLayer/resizeDialogue/panelContainer/marginContainer/vBoxContainer/heightBox.value = $drawCanvas.canvasSize.y;


func _on_resize_dialog_cancel_pressed() -> void:
	$uiLayer/resizeDialogue.hide();


func _on_resize_dialog_confirm_pressed() -> void:
	$drawCanvas.resizeCanvas($uiLayer/resizeDialogue/panelContainer/marginContainer/vBoxContainer/widthBox.value, $uiLayer/resizeDialogue/panelContainer/marginContainer/vBoxContainer/heightBox.value);
	$uiLayer/resizeDialogue.hide();


func _on_new_file_pressed() -> void:
	for x in $drawCanvas.canvasSize.x:
		for y in $drawCanvas.canvasSize.y:
			$drawCanvas.canvasData[x][y] = Color.white;
			$drawCanvas.update();
	$uiLayer/fileDialogue.hide();


func _on_save_file_pressed() -> void:
	$uiLayer/fileSystemDialog.popup();


func _on_load_file_pressed() -> void:
	pass # Replace with function body.



func _on_fileSystemDialog_file_selected(path: String) -> void:
	match fileMode:
		FileMode.SAVE_IMAGE:
			var image = Image.new();
			image.create($drawCanvas.canvasSize.x, $drawCanvas.canvasSize.y, false, Image.FORMAT_RGBA8);
			
			image.lock();
			for x in $drawCanvas.canvasSize.x:
				for y in $drawCanvas.canvasSize.y:
					image.set_pixel(x, y, $drawCanvas.canvasData[x][y]);
			
			image.save_png(path);
			image.unlock();
			
			$drawCanvas.canvasData
