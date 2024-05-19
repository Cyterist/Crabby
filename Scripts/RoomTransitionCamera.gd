extends Camera2D
class_name RoomTransitionCamera

const HORIZONAL_OFFSET : int = 733
const VERTICAL_OFFSET : int = 397

#Target node the camera will be tracking
@export var TargetNode : Node2D = null

@onready var m_CameraHorizontalMovement : int = get_viewport_rect().size.x - HORIZONAL_OFFSET
@onready var m_CameraVerticalMovement : int = get_viewport_rect().size.y - VERTICAL_OFFSET

# Initialize the current room the camera is pointing at
var m_CurrentRoom : Vector2 = Vector2.ZERO

# Initialize the offset from the origin point
var m_OriginOffset : Vector2 = Vector2.ZERO

func _ready():
	m_OriginOffset = TargetNode.get_position()
	set_position(m_OriginOffset)

func _UpdateCameraPosition(direction : Vector2) -> void:
	m_CurrentRoom += direction
	set_position(m_OriginOffset + m_CurrentRoom * Vector2(m_CameraHorizontalMovement, m_CameraVerticalMovement))

func _OnBodyEnteredTop(_body):
	_UpdateCameraPosition(Vector2.UP)

func _OnBodyEnteredBottom(_body):
	_UpdateCameraPosition(Vector2.DOWN)

func _OnBodyEnteredLeft(_body):
	_UpdateCameraPosition(Vector2.LEFT)

func _OnBodyEnteredRight(_body):
	_UpdateCameraPosition(Vector2.RIGHT)
	
