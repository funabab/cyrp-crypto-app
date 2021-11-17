extends Button

export(Color) var _normalColor:Color;
export(Color) var _pressedColor:Color;

func _ready():
	_btn_pressed()
	connect("pressed", self, "_btn_pressed")
	pass

func _btn_pressed():
	if self.group != null &&  self.group.get_pressed_button() == self:
		for btn in self.group.get_buttons():
			if (btn != self):
				btn.modulate = _normalColor
		self.modulate = _pressedColor
	else:
		self.modulate = _normalColor
	pass
