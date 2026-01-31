Set o = CreateObject("WScript.Shell")

' Ensure Python finds its stdlib even though we renamed the exe
o.Environment("PROCESS")("PYTHONHOME") = "C:\Program Files\Python310"

' Serve from your GremDesk folder
o.CurrentDirectory = "C:\Gremster\GremDesk\extras\gremdesk-server"

' Launch hidden, but now the process name is GremDeskServer.exe
' o.Run """C:\Gremster\GremDesk\extras\gremdesk-server\GremDeskServer.exe"" -m http.server 8080", 0
o.Run """GremDeskServer.exe"" gremdesk_server.py", 0
