extends Node

var current_brows = preload("res://assets/Player/standard-brows.png")
var current_eyes = preload("res://assets/Player/standard-eyes.png")
var current_mouth = preload("res://assets/Player/standard-mouth.png")

signal hit_platform(platform)
signal hit_enemy(enemy)
signal player_hit
signal player_fell
signal new_game
