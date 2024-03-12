extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	# make me a player
	var player = preload("res://scenes/player.tscn").instantiate()
	# player.global_position = global_position - Vector3(0, 1.0, 0);
	player.position = position
	player.rotation = rotation
	
	get_tree().get_root().add_child.call_deferred(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
