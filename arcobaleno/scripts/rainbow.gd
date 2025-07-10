extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_blue_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("sucolandia")
	# ASPETTO IL RILASCIO DEL MOUSE? OPPURE RILASCIO E MANDO UN SEGNALE DALLO SCRIPT ITEM?
	# SECONDO ME FACCIO TIPO IF NOT DRAGGING E IN QUEL CASO MANDO ALLA GAME LOGIC L'AREA DI COLLISIONE E L'ITEM
	# LA GAME LOGIC CAPISCE SE VA BENE OPPURE NO E MANDA UN SEGNALE OK/DROP
