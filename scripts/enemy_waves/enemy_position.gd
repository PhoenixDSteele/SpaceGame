class_name EnemyPosition
extends Marker3D

enum ScreenSide {
	Left, Right
}

@export var side: ScreenSide = ScreenSide.Left

@export var formation_row: int = 0
