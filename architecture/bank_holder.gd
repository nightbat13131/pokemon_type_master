class_name BankHolder extends VBoxContainer

@onready var display_color_bank: DisplayBank = %DisplayColorBank

func set_bank_list(list: Array[Choice]) -> void:
	display_color_bank.set_bank_list(list)

func activate() -> void:
	display_color_bank.activate()

func deactivate() -> void:
	display_color_bank.deactivate()
