
extends Node

export(String, FILE, ".*txt") var squeme
export(String) var rule

var RULES = {}

func _ready():
	var file = File.new()
	var file_content = ""
	
	if file.file_exists(squeme):
		file.open(squeme, File.READ)
		file_content = file.get_as_text()
		file.close()
	
	process_file(file_content)
	#print_rules()
	
	print(evaluate("LEVEL"))
	
func print_rules():
	for r in RULES:
		print("Rule: ", r)
		for o in RULES[r]:
			print("Operation: ", o)

func process_file(content):
	var lines = content.split("\n")
	for line in lines:
		if not line.empty() and not line.begins_with("#"):
			process_line(line)

func process_line(line):
	var parts = line.split("=")
	var name = parts[0].strip_edges()
	var body = parts[1].strip_edges()
	
	RULES[name] = []
	var operations = []
	for o in body.split("|"):
		operations.append(o.split(" ", false))
	RULES[name] = operations

func evaluate(rule_name):
	randomize()
	return eval_rule(RULES["<"+rule_name+">"])

func eval_rule(rule):
	var salida = []
	var operation = rule[randi() % rule.size()]
	for e in operation:
		salida += eval_element(e)
	return salida

func eval_element(elem):
	if elem.match("<*>"):
		return eval_rule(RULES[elem])
	elif elem.match("\"*\""):
		return [elem.substr(1, elem.length()-2)]