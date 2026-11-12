Scriptname _EDIconWidgetScript extends SKI_WidgetBase  

; PRIVATE VARIABLES -------------------------------------------------------------------------------

_EDQuestScript Property _EDQuest Auto

; PROPERTIES --------------------------------------------------------------------------------------

bool Property Visible
	bool function get()
		return _EDQuest.WidgetVisible
	endFunction

	function set(bool a_val)
		_EDQuest.WidgetVisible = a_val
		if (Ready)
			UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", _EDQuest.WidgetVisible) 
		endIf
	endFunction
endProperty

; EVENTS ------------------------------------------------------------------------------------------

Event OnGameReload()
	Parent.OnGameReload()
	RegisterForModEvent("_ED_StatusUpdated", "OnStatusUpdate")
	RegisterForModEvent("_ED_UIConfigured", "OnUIConfig")
	UpdateStatus()
EndEvent

; @override SKI_WidgetBase
event OnWidgetReset()
	parent.OnWidgetReset()
	
	UI.InvokeBool(HUD_MENU, WidgetRoot + ".setHide", _EDQuest.WidgetHide)

	Int[] styleargs = New Int[2]
	styleargs[0] = _EDQuest.WidgetStyle
	styleargs[1] = _EDQuest.WidgetItems
	UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setStyle", styleargs)

	UI.InvokeBool(HUD_MENU, WidgetRoot + ".setVisible", _EDQuest.WidgetVisible)
	UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setAlpha", _EDQuest.WidgetAlpha)

	If _EDQuest.WidgetOrient == 0
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setOrientation", "vertical")
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setIconSize", 55)
	Else
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setOrientation", "horizontal")
		UI.InvokeInt(HUD_MENU, WidgetRoot + ".setIconSize", 80)
	EndIf

	If _EDQuest.WidgetPos == 0
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionX", 1288 + _EDQuest.WidgetXOffset)	;middle,right
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionY", 250 + _EDQuest.WidgetYOffset)
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setHAnchor", "right")
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setVAnchor", "bottom")
	ElseIf _EDQuest.WidgetPos == 1
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionX", 59 + _EDQuest.WidgetXOffset)		;middle,left
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionY", 250 + (_EDQuest.WidgetYOffset))
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setHAnchor", "left")
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setVAnchor", "bottom")
	ElseIf _EDQuest.WidgetPos == 2
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionX", 485 + _EDQuest.WidgetXOffset)	;bottom, mid
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionY", 705 + _EDQuest.WidgetYOffset)
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setHAnchor", "left")
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setVAnchor", "bottom")
	Else
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionX", 485 + _EDQuest.WidgetXOffset)	;top, mid
		UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPositionY", 90 + (_EDQuest.WidgetYOffset))
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setHAnchor", "left")
		UI.InvokeString(HUD_MENU, WidgetRoot + ".setVAnchor", "top")
	EndIf

	RegisterForModEvent("_ED_StatusUpdated", "OnStatusUpdate")
	RegisterForModEvent("_ED_UIConfigured", "OnUIConfig")
	UpdateStatus()
endEvent

Event OnStatusUpdate(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	UpdateStatus()
EndEvent

Event OnUIConfig(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	OnWidgetReset()
EndEvent

; FUNCTIONS ---------------------------------------------------------------------------------------

; @overrides SKI_WidgetBase
string function GetWidgetSource()
	return "lootanddegradation/equipicons.swf"
endFunction

; @overrides SKI_WidgetBase
string function GetWidgetType()
	; Must be the same as scriptname
	return "EDIconWidgetScript"
endFunction

Function UpdateStatus()
	Int[] weaptypeargs = New Int[2]
	weaptypeargs[0] = _EDQuest.WeapType(_EDQuest.MHWeapType)	;mh
	weaptypeargs[1] = _EDQuest.WeapType(_EDQuest.OHWeapType)	;oh
	UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setType", weaptypeargs)	;0 sword, 1 dagger, 2 axe, 3 mace, 4 bow, 5 xbow, 6 staff, 7 shield

	Int[] healthargs = New Int[6]
	healthargs = _EDQuest.EquipHealth
	UI.InvokeIntA(HUD_MENU, WidgetRoot + ".setCount", healthargs)

	String[] stateargs = New String[6]
	stateargs = _EDQuest.EquipState
	UI.InvokeStringA(HUD_MENU, WidgetRoot + ".setState", stateargs)
EndFunction