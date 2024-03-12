class_name Utils

static func anim_in(text : String, output: Label, final, allow_speedup: bool = true, should_cancel = null, cancel_argument : bool = false):
	var idx = 0
	var divisor = 1
	for char in text:
		if Input.is_anything_pressed() and allow_speedup:
			divisor = 100.0
		else:
			divisor = 1.0
		if should_cancel != null:
			if should_cancel.call():
				print_debug("HIT CANCEL")
				output.text = ""
				if cancel_argument:
					final.call(true)
				else:
					final.call()
				return
		# just do timeouts
		# scene could have changed
		if not is_instance_valid(output): return
		if not is_instance_valid(output.get_tree()): return
		if char == " ":
			await output.get_tree().create_timer(0.1/divisor).timeout
		elif char == "\n":
			await output.get_tree().create_timer(0.2/divisor).timeout
		else:
			await output.get_tree().create_timer(0.05/divisor).timeout
		if not is_instance_valid(output): return
		# if not is_instance_valid(output.get_tree()): return
		output.text += char
	if not final == null:
		if cancel_argument:
			final.call(false)
		else:
			final.call()
