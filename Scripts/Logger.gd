extends Node

func custom_log(message, level="INFO", indent=0):
	var color = "white"
	match level:
		"INFO":
			color = "blue"
		"DEBUG":
			color = "cyan"
		"SUCCESS":
			color = "green"
		"WARNING":
			color = "yellow"
		"ERROR":
			color = "red"

	var indent_str = ""
	for i in range(indent):
		indent_str += "    "  # 4 spaces per indent level

	print_rich("[color=" + color + "]" + indent_str + "[" + level + "] " + message + "[/color]")
