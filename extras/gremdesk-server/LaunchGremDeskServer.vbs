Set o = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

thisDir = fso.GetParentFolderName(WScript.ScriptFullName)
o.CurrentDirectory = thisDir

rc = o.Run("cmd /c py -3 gremdesk_server.py", 0, True)
If rc <> 0 Then
  o.Run "cmd /c python gremdesk_server.py", 0, False
End If
