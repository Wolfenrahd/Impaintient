extends Button

export(NodePath) var popupControl = null;

func _ready() -> void:
	pass;

func _on_pressed() -> void:
	print("pressed");
	if popupControl != null:
		get_node(popupControl).popup();
