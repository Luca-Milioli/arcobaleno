## Class that access and store data from csv.
extends Node
class_name DataManager

## Path of .csv where data are stored.
const DATA_PATH = "res://data/content.csv.txt"

## Stores fruit_data after it reads csv the first time.
var fruit_data: Array


## Returns the number of fruits for each group.
static func get_fruits_per_group() -> int:
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	var fruits = file.get_line().strip_edges().to_int()
	file.close()
	return fruits


## First time it's called it reads csv file in path, stores data in fruit_data and returns it. After, it just returns fruit_data.
func _read_csv(path: String = DATA_PATH, separator: String = ",") -> Array:
	if not fruit_data.is_empty():
		return fruit_data

	var file := FileAccess.open(path, FileAccess.READ)

	if not file:
		push_error("Errore nell'aprire il file.")
		return []

	file.get_line()  # skip first line

	var regex := RegEx.new()
	# regex that find: field beetween "" which can contains ',' or normal fields without ""
	regex.compile(r'("(?:[^"]|"")*"|[^%s]+)' % separator)

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty():
			continue

		var values := []
		var matches := regex.search_all(line)
		for m in matches:
			var val = m.get_string(0)
			# Rimuovi virgolette esterne se presenti
			if val.begins_with('"') and val.ends_with('"'):
				val = val.substr(1, val.length() - 2).replace('""', '"')
			values.append(val)

		fruit_data.append(values)

	file.close()
	return fruit_data
