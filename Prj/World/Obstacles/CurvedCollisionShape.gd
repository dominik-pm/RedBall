extends StaticBody2D

func _ready():
	$CollisionPolygon2D.polygon = $Path2D.curve.tessellate()
