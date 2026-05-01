; ============================================================
;  REI GOKIL - FINAL WORKING
;  https://github.com/reihhd/AA
; ============================================================

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; AUTO-UPDATE (SEDERHANA & AMAN)
; ============================================================
global GITHUB_RAW := "https://raw.githubusercontent.com/reihhd/AA/refs/heads/main/"

CheckForUpdates() {
    local versionUrl := GITHUB_RAW . "version.txt"
    local scriptUrl  := GITHUB_RAW . "ReiGokil.ahk"
    local localVersionFile := A_ScriptDir "\version_local.txt"
    local tempVersion := A_Temp "\rei_version.txt"
    local tempScript  := A_Temp "\rei_new.ahk"
    
    ; Download version.txt
    try {
        Download(versionUrl, tempVersion)
        local newVersion := Trim(FileRead(tempVersion, "UTF-8"))
    } catch {
        return
    }
    
    ; Baca versi lokal
    local currentVersion := ""
    if FileExist(localVersionFile)
        currentVersion := Trim(FileRead(localVersionFile, "UTF-8"))
    
    ; Update jika beda
    if (newVersion != currentVersion) {
        try {
            Download(scriptUrl, tempScript)
            if !FileExist(tempScript)
                return
        } catch {
            return
        }
        
        ; Perintah update (tanpa batch file)
        local cmd := 'cmd /c timeout /t 1 /nobreak >nul & del /f /q "' A_ScriptFullPath '" 2>nul & copy /y "' tempScript '" "' A_ScriptFullPath '" & echo ' newVersion ' > "' localVersionFile '" & start "" "' A_ScriptFullPath '" & del "' tempScript '" 2>nul'
        Run(cmd, , "Hide")
        ExitApp()
    }
}
if !A_IsCompiled
    CheckForUpdates()

; ============================================================
; VARIABLES
; ============================================================
global MacroActive  := false
global ToggleKey    := "F1"
global IsSettingKey := false
global SkillDelay   := 100
global CycleDelay   := 100

global UseZ := false, UseX := false, UseC := false
global UseV := false, UseG := false, UseS := false
global UseF := false, UseE := false, UseClick := false

; ============================================================
; FUNGSI CHECKBOX
; ============================================================
SetUseZ(ctrl, info) { global UseZ := ctrl.Value }
SetUseX(ctrl, info) { global UseX := ctrl.Value }
SetUseC(ctrl, info) { global UseC := ctrl.Value }
SetUseV(ctrl, info) { global UseV := ctrl.Value }
SetUseG(ctrl, info) { global UseG := ctrl.Value }
SetUseS(ctrl, info) { global UseS := ctrl.Value }
SetUseF(ctrl, info) { global UseF := ctrl.Value }
SetUseE(ctrl, info) { global UseE := ctrl.Value }
SetUseClick(ctrl, info) { global UseClick := ctrl.Value }

; ============================================================
; GUI MINIMALIS
; ============================================================
gui := Gui("+AlwaysOnTop -DPIScale", "Rei Gokil")
gui.BackColor := "0A0A0F"
gui.SetFont("s10 cEEEEEE", "Segoe UI")

; Header
gui.Add("Progress", "x0 y0 w340 h1 Background00CCFF Range0-100", 100)
gui.SetFont("s13 cFFFFFF Bold", "Segoe UI")
gui.Add("Text", "x20 y16", "REI GOKIL")
gui.SetFont("s8 cAAAAAA", "Segoe UI")
statusTxt := gui.Add("Text", "x220 y20 w100 h28 +0x200 Background151520 Center", "STANDBY")
gui.Add("Text", "x0 y50 w340 h1 Background1A1A2A")

; Checkbox grid
cbWidth := 80
x1 := 25, x2 := 125, x3 := 225
yStart := 70
rowH := 32

gui.SetFont("s10 cDDDDDD", "Segoe UI")
cbZ := gui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart, cbWidth), "Z")
cbX := gui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart, cbWidth), "X")
cbC := gui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart, cbWidth), "C")
cbV := gui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH, cbWidth), "V")
cbG := gui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH, cbWidth), "G")
cbS := gui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH, cbWidth), "S")
gui.SetFont("s10 cFFAA44", "Segoe UI")
cbF := gui.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH*2, cbWidth), "F")
gui.SetFont("s10 c66FF66", "Segoe UI")
cbE := gui.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH*2, cbWidth), "E")
gui.SetFont("s10 c66AAFF", "Segoe UI")
cbClick := gui.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH*2, cbWidth), "CLICK")

; Events
cbZ.OnEvent("Click", SetUseZ)
cbX.OnEvent("Click", SetUseX)
cbC.OnEvent("Click", SetUseC)
cbV.OnEvent("Click", SetUseV)
cbG.OnEvent("Click", SetUseG)
cbS.OnEvent("Click", SetUseS)
cbF.OnEvent("Click", SetUseF)
cbE.OnEvent("Click", SetUseE)
cbClick.OnEvent("Click", SetUseClick)

; Delay controls
gui.SetFont("s8 c888888", "Segoe UI")
gui.Add("Text", "x20 y176", "DELAY")
skillDelayEdit := gui.Add("Edit", "x70 y173 w50 h20 Center", "100")
gui.Add("UpDown", "Range10-500", 100)
gui.Add("Text", "x135 y176", "ms")
gui.Add("Text", "x190 y176", "LOOP")
cycleDelayEdit := gui.Add("Edit", "x235 y173 w50 h20 Center", "100")
gui.Add("UpDown", "Range10-5000", 100)
gui.Add("Text", "x295 y176", "ms")

; Hotkey setter
gui.Add("Text", "x20 y208", "TOGGLE")
keyLabel := gui.Add("Text", "x80 y205 w60 h22 +0x200 Background151520 Center", "F1")
setKeyBtn := gui.Add("Button", "x150 y205 w60 h22", "SET")
setKeyBtn.OnEvent("Click", SetToggleKey)

; Start/Stop button
gui.SetFont("s10 cFFFFFF Bold", "Segoe UI")
toggleBtn := gui.Add("Button", "x20 y245 w300 h32", ">>  START  [ F1 ]")
toggleBtn.OnEvent("Click", ToggleMacro)

; Footer
gui.Add("Text", "x0 y292 w340 h1 Background00CCFF")
gui.SetFont("s7 c555555", "Segoe UI")
gui.Add("Text", "x0 y300 w340 h18 Center", "rei gokil  |  auto update")

gui.OnEvent("Close", (*) => ExitApp())
gui.Show("w340 h320")

; ============================================================
; HOTKEY
; ============================================================
HotKey(ToggleKey, (*) => ToggleMacro())

SetToggleKey(ctrl, info) {
    global IsSettingKey, ToggleKey, keyLabel, setKeyBtn
    if IsSettingKey {
        IsSettingKey := false
        keyLabel.Text := ToggleKey
        setKeyBtn.Text := "SET"
        return
    }
    IsSettingKey := true
    keyLabel.Text := "..."
    setKeyBtn.Text := "CANCEL"
    SetTimer(WaitForKey, 50)
}

WaitForKey() {
    global IsSettingKey, ToggleKey, MacroActive, keyLabel, setKeyBtn, toggleBtn
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
                keyLabel.Text := kName
                setKeyBtn.Text := "SET"
                IsSettingKey := false
                toggleBtn.Text := MacroActive ? "||  STOP  [ " kName " ]" : ">>  START  [ " kName " ]"
                return
            }
        }
    }
}

ToggleMacro(ctrl := unset, info := unset) {
    global MacroActive, SkillDelay, CycleDelay, IsSettingKey
    global UseZ,UseX,UseC,UseV,UseG,UseS,UseF,UseE,UseClick
    global skillDelayEdit, cycleDelayEdit, statusTxt, toggleBtn, ToggleKey, keyLabel, setKeyBtn

    if IsSettingKey {
        IsSettingKey := false
        keyLabel.Text := ToggleKey
        setKeyBtn.Text := "SET"
        SetTimer(, 0)
        return
    }

    MacroActive := !MacroActive

    if MacroActive {
        SkillDelay := Integer(skillDelayEdit.Value)
        CycleDelay := Integer(cycleDelayEdit.Value)

        if SkillDelay < 50 {
            SkillDelay := 50
            skillDelayEdit.Value := 50
        }
        if CycleDelay < 10
            CycleDelay := 10

        if !(UseZ || UseX || UseC || UseV || UseG || UseS || UseF || UseE || UseClick) {
            TrayTip "Pilih minimal satu skill", "Rei Gokil", 1
            MacroActive := false
            return
        }

        statusTxt.Text := "ACTIVE"
        statusTxt.SetFont("c00FFAA")
        toggleBtn.Text := "||  STOP  [ " ToggleKey " ]"
        SetTimer(MacroLoop, 50)
    } else {
        statusTxt.Text := "STANDBY"
        statusTxt.SetFont("cAAAAAA")
        toggleBtn.Text := ">>  START  [ " ToggleKey " ]"
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
    if UseZ keys.Push("z")
    if UseX keys.Push("x")
    if UseC keys.Push("c")
    if UseV keys.Push("v")
    if UseG keys.Push("g")
    if UseS keys.Push("s")
    if UseF keys.Push("f")
    if UseE keys.Push("e")

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
