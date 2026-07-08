extends "res://src/npc.gd"
var day = GameLoop.current_day

func talk():
	DialogManager.display_line(npc_name,day,"o siema")
	print("o siema")

func help():
	DialogManager.display_line(npc_name,day,"czy chcesz pomoc gosciowi na dachu?")
	print("czy chcesz pomoc gosciowi na dachu?")

func order():
	DialogManager.display_line(npc_name,day,"co ma zrobic gosciu?")
	print("co ma zrobic gosciu?")
