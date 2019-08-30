extends Spatial

func _ready():
	$LevelMesh/CSGPolygon/CSGCylinderBLACK.set_radius(0)
	$LevelMesh/CSGPolygon/CSGCylinderWHITE.set_radius(0)

var s
var RAY_LENGTH = 1000
var numberEntered = 0
onready var BLACK = $LevelMesh/CSGPolygon/CSGCylinderBLACK
onready var WHITE = $LevelMesh/CSGPolygon/CSGCylinderWHITE
onready var blackBubbleAREA = $LevelMesh/CSGPolygon/CSGCylinderBLACK/blackBubbleAREA
onready var blackBallAREA = $LevelMesh/CSGPolygon/BlackBall/blackBallAREA
onready var whiteBubbleAREA = $LevelMesh/CSGPolygon/CSGCylinderWHITE/whiteBubbleAREA
onready var whiteBallAREA = $LevelMesh/CSGPolygon/WhiteBall/whiteBallAREA
onready var BlackBall = $LevelMesh/CSGPolygon/BlackBall
onready var WhiteBall = $LevelMesh/CSGPolygon/WhiteBall
onready var LevelPolygon = $LevelMesh/CSGPolygon

func _input(event):
	if Input.is_action_just_released("click"):
		$Out.play() #Play "Out" sound to indicate that old bubble is leaving
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_from = $Camera.project_ray_origin(mouse_pos)
		var ray_to = ray_from + $Camera.project_ray_normal(mouse_pos) * RAY_LENGTH
		var space_state = get_world().direct_space_state
		var mousePosition = space_state.intersect_ray(ray_from, ray_to)
		var colliderName
		colliderName = mousePosition.collider.name
		$cylinderTWEEN.interpolate_property(BLACK, "radius", BLACK.get_radius(), 0, 0.6, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		$cylinderTWEEN.interpolate_property(WHITE, "radius", WHITE.get_radius(), 0, 0.6, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
		$cylinderTWEEN.start()
		yield($cylinderTWEEN, "tween_completed")
		if colliderName == "Background" or colliderName == "BlackBall": #if the raycast collides with the WHITE background or BLACK ball
			WHITE.set_translation(Vector3(0,0,0))
			mousePosition.position.z = -1.5
			WHITE.global_translate(mousePosition.position)
			$cylinderTWEEN.interpolate_property(WHITE, "radius", 0, .6, 0.6, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			$In.play() #Play "In" sound to indicate that new bubble is entering
		elif colliderName == "LevelMesh" or colliderName == "WhiteBall": #if the raycast collides with the BLACK foreground or WHITE ball
			BLACK.set_translation(Vector3(0,0,0))
			mousePosition.position.z = -1.5
			BLACK.global_translate(mousePosition.position)
			$cylinderTWEEN.interpolate_property(BLACK, "radius", 0, .6, .6, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			$cylinderTWEEN.start()
			yield($cylinderTWEEN, "tween_completed")
			$In.play() #Play "In" sound to indicate that new bubble is entering

func _on_FinishDetector_body_entered(body):
	numberEntered += 1
	if numberEntered == 2:
		print("you did it!")
		$LevelCompleteText.set_visible(true)
		yield(get_tree().create_timer(6), "timeout")
		get_tree().change_scene("res://World2.tscn")

func _physics_process(delta):
	if blackBubbleAREA.overlaps_area(blackBallAREA) == true and $cylinderTWEEN.is_active() == false:
		if BLACK.get_radius() >= .001:
			s = BLACK.get_radius() * .96
			BLACK.set_radius(s)
		elif BLACK.get_radius() <= .001:
			BLACK.set_radius(0)
	if whiteBubbleAREA.overlaps_area(whiteBallAREA) == true and $cylinderTWEEN.is_active() == false:
		if WHITE.get_radius() >= .001:
			s = WHITE.get_radius() * .96
			WHITE.set_radius(s)
		elif WHITE.get_radius() <= .001:
			WHITE.set_radius(0)