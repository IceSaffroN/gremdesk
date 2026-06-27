Option Explicit

Dim WshShell : Set WshShell = CreateObject("WScript.Shell")
Dim fso      : Set fso      = CreateObject("Scripting.FileSystemObject")

If WScript.Arguments.Count = 0 Then
  MsgBox "No argument was passed to GremDesk protocol handler.", vbExclamation, "GremDesk"
  WScript.Quit 1
End If

Dim rawUrl : rawUrl = WScript.Arguments(0)

Dim baseDir : baseDir = fso.GetParentFolderName(WScript.ScriptFullName)
Dim commandsPath : commandsPath = fso.BuildPath(baseDir, "gremdesk.commands.cmd")
Dim examplePath  : examplePath  = fso.BuildPath(baseDir, "gremdesk.commands.example.cmd")

Dim mapPath
If fso.FileExists(commandsPath) Then
  mapPath = commandsPath
ElseIf fso.FileExists(examplePath) Then
  mapPath = examplePath
Else
  MsgBox "No commands file found:" & vbCrLf & commandsPath & vbCrLf & examplePath, vbExclamation, "GremDesk"
  WScript.Quit 1
End If

' --- Parse URL into key ---
Dim key : key = NormalizeKey(rawUrl)
If Len(key) = 0 Then
  MsgBox "Empty route: " & rawUrl, vbExclamation, "GremDesk"
  WScript.Quit 1
End If

' --- Lookup command ---
Dim cmdLine : cmdLine = LookupCommand(mapPath, LCase(key))
If Len(cmdLine) = 0 Then
  MsgBox "Unknown command: " & key & vbCrLf & "(from " & mapPath & ")", vbExclamation, "GremDesk"
  WScript.Quit 2
End If

' --- Clipboard only if needed ({{CLIP}} present) ---
If InStr(1, cmdLine, "{{CLIP}}", vbTextCompare) > 0 Then
  Dim clipText : clipText = GetClipboardText()
  If IsNull(clipText) Then clipText = ""
  If Len(clipText) > 1000 Then clipText = "clipboard text is more than 1000 characters"
  cmdLine = Replace(cmdLine, "{{CLIP}}", clipText)
End If

' --- Decide console visibility ---
Dim showConsole : showConsole = False

' Rule 1: if the command uses "cmd /k" it wants a visible console
If InStr(1, cmdLine, "cmd /k", vbTextCompare) > 0 Then showConsole = True

' Optional: keep your key-based console rules
' If Left(LCase(key), 5) = "ytdlp" Then showConsole = True

' --- Run it ---
Dim cmd
If showConsole Then
  cmd = "cmd.exe /k " & Chr(34) & cmdLine & Chr(34)
  WshShell.Run cmd, 1, True
Else
  cmd = "cmd.exe /s /c " & cmdLine
  WshShell.Run cmd, 0, False
End If


' =========================
' Helpers
' =========================

Function NormalizeKey(u)
  Dim s : s = CStr(u)

  ' Strip gremdesk:// (case-insensitive)
  If LCase(Left(s, 11)) = "gremdesk://" Then s = Mid(s, 12)

  ' Trim trailing slashes
  Do While Len(s) > 0
    Dim lastCh : lastCh = Right(s, 1)
    If lastCh = "/" Or lastCh = "\" Then
      s = Left(s, Len(s) - 1)
    Else
      Exit Do
    End If
  Loop

  ' URL-decode (handles %20 etc). Safe even if nothing to decode.
  On Error Resume Next
  Dim html : Set html = CreateObject("htmlfile")
  s = html.parentWindow.unescape(s)
  On Error GoTo 0

  NormalizeKey = s
End Function

Function LookupCommand(filePath, keyLower)
  Dim ts : Set ts = fso.OpenTextFile(filePath, 1, False)
  Dim line, k, v, eqPos
  LookupCommand = ""

  Do Until ts.AtEndOfStream
    line = Trim(ts.ReadLine)

    If Len(line) = 0 Then
      ' skip
    ElseIf Left(line, 1) = "#" Or Left(line, 1) = ";" Then
      ' comment
    Else
      eqPos = InStr(1, line, "=", vbBinaryCompare)
      If eqPos > 1 Then
        k = Trim(Left(line, eqPos - 1))
        v = Trim(Mid(line, eqPos + 1))
        If LCase(k) = keyLower Then
          LookupCommand = v
          Exit Do
        End If
      End If
    End If
  Loop

  ts.Close
End Function

Function GetClipboardText()
  On Error Resume Next
  Dim oClip : Set oClip = CreateObject("htmlfile")
  GetClipboardText = oClip.parentWindow.clipboardData.GetData("text")
  On Error GoTo 0
End Function
