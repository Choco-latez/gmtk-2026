extends CanvasLayer

@export var signs : Array[SignEntity]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InputMap.load_from_project_settings()
	for sign in signs:
		sign.sign_interacted.connect(show_up)
		sign.exited.connect(close)

func show_up(title:String,info:String):
	$Popup.visible = true
	$Timer.start()
	if title!= "":
		%Title.visible = true
		%Title.text = title
	else:
		%Title.visible = true
	%Info.text = info
	%exit.text = "press " + (InputMap.action_get_events("USE")).get(0).as_text().trim_suffix(" (Physical)") + " or " + (InputMap.action_get_events("MENU")).get(0).as_text().trim_suffix(" (Physical)") + " to close"

func close():
	$Popup.visible = false

func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("MENU") or Input.is_action_just_pressed("USE")) and $Timer.is_stopped() :
		close()
	if %Title.text == "NEW ABILITY":
		if Input.is_action_just_pressed("UP") or Input.is_action_just_pressed("DOWN") or Input.is_action_just_pressed("LEFT") or Input.is_action_just_pressed("RIGHT"):
			close()
