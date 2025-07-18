extends Node

class_name DataManager

const DATA_PATH = "res://data/content.csv"

func _read_csv(separator: String = ",", path: String = DATA_PATH) -> Array:
	var data := []
	var file := FileAccess.open(path, FileAccess.READ)
	
	if not file:
		push_error("Errore nell'aprire il file.")
		return []

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty():
			continue
		var values = line.split(separator, false) # false = non rimuove i campi vuoti
		data.append(values)

	file.close()
	return data
