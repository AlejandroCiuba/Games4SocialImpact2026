extends Control
class_name UpgradeMenu

signal stat_updated(stat: Stat)

@onready var money_text: RichTextLabel = %Money

var money: int = 0

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


func write_stat(label: RichTextLabel, value) -> void:
	if value is int:
		label.text = "Current: %d" % value
	elif value is float:
		label.text = "Current: %.2f" % value


func write_money(value: int) -> void:
	money_text.text = "$%d" % [value]
	
	
	
func set_stat(stat: Stat, amount) -> void:
	match stat:
		Stat.SPEED:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/Speed/RichTextLabel, amount)
		Stat.TABLECAP:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/TableCapacity/RichTextLabel, amount)
		Stat.BPPU:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/BoxesPerPickUp/RichTextLabel, amount)
		Stat.DC:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/DeliveryCapacity/RichTextLabel, amount)
		Stat.BPDO:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/BoxesPerDropOff/RichTextLabel, amount)
		Stat.BP:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/BigPromotion/RichTextLabel, amount)
		Stat.BST:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/BoxSpawn/RichTextLabel, amount)
		Stat.DT:
			write_stat($MenuContainer/UpgradeContainer/GridContainer/DeliveryTime/RichTextLabel, amount)


func override_money(value: int) -> void:
	money = value
	write_money(money)


func update_money(amount: int) -> void:
	money += amount
	write_money(money)
	
	if amount > 0:
		$MoneySound.play()


func _on_stat_pressed(stat: Stat) -> void:
	print_debug("Pressed: ", stat)
	stat_updated.emit(stat)
