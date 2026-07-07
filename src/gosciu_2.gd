
extends "res://src/ludkimenu.gd"
var day = 1
var Speaker = "Gosciu 2"

func talk():
	DialogManager.display_line(Speaker,day,"o kurwa FBI")

func help():
	DialogManager.display_line(Speaker,day,"czy chcesz pomoc gosciowi2 w holu")

func order():
	DialogManager.display_line(Speaker,day, "co ma zrobic gosciu2?")
