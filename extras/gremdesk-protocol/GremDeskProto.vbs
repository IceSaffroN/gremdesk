Set WshShell = CreateObject("WScript.Shell")

Set oClip = CreateObject("htmlfile")
clipText = oClip.parentWindow.clipboardData.GetData("text")

If WScript.Arguments.Count = 0 Then
    MsgBox "No argument was passed to GremDeskProto.vbs.", vbExclamation, "GremDesk Debug"
Else
    arg = WScript.Arguments(0)
    a = LCase(arg)

    ' Build a path to the BAT next to this VBS (portable)
    Set fso = CreateObject("Scripting.FileSystemObject")
    baseDir = fso.GetParentFolderName(WScript.ScriptFullName)
    batPath = fso.BuildPath(baseDir, "GremDeskProto.bat")

    ' Base command: BAT + protocol arg
    cmd = Chr(34) & batPath & Chr(34) & " " & Chr(34) & arg & Chr(34) & " " & Chr(34) & clipText & Chr(34)

    ' Only include clipboard for commands that actually use it
    If a = "gremdesk://4chan" _
       Or a = "gremdesk://ytdlp/video" _
       Or a = "gremdesk://ytdlp/audio" Then
        cmd = cmd & " " & Chr(34) & clipText & Chr(34)
    End If

    ' Show console only for yt-dlp
    If InStr(a, "gremdesk://ytdlp/video") = 1 Or InStr(a, "gremdesk://ytdlp/audio") = 1 Then
        WshShell.Run cmd, 1, True
    Else
        WshShell.Run cmd, 0, False
    End If
End If
