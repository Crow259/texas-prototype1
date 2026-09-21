extends CharacterBody2D
class_name player

var health = 100.0
var maxhealth = health
var iframes = 0.0
var maxiframes = 1
@export var camera:Camera2D
@export var MoveSpeed = 700
var Speed = MoveSpeed
@export var DashVelocity = 6000
@export var DashCooldown = 0.5
@export var DashTime = 0.175
@export var CanDash = true
var CanUseWeapon = true
var AttackSpeed = 1
@onready var Revolver: = $Revolver
@onready var RevolverSprite: = $Revolver/RevolverSprite
@onready var Reticle: Sprite2D = $Reticle
const BULLET = preload("uid://b1i6crwai0b36")
@onready var muzzle: Marker2D = $Revolver/RevolverSprite/Marker2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $CanvasLayer/ProgressBar

@export var Weapon1: weapondata
@export var Weapon2: weapondata
@onready var currentweapon := Weapon1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Speed = MoveSpeed
	Global.Player = self

func dashcooldown():
	CanDash = false
	await get_tree().create_timer(DashCooldown).timeout
	CanDash = true
	
func revolvercooldown():
	CanUseWeapon = false
	await get_tree().create_timer(AttackSpeed * currentweapon.reloadtime).timeout
	CanUseWeapon = true

func switchweapon():
	if currentweapon == Weapon1:
		currentweapon = Weapon2
		$Revolver/RevolverSprite.scale = Vector2(1.1, 1.1)
	else:
		currentweapon = Weapon1
		$Revolver/RevolverSprite.scale = Vector2(0.7, 0.7)
	RevolverSprite.texture = currentweapon.weapontexture

func damage(enemydamage:float):
	if iframes <= 0:
		health -= enemydamage
		iframes = maxiframes
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var Direction = Input.get_vector("Left", "Right", "Up", "Down").normalized()
	
	Revolver.look_at(get_global_mouse_position())
	if get_global_mouse_position().x < global_position.x:
		RevolverSprite.flip_v = true
	else:
		RevolverSprite.flip_v = false
	
	Reticle.global_position = get_global_mouse_position()
	
	if health <= 0:
		get_tree().change_scene_to_file("res://deathscreen.tscn")
	
	health_bar.value = health / maxhealth
	
	iframes -= delta
	
	#dash
	if Input.is_action_just_pressed("Dash") and CanDash:
		dashcooldown()
		Speed = DashVelocity
		Global.Dashing = true
		await get_tree().create_timer(0.135).timeout
		Global.Dashing = false
		Speed = MoveSpeed
	
	if Input.is_action_just_pressed("WeaponAction") and CanUseWeapon:
		var bullet = currentweapon.projectilefired.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = muzzle.global_position
		bullet.rotation = Revolver.rotation
		revolvercooldown()
		animation_player.play("RESET")
		animation_player.play("Recoil")
		animation_player.speed_scale = AttackSpeed
	
	if Input.is_action_just_pressed("SwapWeapon") and CanUseWeapon:
		switchweapon()
	
	#make a dashblast sprite, possibly not pixelated?? 
		#figure out particle stuff maybe
	
	velocity = Direction * Speed
	move_and_slide()
	var MousePos = get_global_mouse_position()
	camera.position = (position + MousePos) / 2
