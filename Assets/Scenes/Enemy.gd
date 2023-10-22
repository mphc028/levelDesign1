extends KinematicBody2D


onready var sprite = $Sprite

export (int) var speed = 1000
export (int) var gravity = 1000

var velocity = Vector2.ZERO
var dir = -1

func animate(dir):
	if dir == -1: sprite.flip_h = false
	if dir == 1: sprite.flip_h = true

func get_input(delta):

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed*delta, 1)
	else:
		velocity.x = lerp(velocity.x, 0*delta, .2)
	return dir
	

func _physics_process(delta):
	
	var dir = get_input(delta)
	animate(dir)
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_DamageArea_body_entered(body):
	if body is Player:
		get_tree().reload_current_scene()


func _on_WeakArea_body_entered(body):
	if body is Player:
		body.velocity.y = -300
		get_parent().queue_free()
