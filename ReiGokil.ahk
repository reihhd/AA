; ============================================================
;  REI GOKIL - MINIMALIS + AUTO UPDATE
;  AutoHotkey v2
;  https://github.com/reihhd/AA
; ============================================================

#SingleInstance Force
#Requires AutoHotkey v2.0

; ============================================================
; AUTO-UPDATE (CEPAT & AMAN)
; ============================================================

global GITHUB_RAW := "https://raw.githubusercontent.com/reihhd/AA/refs/heads/main/"

CheckForUpdates() {
    local versionUrl := GITHUB_RAW . "version.txt"
    local scriptUrl  := GITHUB_RAW . "ReiGokil.ahk"
    local localVersionFile := A_ScriptDir "\version_local.txt"
    local tempVersion := A_Temp "\rei_version.txt"
    local tempScript  := A_Temp "\rei_new.ahk"

    ; Download version.txt dari GitHub
    try {
        Download(versionUrl, tempVersion)
        local newVersion := Trim(FileRead(tempVersion, "UTF-8"))
    } catch {
        ; Gagal download version.txt → lewati update (koneksi mati / salah URL)
        return
    }

    ; Baca versi lokal (jika ada)
    local currentVersion := ""
    if FileExist(localVersionFile)
        currentVersion := Trim(FileRead(localVersionFile, "UTF-8"))

    ; Jika versi berbeda → lakukan update
    if (newVersion != currentVersion) {
        ; Download script terbaru
        try {
            Download(scriptUrl, tempScript)
            if !FileExist(tempScript)
                return
        } catch {
            return
        }

        ; Buat batch file untuk replace script & restart
        local updater := A_Temp "\rei_update.bat"
        local batContent := 
        (LTrim
            @echo off
            timeout /t 1 /nobreak >nul
            del /f /q "`%A_ScriptFullPath`%" 2>nul
            copy /y "`%tempScript`%" "`%A_ScriptFullPath`%"
            if exist "`%localVersionFile`%" del "`%localVersionFile`%"
            echo `%newVersion%` > "`%localVersionFile`%"
            del "`%tempScript`%" 2>nul
            start "" "`%A_ScriptFullPath`%"
            del "`%~f0" 2>nul
        )
        FileAppend(batContent, updater, "UTF-8")
        Run updater, , "Hide"
        ExitApp()
    }
}

; Jalankan auto update (hanya jika script tidak dalam mode update loop)
if !A_IsCompiled
    CheckForUpdates()

; ============================================================
; VARIABLES UTAMA
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

; ============================================================
; GUI MINIMALIS
; ============================================================
global RG := Gui("+AlwaysOnTop -DPIScale", "Rei Gokil")
RG.BackColor := "0A0A0F"
RG.SetFont("s10 cEEEEEE", "Segoe UI")

; Header
RG.Add("Progress", "x0 y0 w340 h1 Background00CCFF Range0-100", 100)

; Judul
RG.SetFont("s13 cFFFFFF Bold", "Segoe UI")
RG.Add("Text", "x20 y16", "REI GOKIL")

; Status
RG.SetFont("s8 cAAAAAA", "Segoe UI")
global StatusTxt := RG.Add("Text", "x220 y20 w100 h28 +0x200 Background151520 Center", "STANDBY")

; Divider
RG.Add("Text", "x0 y50 w340 h1 Background1A1A2A")

; ============================================================
; CHECKBOX GRID
; ============================================================
cbWidth := 80
x1 := 25, x2 := 125, x3 := 225
yStart := 70
rowH := 32

RG.SetFont("s10 cDDDDDD", "Segoe UI")
global CbZ := RG.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart, cbWidth), "Z")
global CbX := RG.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart, cbWidth), "X")
global CbC := RG.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart, cbWidth), "C")

global CbV := RG.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH, cbWidth), "V")
global CbG := RG.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH, cbWidth), "G")
global CbS := RG.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH, cbWidth), "S")

RG.SetFont("s10 cFFAA44", "Segoe UI")
global CbF := RG.Add("CheckBox", Format("x{} y{} w{} h25", x1, yStart+rowH*2, cbWidth), "F")
RG.SetFont("s10 c66FF66", "Segoe UI")
global CbE := RG.Add("CheckBox", Format("x{} y{} w{} h25", x2, yStart+rowH*2, cbWidth), "E")
RG.SetFont("s10 c66AAFF", "Segoe UI")
global CbClick := RG.Add("CheckBox", Format("x{} y{} w{} h25", x3, yStart+rowH*2, cbWidth), "CLICK")

; Bind events
CbZ.OnEvent("Click", SetUseZ)
CbX.OnEvent("Click", SetUseX)
CbC.OnEvent("Click", SetUseC)
CbV.OnEvent("Click", SetUseV)
CbG.OnEvent("Click", SetUseG)
CbS.OnEvent("Click", SetUseS)
CbF.OnEvent("Click", SetUseF)
CbE.OnEvent("Click", SetUseE)
CbClick.OnEvent("Click", SetUseClick)

; ============================================================
; DELAY SETTING
; ============================================================
RG.SetFont("s8 c888888", "Segoe UI")
RG.Add("Text", "x20 y176", "DELAY")
global SkillDelayEdit := RG.Add("Edit", "x70 y173 w50 h20 Center", "100")
RG.Add("UpDown", "Range10-500", 100)
RG.Add("Text", "x135 y176", "ms")

RG.Add("Text", "x190 y176", "LOOP")
global CycleDelayEdit := RG.Add("Edit", "x235 y173 w50 h20 Center", "100")
RG.Add("UpDown", "Range10-5000", 100)
RG.Add("Text", "x295 y176", "ms")

; ============================================================
; HOTKEY SETTER
; ============================================================
RG.SetFont("s8 c888888", "Segoe UI")
RG.Add("Text", "x20 y208", "TOGGLE")
global KeyLabel := RG.Add("Text", "x80 y205 w60 h22 +0x200 Background151520 Center", "F1")
global SetKeyBtn := RG.Add("Button", "x150 y205 w60 h22", "SET")
SetKeyBtn.OnEvent("Click", SetToggleKey)

; ============================================================
; TOMBOL START/STOP
; ============================================================
RG.SetFont("s10 cFFFFFF Bold", "Segoe UI")
global ToggleBtn := RG.Add("Button", "x20 y245 w300 h32", ">>  START  [ F1 ]")
ToggleBtn.OnEvent("Click", ToggleMacro)

; Footer
RG.Add("Text", "x0 y292 w340 h1 Background00CCFF")
RG.SetFont("s7 c555555", "Segoe UI")
RG.Add("Text", "x0 y300 w340 h18 Center", "rei gokil  |  auto update")

RG.OnEvent("Close", (*) => ExitApp())
RG.Show("w340 h320")

; ============================================================
; HOTKEY SETTING & FUNGSI LAIN
; ============================================================
HotKey(ToggleKey, (*) => ToggleMacro())

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
        SetTimer(WaitForKey, 0)
        return
    }
    skipList := ["LButton","RButton","MButton","","UNKNOWN","Ctrl","Alt","Shift",
                 "LCtrl","RCtrl","LAlt","RAlt","LShift","RShift","LWin","RWin"]
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
                SetTimer(WaitForKey, 0)
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
        SetTimer(WaitForKey, 0)
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
