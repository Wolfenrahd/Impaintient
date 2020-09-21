extends Node2D

var canvasData : Array = [];
var canvasSize := Vector2(8, 8);

var mouseDown = false;
var mouseClickPos = Vector2(0, 0);
var cameraClickPos = Vector2(0, 0);

enum TOOLTYPE {PAN, PENCIL, ERASER};
var currentTool = TOOLTYPE.PENCIL;

const clearColor := Color(1.0, 1.0, 1.0, 0.0);

func _ready() -> void:
	canvasData = [];
	
	for x in canvasSize.x:
		canvasData.append([]);
		for y in canvasSize.y:
			canvasData[x].append(Color(1.0, 1.0, 1.0, 1.0));

func _draw() -> void:
	for x in canvasData.size():
		for y in canvasData[x].size():
			draw_rect(Rect2(x * 50, y * 50, 50, 50), canvasData[x][y]);

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pan"):
		currentTool = TOOLTYPE.PAN;
	elif event.is_action_pressed("pencil"):
		currentTool = TOOLTYPE.PENCIL;
	elif event.is_action_pressed("eraser"):
		currentTool = TOOLTYPE.ERASER;
	if event is InputEventMouseButton:
		mouseDown = event.pressed;
		mouseClickPos = get_global_mouse_position() + $camera2D.offset;
		print("mouse pos, ", mouseClickPos);
		cameraClickPos = $camera2D.offset;
	elif event is InputEventMouseMotion:
		if mouseDown and currentTool == TOOLTYPE.PAN:
			$camera2D.offset -= event.relative;

func _process(delta: float) -> void:
	if mouseDown:
		match currentTool:
			TOOLTYPE.PAN:
				pass;
			TOOLTYPE.PENCIL:
				var mousePos = get_global_mouse_position() - position;
				
				if mousePos.x < canvasSize.x * 50 and mousePos.y < canvasSize.y * 50 and mousePos.x >= 0 and mousePos.y >= 0:
					canvasData[mousePos.x / 50][mousePos.y / 50] = ProgramData.currentColor;
					update();
			TOOLTYPE.ERASER:
				var mousePos = get_global_mouse_position() - position;
				
				if mousePos.x < canvasSize.x * 50 and mousePos.y < canvasSize.y * 50 and mousePos.x >= 0 and mousePos.y >= 0:
					canvasData[mousePos.x / 50][mousePos.y / 50] = clearColor;
					update();

func resizeCanvas(x, y) -> void:
	canvasSize = Vector2(x, y);
	
	resizeArr2D(canvasData, x);
	for i in x:
		resizeArrColor(canvasData[i], y, Color.white);
	
	$background.region_rect.size.x = x * 2;
	$background.region_rect.size.y = y * 2;
	
	update();

func resizeArr2D(arr, size) -> void:
	if size <= arr.size():
		arr.resize(size);
	else:
		for i in (size - arr.size()):
			arr.append([]);

func resizeArrColor(arr, size, val) -> void:
	if size <= arr.size():
		arr.resize(size);
	else:
		for i in (size - arr.size()):
			arr.append(val);
