extends CharacterBody2D


const SPEED : float = 80.0
const JUMP_VELOCITY : float = -100.0

var _jump : bool = false
var _grounded : bool = true

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var audio : AudioStreamPlayer2D = $PlayerAudioStream

@export var canjump : bool = true
@export var jumpsfx : AudioStreamWAV
@export var walksfx : AudioStreamWAV


func _process(_delta: float) -> void:
	update_anim()

func _physics_process(delta: float) -> void:
	# Add the gravity, accounting for variable jump height
	if not is_on_floor():
		_grounded = false
		if is_on_wall_only() and headcast(): #and Input.get_axis("move_left", "move_right") != 0:
			wall_slide()
		elif Input.is_action_pressed("jump") and velocity.y < 0:
			velocity += (get_gravity() / 2) * delta
		else:
			velocity += get_gravity() * delta
	# Squash
	elif _grounded == false:
		sprite.scale = Vector2(1.2, 0.8)
		_grounded = true
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		if !canjump: return
		$JumpTimer.start(0.2)
		_jump = true
	
	if _jump:
		if is_on_floor():
			# Stretch
			sprite.scale = Vector2(0.7, 1.3)
			velocity.y = JUMP_VELOCITY
			play_audio(jumpsfx, 1, 0.2)
			bunny_hop()
			_jump = false
		if is_on_wall_only():
			wall_jump()
			_jump = false
	
	# Get input
	var direction := Input.get_axis("move_left", "move_right")
	check_flip(direction)
	
	# Apply velocity
	if direction:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * SPEED, 1000 * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, 250 * delta)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 1000 * delta)
	
	move_and_slide()
	
	# Undo squash/stretch
	sprite.scale.x = move_toward(sprite.scale.x, 1, 1 * delta)
	sprite.scale.y = move_toward(sprite.scale.y, 1, 1 * delta)

func check_flip(direction):
	if is_on_wall_only():
		return
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false

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
	if not $LeftWallCast2D.is_colliding() and not $RightWallCast2D.is_colliding():
		return
	
	velocity.y = JUMP_VELOCITY / 1.2
	
	if $LeftWallCast2D.is_colliding():
		velocity.x = 1.2 * SPEED
		sprite.flip_h = false
	elif $RightWallCast2D.is_colliding():
		velocity.x = -1.2 * SPEED
		sprite.flip_h = true
	# Stretch
	sprite.scale = Vector2(1.3, 0.7)
	play_audio(jumpsfx, 1.5, 0.2)

func wall_slide():
	# face wall
	match $LeftWallCast2D.is_colliding():
		true:
			sprite.flip_h = true
			pass
		false:
			sprite.flip_h = false
			pass
	
	# check if slide key is pressed
	if Input.is_action_pressed("wall_slidedown"):
		velocity = (get_gravity() * 20) * get_physics_process_delta_time()
	else:
		velocity = Vector2(0,0)

func headcast():
	var collision : bool = false
	if $LeftHeadCast2D.is_colliding() or $RightHeadCast2D.is_colliding():
		collision = true
	return collision

func play_audio(sound, initial_pitch, pitch_difference):
	audio.stream = sound
	audio.pitch_scale = initial_pitch
	audio.pitch_scale += randf_range(-pitch_difference, pitch_difference)
	audio.play()

func bunny_hop():
	if velocity.x < 0:
		velocity.x += -0.1 * SPEED
		if velocity.x < -1.5 * SPEED:
			print("max bunnyhop speed!")
			velocity.x = -1.5 * SPEED
	elif velocity.x > 0:
		velocity.x += 0.1 * SPEED
		if velocity.x > 1.5 * SPEED:
			print("max bunnyhop speed!")
			velocity.x = 1.5 * SPEED

func _on_jump_timer_timeout() -> void:
	_jump = false
