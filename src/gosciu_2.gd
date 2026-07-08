extends "res://src/npc.gd"
var day = GameLoop.current_day
	
func talk():
	DialogManager.display_line(npc_name,day,"o kurwa FBI")

func help():
	DialogManager.display_line(npc_name,day,"czy chcesz pomoc gosciowi2 w holu")

func order():
	DialogManager.display_line(npc_name,day, "co ma zrobic gosciu2?")
