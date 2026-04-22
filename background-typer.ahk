#Requires AutoHotkey v2.0
#NoTrayIcon

; --- Data Persistence ---
SettingsFile := A_ScriptDir "\background-typer.ini"

; Check if file exists before reading to prevent accidental creation
LastText := ""
SavedDelay := "60"
if FileExist(SettingsFile) {
    LastText := IniRead(SettingsFile, "Data", "LastText", "")
    SavedDelay := IniRead(SettingsFile, "Settings", "Base Speed (ms)", "60")
}

; --- GUI Definition ---
MainGui := Gui("+AlwaysOnTop -MaximizeBox", "Background Typer")
MainGui.SetFont("s9", "Segoe UI")

MainGui.Add("Text", "w480", "1. Target Status (Focus window and press F1 to lock):")
TargetDisplay := MainGui.Add("Edit", "r1 w480 +ReadOnly +Center", "NOT LOCKED")
TargetDisplay.Opt("BackgroundFF9999") 

MainGui.Add("Text", "xm", "2. Source Text:")
InputEdit := MainGui.Add("Edit", "r10 w480 vInputData", LastText)

MainGui.Add("Text", "xm w120", "3. Base Speed (ms):")
DelayEdit := MainGui.Add("Edit", "x+5 w60", SavedDelay)
MainGui.SetFont("s8 cGray")
MainGui.Add("Text", "x+10", "(Human jitter is applied automatically)")
MainGui.SetFont("s9 cDefault")

; --- Control Buttons ---
StartBtn := MainGui.Add("Button", "xm w110 h35", "Start Typing")
StartBtn.OnEvent("Click", StartTyping)

PauseBtn := MainGui.Add("Button", "x+10 w110 h35", "Pause / Resume")
PauseBtn.OnEvent("Click", (*) => Pause(-1))

ResetBtn := MainGui.Add("Button", "x+10 w110 h35", "Reset / Stop")
ResetBtn.OnEvent("Click", (*) => Reload())

MainGui.OnEvent("Close", SaveAndExit)
MainGui.Show()

Global TargetID := 0

F1:: {
    Global TargetID
    TargetID := WinExist("A")
    Title := WinGetTitle(TargetID)
    TargetDisplay.Value := "LOCKED: " Title
    TargetDisplay.Opt("Background99FF99") 
}

StartTyping(*) {
    Global TargetID
    
    if (!TargetID || !WinExist("ahk_id " TargetID)) {
        TargetDisplay.Value := "ERROR: Select target again (Press F1)"
        TargetDisplay.Opt("BackgroundFF9999")
        return
    }

    RawContent := InputEdit.Value
    if (RawContent == "") {
        return
    }

    BaseDelay := IsNumber(DelayEdit.Value) ? Integer(DelayEdit.Value) : 60
    
    ; Only write to INI if there is actual content to save
    IniWrite(RawContent, SettingsFile, "Data", "LastText")
    IniWrite(BaseDelay, SettingsFile, "Settings", "Base Speed (ms)")

    Loop Parse, RawContent {
        if (A_IsPaused) {
            Pause(1)
        }

        Jitter := Random(-10, 15) 
        ActualDelay := BaseDelay + Jitter
        
        if (A_LoopField = " ") {
            ActualDelay += Random(30, 70)
        }

        try {
            ControlSend("{Raw}" A_LoopField, "Edit1", "ahk_id " TargetID)
        } catch {
            ControlSend("{Raw}" A_LoopField,, "ahk_id " TargetID)
        }
        
        Sleep Max(10, ActualDelay) 
    }
}

SaveAndExit(*) {
    ; Check if the textbox is empty before saving on exit
    if (InputEdit.Value != "") {
        try {
            IniWrite(InputEdit.Value, SettingsFile, "Data", "LastText")
            IniWrite(DelayEdit.Value, SettingsFile, "Settings", "Base Speed (ms)")
        }
    }
    ExitApp()
}
