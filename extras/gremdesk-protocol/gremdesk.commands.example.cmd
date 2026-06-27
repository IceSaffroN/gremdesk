# GremDesk command mappings
# Format:
#   name = <command line to execute>
# Notes:
#   - Router replaces {{CLIP}} with clipboard text (if provided)
#   - Use ^& for multiple commands on one line
#   - Keep paths quoted if they contain spaces

# For testing
# test = cmd /k "echo GremDesk router is working && echo URL reached mapping layer successfully. && echo Clipboard: {{CLIP}}"

# --- System / shell folders (Explorer) ---
thispc = explorer.exe shell:MyComputerFolder
downloadsfolder = explorer.exe shell:Downloads
gremdeskfolder = explorer.exe "C:\Gremster\GremDesk\"


# Applications
photoshop = start "" "C:\Program Files\Adobe\Adobe Photoshop 2025\Photoshop.exe"
sublime = start "" "C:\Program Files\Sublime Text\sublime_text.exe"
discord = start "" "C:\Users\Gremlin\AppData\Local\Discord\Update.exe" --processStart "Discord.exe"
everything = start "" "C:\Program Files (x86)\Everything\Everything.exe"

# Resolution Scripts
4k_mode = start "" "C:\Gremster\MultiMonitorTool\Set_Config1.bat"
gaming_mode = start "" "C:\Gremster\MultiMonitorTool\Set_Config2.bat"

# AI Applications
#stablediffusion = pushd "C:\Gremster\AI\stable-diffusion-webui" ^&^& start "" "webui-user.bat" ^&^& popd
stablediffusion = cmd /k "pushd ""C:\Gremster\AI\stable-diffusion-webui"" && call webui-user.bat"
comfyui = start "" "C:\Gremster\AI\ComfyUI\ComfyUI.exe"

# Downloaders
4chan = cmd /k cd /d C:\Gremster\4chan-downloader ^&^& python inb4404.py --no-new-dir "{{CLIP}}"
ytdlp/video = cmd /k "cd /d C:\Gremster\yt-dlp && yt-dlp.exe --config-location ""C:\Gremster\yt-dlp\yt-dlp.conf"" ""{{CLIP}}"""
ytdlp/audio = cmd /k "cd /d C:\Gremster\yt-dlp && yt-dlp.exe --config-location ""C:\Gremster\yt-dlp\audio-dlp.conf"" ""{{CLIP}}"""