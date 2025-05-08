extends CharacterBody2D


const SPEED : float = 80.0
const JUMP_VELOCITY : float = -100.0

var _jump : bool = false

@onready var anim := $AnimationPlayer
@onready var sprite := $Sprite2D


func _process(_delta: float) -> void:
	update_anim()

func _physics_process(delta: float) -> void:
	# Add the gravity, accounting for variable jump height
	if not is_on_floor():
		if is_on_wall_only() and headcast(): #and Input.get_axis("move_left", "move_right") != 0:
			wall_slide()
		elif Input.is_action_pressed("jump") and velocity.y < 0:
			velocity += (get_gravity() / 2) * delta
		else:
			velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		$JumpTimer.start(0.33)
		_jump = true
	
	if _jump:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			_jump = false
		if is_on_wall_only():
			wall_jump()
			_jump = false
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	check_flip(direction)
	
	if direction and not is_on_wall_only():
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * SPEED, 1000 * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, 250 * delta)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 1000 * delta)
	
	move_and_slide()

func check_flip(direction):
	if is_on_wall_only():
		return
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false

# gonna need to change to animation tree
func update_anim():
	if not is_on_floor():
		anim.play("jump")
		return
	elif velocity.x != 0:
		anim.play("move")
		return
	elif velocity.x == 0:
		anim.play("idle")
		return

func wall_jump():
	if $LeftWallCast2D.is_colliding():
		velocity.y = JUMP_VELOCITY / 1.2
		velocity.x = 1.2 * SPEED
		sprite.flip_h = false
	elif $RightWallCast2D.is_colliding():
		velocity.y = JUMP_VELOCITY / 1.2
		velocity.x = -1.2 * SPEED
		sprite.flip_h = true

func wall_slide():
	if Input.is_action_pressed("wall_slidedown"):
		velocity = (get_gravity() * 4) * get_physics_process_delta_time()
	else:
		velocity = get_gravity() * get_physics_process_delta_time()

func headcast():
	var collision : bool = false
	if $LeftHeadCast2D.is_colliding() or $RightHeadCast2D.is_colliding():
		collision = true
	print(collision)
	return collision

func _on_jump_timer_timeout() -> void:
	_jump = false
