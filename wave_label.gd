extends Label


func _on_new_wave(wave_number: int) -> void:
	text = "Wave #%s" % wave_number
