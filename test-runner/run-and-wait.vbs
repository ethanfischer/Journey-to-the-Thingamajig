Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Users\ethan\Repos\Journey-to-the-Thingamajig\test-runner"
WshShell.Run "cmd /c node capture-errors.js", 1, True
