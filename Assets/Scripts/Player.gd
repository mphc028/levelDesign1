extends KinematicBody2D
class_name Player
onready var animator = $AnimationPlayer
onready var sprite = $Sprite


export var hp = 100
export (int) var speed = 10000
export (int) var jump_speed = -350
export (int) var gravity = 1000
export (float, 0, 1.0) var friction = 0.2
export (float, 0, 1.0) var acceleration = 0.25
var game = get_owner()
var hpBar 
onready var is_invulnerable = false

var velocity = Vector2.ZERO

func _ready():
	hpBar = get_tree().get_nodes_in_group("hp")[0]
	hpBar.value=hp
	
	

func animate(dir):
	if is_on_floor():
		if abs(velocity.x) > 2 && dir!=0:
			animator.play("Run")
		else:
			animator.play("Idle")
	else:
		animator.play("Jump")
	if dir == -1: sprite.flip_h = true
	if dir == 1: sprite.flip_h = false

func get_input(delta):
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed*delta, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0*delta, friction)
	return dir
	

func _physics_process(delta):
	
	var dir = get_input(delta)
	animate(dir)
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed



func set_hp(_hp):
	hp = _hp
	
func get_hp():
	return hp

func damage(damage):
	hp-=damage
	hpBar.value=hp
	
	if !is_invulnerable:
		is_invulnerable = true
		$invulnerability.start()
		for i in 8:
			sprite.self_modulate.a = 0.1
			sprite.self_modulate.r = 0.1
			yield(get_tree().create_timer(0.1), "timeout")
			sprite.self_modulate.a = 1.0
			sprite.self_modulate.r = 1.0
			yield(get_tree().create_timer(0.1), "timeout")


	
func _on_Traps_body_entered(body):
	if body == self:
		get_tree().reload_current_scene()


func _on_invulnerability_timeout():
   is_invulnerable = false
