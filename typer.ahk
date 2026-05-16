#Requires AutoHotkey v2.0
#NoTrayIcon

SettingsFile := A_ScriptDir "\typer-settings.ini"

LastText := ""
SavedDelay := "60"
if FileExist(SettingsFile) {
    LastText := IniRead(SettingsFile, "Data", "LastText", "")
    SavedDelay := IniRead(SettingsFile, "Settings", "Speed (ms)", "60")
}

MainGui := Gui("+AlwaysOnTop -MaximizeBox", "Typer")
MainGui.SetFont("s9", "Segoe UI")

MainGui.Add("Text", "w400", "Text:")
InputEdit := MainGui.Add("Edit", "r10 w400 vInputData", LastText)

MainGui.Add("Text", "xm y+10", "Speed (ms):")
DelayEdit := MainGui.Add("Edit", "x+5 yp-3 w50", SavedDelay) 

StartBtn := MainGui.Add("Button", "xm y+12 w100 h30 Default", "Start")
StartBtn.OnEvent("Click", StartTyping)

StatusDisplay := MainGui.Add("Text", "x280 yp+5 w120 Right", "Ready")

MainGui.OnEvent("Close", SaveAndExit)
MainGui.Show()

StartTyping(*) {
    RawContent := InputEdit.Value
    if (RawContent == "") {
        return
    }

    BaseDelay := IsNumber(DelayEdit.Value) ? Integer(DelayEdit.Value) : 60
    
    IniWrite(RawContent, SettingsFile, "Data", "LastText")
    IniWrite(BaseDelay, SettingsFile, "Settings", "Speed (ms)")

    Loop 3 {
        StatusDisplay.Value := "Wait " (4 - A_Index) "..."
        Sleep(1000)
    }

    StatusDisplay.Value := "Typing..."

    Loop Parse, RawContent {
        Jitter := Random(-10, 15) 
        ActualDelay := BaseDelay + Jitter
        
        SendEvent("{Raw}" A_LoopField)
        
        if (A_LoopField = " ") {
            ActualDelay += Random(30, 70)
        }
        
        Sleep Max(10, ActualDelay) 
    }
    
    StatusDisplay.Value := "Finished"
}

SaveAndExit(*) {
    if (InputEdit.Value != "") {
        try {
            IniWrite(InputEdit.Value, SettingsFile, "Data", "LastText")
            IniWrite(DelayEdit.Value, SettingsFile, "Settings", "Speed (ms)")
        }
    }
    ExitApp()
}
