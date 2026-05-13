extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera3D 
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENS = 0.003

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENS)
		head.rotate_x(-event.relative.y * SENS)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("Strafe_Left", "Strafe_right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
