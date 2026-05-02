#Requires AutoHotkey v2.0
#SingleInstance Force

global MacroActive  := false
global ToggleKey    := "F1"
global IsSettingKey := false
global SkillDelay   := 10
global CycleDelay   := 100

global UseZ := false
global UseX := false
global UseC := false
global UseV := false
global UseG := false
global UseS := false
global UseF := false
global UseE := false
global UseClick := false

SetUseZ(ctrl, info) {
    global UseZ
    UseZ := ctrl.Value
}
SetUseX(ctrl, info) {
    global UseX
    UseX := ctrl.Value
}
SetUseC(ctrl, info) {
    global UseC
    UseC := ctrl.Value
}
SetUseV(ctrl, info) {
    global UseV
    UseV := ctrl.Value
}
SetUseG(ctrl, info) {
    global UseG
    UseG := ctrl.Value
}
SetUseS(ctrl, info) {
    global UseS
    UseS := ctrl.Value
}
SetUseF(ctrl, info) {
    global UseF
    UseF := ctrl.Value
}
SetUseE(ctrl, info) {
    global UseE
    UseE := ctrl.Value
}
SetUseClick(ctrl, info) {
    global UseClick
    UseClick := ctrl.Value
}

MyGui := Gui("+AlwaysOnTop -DPIScale", "Anime Apocalypse")
MyGui.BackColor := "0A0A0F"

MyGui.Add("Progress", "x0 y0 w340 h1 Background00CCFF Range0-100", 100)
MyGui.SetFont("s13 cFFFFFF Bold", "Segoe UI")
MyGui.Add("Text", "x20 y16", "Anime Apocalypse")
MyGui.SetFont("s8 cFFDD00 Bold", "Segoe UI")
global StatusTxt := MyGui.Add("Text", "x230 y18 w90 h22 +0x200 Background151520 Center", "READY")
MyGui.Add("Text", "x0 y50 w340 h1 Background1A1A2A")

MyGui.SetFont("s9 cCCCCCC", "Segoe UI")
global Tabs := MyGui.Add("Tab3", "x0 y54 w340 h230 Background0A0A0F", ["  MACRO  ", "  HELP  "])

Tabs.UseTab(1)

cbWidth := 90
x1 := 35, x2 := 125, x3 := 215
yStart := 88
rowH := 32

MyGui.SetFont("s10 cDDDDDD", "Segoe UI")
global CbZ     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart,        cbWidth), "Z")
global CbX     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart,        cbWidth), "X")
global CbC     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart,        cbWidth), "C")
global CbV     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH,   cbWidth), "V")
global CbG     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH,   cbWidth), "G")
global CbS     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH,   cbWidth), "S")
MyGui.SetFont("s10 cFFAA44", "Segoe UI")
global CbF     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH*2, cbWidth), "F")
MyGui.SetFont("s10 c66FF66", "Segoe UI")
global CbE     := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH*2, cbWidth), "E")
MyGui.SetFont("s10 c66AAFF", "Segoe UI")
global CbClick := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH*2, cbWidth), "CLICK")

CbZ.OnEvent("Click", SetUseZ)
CbX.OnEvent("Click", SetUseX)
CbC.OnEvent("Click", SetUseC)
CbV.OnEvent("Click", SetUseV)
CbG.OnEvent("Click", SetUseG)
CbS.OnEvent("Click", SetUseS)
CbF.OnEvent("Click", SetUseF)
CbE.OnEvent("Click", SetUseE)
CbClick.OnEvent("Click", SetUseClick)

MyGui.SetFont("s8 c888888", "Segoe UI")
MyGui.Add("Text",                                 "x25  y200", "DELAY")
global SkillDelayEdit := MyGui.Add("Edit",        "x70  y197 w50 h20 Center", "10")
MyGui.Add("UpDown", "Range1-500", 10)
MyGui.Add("Text",                                 "x125 y200", "ms")
MyGui.Add("Text",                                 "x155 y200", "LOOP")
global CycleDelayEdit := MyGui.Add("Edit",        "x198 y197 w50 h20 Center", "100")
MyGui.Add("UpDown", "Range10-5000", 100)
MyGui.Add("Text",                                 "x253 y200", "ms")

MyGui.Add("Text", "x0 y226 w340 h1 Background1A1A2A")

MyGui.Add("Text",                                 "x25  y236", "HOTKEY")
global KeyLabel  := MyGui.Add("Text",   "x85  y233 w60 h22 +0x200 Background151520 Center", "F1")
global SetKeyBtn := MyGui.Add("Button", "x155 y233 w60 h22", "SET")
SetKeyBtn.OnEvent("Click", SetToggleKey)

Tabs.UseTab(2)

helpRows := [
    ["Z / X / C", "Skill"],
    ["V",         "Mastery 100"],
    ["S",         "Walk Back"],
    ["E",         "Gadget  (Black Hole recommended)"],
    ["G",         "Ultimate"],
    ["F",         "Saiyan Helper / Revive"],
    ["CLICK",     "Auto Left Click  (M1)"],
]
yy := 90
for r in helpRows {
    MyGui.SetFont("s8 cFFFFFF Bold", "Segoe UI")
    MyGui.Add("Text", "x25 y" yy " w65", r[1])
    MyGui.SetFont("s8 c555577", "Segoe UI")
    MyGui.Add("Text", "x96 y" yy " w224", r[2])
    yy += 18
}

MyGui.Add("Text", "x0 y" (yy+6) " w340 h1 Background1A1A2A")
MyGui.SetFont("s7 c333355", "Segoe UI")
MyGui.Add("Text", "x25 y" (yy+13) " w300", "Delay = gap between each key press (ms)")
MyGui.Add("Text", "x25 y" (yy+25) " w300", "Loop  = gap between each skill cycle (ms)")

Tabs.UseTab(0)

MyGui.Add("Text", "x0 y286 w340 h1 Background1A1A2A")
MyGui.SetFont("s10 cFFFFFF Bold", "Segoe UI")
global ToggleBtn := MyGui.Add("Button", "x20 y294 w300 h32", "START  [ F1 ]")
ToggleBtn.OnEvent("Click", ToggleMacro)

MyGui.Add("Text", "x0 y332 w340 h1 Background00CCFF")
MyGui.SetFont("s7 c333344", "Segoe UI")
MyGui.Add("Text", "x0 y340 w340 h18 Center", "rei  |  1.0.1")

MyGui.OnEvent("Close", (*) => ExitApp())
MyGui.Show("w340 h360")

HotKey(ToggleKey, (*) => ToggleMacro())

SetToggleKey(ctrl, info) {
    global IsSettingKey, ToggleKey, KeyLabel, SetKeyBtn
    if IsSettingKey {
        IsSettingKey   := false
        KeyLabel.Text  := ToggleKey
        SetKeyBtn.Text := "SET"
        return
    }
    IsSettingKey   := true
    KeyLabel.Text  := "..."
    SetKeyBtn.Text := "CANCEL"
    SetTimer(WaitForKey, 50)
}

WaitForKey() {
    global IsSettingKey, ToggleKey, MacroActive, KeyLabel, SetKeyBtn, ToggleBtn
    if !IsSettingKey {
        SetTimer(, 0)
        return
    }
    skipList := ["LButton","RButton","MButton","","UNKNOWN","Ctrl","Alt","Shift",
                 "LCtrl","RCtrl","LAlt","RAlt","LShift","RShift","LWin","RWin"]
    Loop 254 {
        try {
            vk    := Format("vk{:02x}", A_Index)
            kName := GetKeyName(vk)
            if kName = "" || kName = "UNKNOWN"
                continue
            found := false
            for s in skipList
                if kName = s
                    found := true
            if !found && GetKeyState(kName, "P") {
                SetTimer(, 0)
                try HotKey(ToggleKey, (*) => ToggleMacro(), "Off")
                ToggleKey      := kName
                HotKey(ToggleKey, (*) => ToggleMacro())
                KeyLabel.Text  := kName
                SetKeyBtn.Text := "SET"
                IsSettingKey   := false
                ToggleBtn.Text := MacroActive
                    ? "STOP  [ " kName " ]"
                    : "START  [ " kName " ]"
                return
            }
        }
    }
}

ToggleMacro(ctrl := unset, info := unset) {
    global MacroActive, SkillDelay, CycleDelay, IsSettingKey
    global UseZ, UseX, UseC, UseV, UseG, UseS, UseF, UseE, UseClick
    global SkillDelayEdit, CycleDelayEdit, StatusTxt, ToggleBtn, ToggleKey, KeyLabel, SetKeyBtn

    if IsSettingKey {
        IsSettingKey   := false
        KeyLabel.Text  := ToggleKey
        SetKeyBtn.Text := "SET"
        SetTimer(, 0)
        return
    }

    MacroActive := !MacroActive

    if MacroActive {
        SkillDelay := Integer(SkillDelayEdit.Value)
        CycleDelay := Integer(CycleDelayEdit.Value)
        if SkillDelay < 1
            SkillDelay := 1
        if CycleDelay < 10
            CycleDelay := 10

        if !(UseZ || UseX || UseC || UseV || UseG || UseS || UseF || UseE || UseClick) {
            TrayTip "No skill selected", "Anime Apocalypse", 1
            MacroActive := false
            return
        }

        StatusTxt.Text := "ACTIVE"
        StatusTxt.SetFont("c00FFAA Bold")
        ToggleBtn.Text := "STOP  [ " ToggleKey " ]"
        SetTimer(MacroLoop, 50)
    } else {
        StatusTxt.Text := "READY"
        StatusTxt.SetFont("cFFDD00 Bold")
        ToggleBtn.Text := "START  [ " ToggleKey " ]"
        SetTimer(MacroLoop, 0)
    }
}

MacroLoop() {
    global MacroActive, SkillDelay, CycleDelay
    global UseZ, UseX, UseC, UseV, UseG, UseS, UseF, UseE, UseClick

    SetTimer(MacroLoop, 0)
    if !MacroActive
        return

    keys := []
    if UseZ
        keys.Push("z")
    if UseX
        keys.Push("x")
    if UseC
        keys.Push("c")
    if UseV
        keys.Push("v")
    if UseG
        keys.Push("g")
    if UseS
        keys.Push("s")
    if UseF
        keys.Push("f")
    if UseE
        keys.Push("e")

    for k in keys {
        if !MacroActive
            return
        SendInput("{" k " down}")
        Sleep(30)
        SendInput("{" k " up}")
        Sleep(SkillDelay)
    }

    if UseClick && MacroActive {
        Click()
        Sleep(SkillDelay)
    }

    if MacroActive
        SetTimer(MacroLoop, CycleDelay)
}
