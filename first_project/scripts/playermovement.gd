extends CharacterBody2D


# Serialized Fields
@export var SPEED = 80.0
@export var JUMP_VELOCITY = -150.0

# Editor References
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity, accounting for variable jump height
	if not is_on_floor():
		if Input.is_action_pressed("jump") and velocity.y < 0:
			velocity += (get_gravity() / 2) * delta
		else:
			velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	check_flip(direction)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_anim()


func check_flip(direction):
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
