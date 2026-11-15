extends Control
class_name UpgradeMenu

signal stat_updated(stat: Stat)

@onready var money_text: RichTextLabel = %Money

var money: int = 0
var play_sounds: bool = false

enum Stat {
	SPEED,
	TABLECAP,
	BPPU,
	DC,
	BPDO,
	BST,
	DT,
	BP,
}


func get_label(stat: Stat) -> RichTextLabel:
	match stat:
		Stat.SPEED:
			return $MenuContainer/UpgradeContainer/GridContainer/Speed/RichTextLabel
		Stat.TABLECAP:
			return $MenuContainer/UpgradeContainer/GridContainer/TableCapacity/RichTextLabel
		Stat.BPPU:
			return $MenuContainer/UpgradeContainer/GridContainer/BoxesPerPickUp/RichTextLabel
		Stat.DC:
			return $MenuContainer/UpgradeContainer/GridContainer/DeliveryCapacity/RichTextLabel
		Stat.BPDO:
			return $MenuContainer/UpgradeContainer/GridContainer/BoxesPerDropOff/RichTextLabel
		Stat.BP:
			return $MenuContainer/UpgradeContainer/GridContainer/BigPromotion/RichTextLabel
		Stat.BST:
			return $MenuContainer/UpgradeContainer/GridContainer/BoxSpawn/RichTextLabel
		Stat.DT:
			return $MenuContainer/UpgradeContainer/GridContainer/DeliveryTime/RichTextLabel
	return null


func get_button(stat: Stat) -> Button:
	match stat:
		Stat.SPEED:
			return $MenuContainer/UpgradeContainer/GridContainer/Speed/Button
		Stat.TABLECAP:
			return $MenuContainer/UpgradeContainer/GridContainer/TableCapacity/Button
		Stat.BPPU:
			return $MenuContainer/UpgradeContainer/GridContainer/BoxesPerPickUp/Button
		Stat.DC:
			return $MenuContainer/UpgradeContainer/GridContainer/DeliveryCapacity/Button
		Stat.BPDO:
			return $MenuContainer/UpgradeContainer/GridContainer/BoxesPerDropOff/Button
		Stat.BP:
			return $MenuContainer/UpgradeContainer/GridContainer/BigPromotion/Button
		Stat.BST:
			return $MenuContainer/UpgradeContainer/GridContainer/BoxSpawn/Button
		Stat.DT:
			return $MenuContainer/UpgradeContainer/GridContainer/DeliveryTime/Button
	return null


func write_stat(label: RichTextLabel, value) -> void:
	if value is int:
		label.text = "Current: %d" % value
	elif value is float:
		label.text = "Current: %.2f" % value
	if play_sounds:
		$BuySound.play()


func write_button(button: Button, text: String) -> void:
	button.text = text


func write_money(value: int) -> void:
	money_text.text = "$%d" % [value]


func set_button_max(stat: Stat) -> void:

	var button: Button = get_button(stat)
	if button == null:
		return

	button.disabled = true
	write_button(button, button.text + " MAX!")


func set_stat(stat: Stat, amount) -> void:

	var label: RichTextLabel = get_label(stat)
	if label == null:
		return

	write_stat(label, amount)


func override_money(value: int) -> void:
	money = value
	write_money(money)


func update_money(amount: int) -> void:
	money += amount
	write_money(money)

	if amount > 0 and play_sounds:
		$MoneySound.play()


func _on_stat_pressed(stat: Stat) -> void:
	print_debug("Pressed: ", stat)
	stat_updated.emit(stat)
