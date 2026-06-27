# GremDesk command mappings
# Copy this file to gremdesk.commands.cmd, then customize it for your machine.
#
# Format:
#   name = <command line to execute>
#
# Notes:
#   - Router replaces {{CLIP}} with clipboard text if the command contains {{CLIP}}
#   - Use ^& for multiple commands on one line
#   - Keep paths quoted if they contain spaces

# - System / shell folders (Explorer) -
thispc = explorer.exe shell:MyComputerFolder
downloadsfolder = explorer.exe shell:Downloads
documentsfolder = explorer.exe shell:Personal
desktopfolder = explorer.exe shell:Desktop

# - Applications -
# Copy this file to gremdesk.commands.cmd, then change these paths to match your PC.
notepad = start "" "notepad.exe"
sublime = start "" "C:\Program Files\Sublime Text\sublime_text.exe"
discord = start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart "Discord.exe"
everything = start "" "C:\Program Files\Everything\Everything.exe"

# - Local projects / tools -
projectfolder = explorer.exe "%USERPROFILE%\Documents"

# - Optional download helpers -
# These examples expect yt-dlp to be installed separately.
ytdlp/video = cmd /k "yt-dlp ""{{CLIP}}"""
ytdlp/audio = cmd /k "yt-dlp -x --audio-format mp3 ""{{CLIP}}"""