extends "res://src/ludkimenu.gd"
var day = 1
var Speaker = "gosciu 1"

func talk():
	DialogManager.display_line(Speaker,day,"o siema")
	print("o siema")

func help():
	DialogManager.display_line(Speaker,day,"czy chcesz pomoc gosciowi na dachu?")
	print("czy chcesz pomoc gosciowi na dachu?")

func order():
	DialogManager.display_line(Speaker,day,"co ma zrobic gosciu?")
	print("co ma zrobic gosciu?")
