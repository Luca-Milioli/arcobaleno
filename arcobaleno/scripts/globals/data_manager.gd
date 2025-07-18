extends Node

class_name DataManager

const DATA_PATH = "res://data/content.csv"

func _read_csv(separator: String = ",", path: String = DATA_PATH) -> Array:
	var data := []
	var file := FileAccess.open(path, FileAccess.READ)

	if not file:
		push_error("Errore nell'aprire il file.")
		return []

	var regex := RegEx.new()
	# regex that find: field beetween "" which can contains ',' or normal fields without ""
	regex.compile(r'''("(?:[^"]|"")*"|[^%s]+)''' % separator)

	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line.is_empty():
			continue

		var values := []
		var matches := regex.search_all(line)
		for match in matches:
			var val = match.get_string(0)
			# Rimuovi virgolette esterne se presenti
			if val.begins_with('"') and val.ends_with('"'):
				val = val.substr(1, val.length() - 2).replace('""', '"')
			values.append(val)

		data.append(values)

	file.close()
	return data
