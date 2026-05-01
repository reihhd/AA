; ============================================================
;  REI GOKIL - FINAL WORKING (NO GUI ERROR)
;  https://github.com/reihhd/AA
; ============================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; VARIABLES
; ============================================================
global MacroActive  := false
global ToggleKey    := "F1"
global IsSettingKey := false
global SkillDelay   := 100
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

; ============================================================
; FUNGSI CHECKBOX
; ============================================================
SetUseZ(ctrl, info) {
    global UseZ := ctrl.Value
}
SetUseX(ctrl, info) {
    global UseX := ctrl.Value
}
SetUseC(ctrl, info) {
    global UseC := ctrl.Value
}
SetUseV(ctrl, info) {
    global UseV := ctrl.Value
}
SetUseG(ctrl, info) {
    global UseG := ctrl.Value
}
SetUseS(ctrl, info) {
    global UseS := ctrl.Value
}
SetUseF(ctrl, info) {
    global UseF := ctrl.Value
}
SetUseE(ctrl, info) {
    global UseE := ctrl.Value
}
SetUseClick(ctrl, info) {
    global UseClick := ctrl.Value
}

; ============================================================
; GUI (GUNAKAN NAMA VARIABEL MyGui)
; ============================================================
MyGui := Gui("+AlwaysOnTop -DPIScale", "Rei Gokil")
MyGui.BackColor := "0A0A0F"
MyGui.SetFont("s10 cEEEEEE", "Segoe UI")

MyGui.Add("Progress", "x0 y0 w340 h1 Background00CCFF Range0-100", 100)
MyGui.SetFont("s13 cFFFFFF Bold", "Segoe UI")
MyGui.Add("Text", "x20 y16", "REI GOKIL")
MyGui.SetFont("s8 cAAAAAA", "Segoe UI")
global StatusTxt := MyGui.Add("Text", "x220 y20 w100 h28 +0x200 Background151520 Center", "STANDBY")
MyGui.Add("Text", "x0 y50 w340 h1 Background1A1A2A")

; Checkbox grid
cbWidth := 80
x1 := 25, x2 := 125, x3 := 225
yStart := 70
rowH := 32

MyGui.SetFont("s10 cDDDDDD", "Segoe UI")
global CbZ := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart, cbWidth), "Z")
global CbX := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart, cbWidth), "X")
global CbC := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart, cbWidth), "C")
global CbV := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH, cbWidth), "V")
global CbG := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH, cbWidth), "G (ULTIMATE)")
global CbS := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH, cbWidth), "S")
MyGui.SetFont("s10 cFFAA44", "Segoe UI")
global CbF := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH*2, cbWidth), "F")
MyGui.SetFont("s10 c66FF66", "Segoe UI")
global CbE := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH*2, cbWidth), "E")
MyGui.SetFont("s10 c66AAFF", "Segoe UI")
global CbClick := MyGui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH*2, cbWidth), "CLICK")

; Events
CbZ.OnEvent("Click", SetUseZ)
CbX.OnEvent("Click", SetUseX)
CbC.OnEvent("Click", SetUseC)
CbV.OnEvent("Click", SetUseV)
CbG.OnEvent("Click", SetUseG)
CbS.OnEvent("Click", SetUseS)
CbF.OnEvent("Click", SetUseF)
CbE.OnEvent("Click", SetUseE)
CbClick.OnEvent("Click", SetUseClick)

; Delay controls
MyGui.SetFont("s8 c888888", "Segoe UI")
MyGui.Add("Text", "x20 y176", "DELAY")
global SkillDelayEdit := MyGui.Add("Edit", "x70 y173 w50 h20 Center", "100")
MyGui.Add("UpDown", "Range10-500", 100)
MyGui.Add("Text", "x135 y176", "ms")
MyGui.Add("Text", "x190 y176", "LOOP")
global CycleDelayEdit := MyGui.Add("Edit", "x235 y173 w50 h20 Center", "100")
MyGui.Add("UpDown", "Range10-5000", 100)
MyGui.Add("Text", "x295 y176", "ms")

; Hotkey setter
MyGui.Add("Text", "x20 y208", "TOGGLE")
global KeyLabel := MyGui.Add("Text", "x80 y205 w60 h22 +0x200 Background151520 Center", "F1")
global SetKeyBtn := MyGui.Add("Button", "x150 y205 w60 h22", "SET")
SetKeyBtn.OnEvent("Click", SetToggleKey)

; Start/Stop button
MyGui.SetFont("s10 cFFFFFF Bold", "Segoe UI")
global ToggleBtn := MyGui.Add("Button", "x20 y245 w300 h32", ">>  START  [ F1 ]")
ToggleBtn.OnEvent("Click", ToggleMacro)

; Footer
MyGui.Add("Text", "x0 y292 w340 h1 Background00CCFF")
MyGui.SetFont("s7 c555555", "Segoe UI")
MyGui.Add("Text", "x0 y300 w340 h18 Center", "rei gokil  |  auto update")

MyGui.OnEvent("Close", (*) => ExitApp())
MyGui.Show("w340 h320")

; ============================================================
; HOTKEY
; ============================================================
HotKey(ToggleKey, (*) => ToggleMacro())

; ============================================================
; FUNGSI LAINNYA
; ============================================================
SetToggleKey(ctrl, info) {
    global IsSettingKey, ToggleKey, KeyLabel, SetKeyBtn
    if IsSettingKey {
        IsSettingKey := false
        KeyLabel.Text := ToggleKey
        SetKeyBtn.Text := "SET"
        return
    }
    IsSettingKey := true
    KeyLabel.Text := "..."
    SetKeyBtn.Text := "CANCEL"
    SetTimer(WaitForKey, 50)
}

WaitForKey() {
    global IsSettingKey, ToggleKey, MacroActive, KeyLabel, SetKeyBtn, ToggleBtn
    if !IsSettingKey {
        SetTimer(, 0)
        return
    }
    skipList := ["LButton","RButton","MButton","","UNKNOWN","Ctrl","Alt","Shift","LCtrl","RCtrl","LAlt","RAlt","LShift","RShift","LWin","RWin"]
    Loop 254 {
        try {
            vk := Format("vk{:02x}", A_Index)
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
                ToggleKey := kName
                HotKey(ToggleKey, (*) => ToggleMacro())
                KeyLabel.Text := kName
                SetKeyBtn.Text := "SET"
                IsSettingKey := false
                ToggleBtn.Text := MacroActive ? "||  STOP  [ " kName " ]" : ">>  START  [ " kName " ]"
                return
            }
        }
    }
}

ToggleMacro(ctrl := unset, info := unset) {
    global MacroActive, SkillDelay, CycleDelay, IsSettingKey
    global UseZ,UseX,UseC,UseV,UseG,UseS,UseF,UseE,UseClick
    global SkillDelayEdit, CycleDelayEdit, StatusTxt, ToggleBtn, ToggleKey, KeyLabel, SetKeyBtn

    if IsSettingKey {
        IsSettingKey := false
        KeyLabel.Text := ToggleKey
        SetKeyBtn.Text := "SET"
        SetTimer(, 0)
        return
    }

    MacroActive := !MacroActive

    if MacroActive {
        SkillDelay := Integer(SkillDelayEdit.Value)
        CycleDelay := Integer(CycleDelayEdit.Value)

        if SkillDelay < 50 {
            SkillDelay := 50
            SkillDelayEdit.Value := 50
        }
        if CycleDelay < 10
            CycleDelay := 10

        if !(UseZ || UseX || UseC || UseV || UseG || UseS || UseF || UseE || UseClick) {
            TrayTip "Pilih minimal satu skill", "Rei Gokil", 1
            MacroActive := false
            return
        }

        StatusTxt.Text := "ACTIVE"
        StatusTxt.SetFont("c00FFAA")
        ToggleBtn.Text := "||  STOP  [ " ToggleKey " ]"
        SetTimer(MacroLoop, 50)
    } else {
        StatusTxt.Text := "STANDBY"
        StatusTxt.SetFont("cAAAAAA")
        ToggleBtn.Text := ">>  START  [ " ToggleKey " ]"
        SetTimer(MacroLoop, 0)
    }
}

MacroLoop() {
    global MacroActive, SkillDelay, CycleDelay
    global UseZ,UseX,UseC,UseV,UseG,UseS,UseF,UseE,UseClick

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
