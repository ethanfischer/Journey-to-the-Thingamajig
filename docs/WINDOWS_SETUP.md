# Windows Setup Guide for HaxeFlixel Port

This guide will help you continue the HaxeFlixel port on your Windows machine.

## Current Status (as of 2025-11-19)

**Completed Tasks (1-6):**
- ✅ Git preservation (flash-original branch and v1.0-flash tag created)
- ✅ HaxeFlixel environment installed
- ✅ Project structure created (Project.xml, source/ directory)
- ✅ Main.hx converted
- ✅ Registry.hx converted with all global state
- ✅ MainMenuState.hx stub created - **GAME RUNS!**

**Remaining Tasks (7-12):**
- ⏳ Task 7: Create AssetPaths Helper
- ⏳ Task 8: Update MainMenuState with Real Assets
- ⏳ Task 9: Remove Flash Source Files
- ⏳ Task 10: Update index.html for HaxeFlixel
- ⏳ Task 11: Update README
- ⏳ Task 12: Create Deployment Script

**Branch:** `feature/haxeflixel-port`

---

## Prerequisites

- Windows 10/11
- Git for Windows
- Visual Studio Code (recommended) or any text editor
- Claude Code CLI

---

## Installation Steps

### 1. Install Haxe

1. Download Haxe for Windows: https://haxe.org/download/
2. Run the installer (haxe-4.3.7-win64.exe or latest)
3. Installer will set up Haxe and Neko automatically
4. Verify installation:
   ```cmd
   haxe --version
   neko -version
   ```

### 2. Install HaxeFlixel Libraries

Open Command Prompt or PowerShell and run:

```cmd
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-addons
haxelib run lime setup
```

When prompted "Do you want to install the 'lime' command?", answer **y** (yes).

### 3. Clone/Update Repository

If you don't have the repo yet:
```cmd
cd C:\Users\YourUsername\Documents
git clone https://github.com/ethanfischer/Journey-to-the-Thingamajig.git
cd Journey-to-the-Thingamajig
```

If you already have it:
```cmd
cd C:\Users\YourUsername\Documents\Journey-to-the-Thingamajig
git fetch origin
git checkout feature/haxeflixel-port
git pull
```

### 4. Verify Build System Works

Test compilation:
```cmd
lime test html5
```

Expected result: Browser opens with the game showing "Journey to the Thingamajig" title and "Press SPACE to start" message.

---

## Continuing Development with Claude Code

### Option 1: Resume with Subagent-Driven Development (Recommended)

1. Open Claude Code in the repository directory
2. Say to Claude:
   ```
   I'm continuing the HaxeFlixel port from Mac. Read docs/WINDOWS_SETUP.md
   and docs/plans/2025-11-19-haxeflixel-port.md. We completed tasks 1-6.
   Use superpowers:subagent-driven-development to continue with tasks 7-12.
   ```

### Option 2: Manual Task-by-Task

1. Open Claude Code
2. Reference the plan: `docs/plans/2025-11-19-haxeflixel-port.md`
3. Start with Task 7: Create AssetPaths Helper
4. Work through tasks 7-12 sequentially

---

## Project Structure

```
Journey-to-the-Thingamajig/
├── Project.xml              # HaxeFlixel project config
├── source/                  # Haxe source files
│   ├── Main.hx             # Entry point
│   ├── Registry.hx         # Global state
│   └── MainMenuState.hx    # Menu state (stub)
├── assets/                  # Game assets (unchanged from Flash)
├── map/                     # Level maps
├── docs/
│   ├── plans/
│   │   └── 2025-11-19-haxeflixel-port.md  # Implementation plan
│   └── WINDOWS_SETUP.md    # This file
├── src/                     # Original ActionScript (will be removed in Task 9)
└── export/                  # Build output (generated)
    └── html5/bin/          # HTML5 build
```

---

## Build Commands

### Development Build (Fast)
```cmd
lime test html5
```
- Compiles in debug mode
- Opens browser automatically
- Hot reload available

### Production Build (Optimized)
```cmd
lime build html5 -final
```
- Minified output
- No debug symbols
- Slower compile, faster runtime

### Clean Build
```cmd
lime clean html5
lime build html5
```

---

## Common Issues on Windows

### Issue: "lime: command not found"
**Solution:** The lime setup didn't complete. Run:
```cmd
haxelib run lime setup
```
Answer 'y' when asked to install the lime command.

### Issue: "Could not find module sys"
**Solution:** Haxe standard library path issue. Reinstall Haxe or set HAXE_STD_PATH:
```cmd
set HAXE_STD_PATH=C:\HaxeToolkit\haxe\std
```

### Issue: Build fails with "icon.png not found"
**Solution:** Already fixed - icon.png exists in assets/. If missing, copy any PNG to assets/icon.png.

---

## Next Steps

After setup, continue with:
1. **Task 7:** Create `source/AssetPaths.hx` with type-safe asset path constants
2. **Task 8:** Update MainMenuState to load real assets (menu graphics, music)
3. **Task 9:** Remove Flash source files (`src/`, `*.swf`)
4. **Task 10:** Update `index.html` for HaxeFlixel deployment
5. **Task 11:** Update README with HaxeFlixel build instructions
6. **Task 12:** Create deployment script for GitHub Pages

See `docs/plans/2025-11-19-haxeflixel-port.md` for detailed implementation steps.

---

## Environment Variables (If Needed)

If you encounter path issues, you may need to set:

```cmd
# Temporary (current session)
set HAXE_STD_PATH=C:\HaxeToolkit\haxe\std
set NEKOPATH=C:\HaxeToolkit\neko

# Permanent (add to System Environment Variables via Control Panel)
HAXE_STD_PATH = C:\HaxeToolkit\haxe\std
NEKOPATH = C:\HaxeToolkit\neko
```

---

## Testing the Current Build

After setup, test that everything works:

```cmd
cd Journey-to-the-Thingamajig
git checkout feature/haxeflixel-port
lime test html5
```

Expected behavior:
- Compiles without errors
- Browser opens to http://localhost:2000
- Shows blue gradient background
- Title: "Journey to the Thingamajig"
- Press SPACE: Shows "PlayState not yet implemented"
- Press ESC: Resets menu

If you see this, you're ready to continue development!

---

## Files Modified So Far

Tasks 1-6 created/modified these files:

**Created:**
- `.gitignore` (updated for Haxe)
- `Project.xml`
- `source/Main.hx`
- `source/Registry.hx`
- `source/MainMenuState.hx`
- `assets/icon.png`
- `docs/plans/2025-11-19-haxeflixel-port-design.md`
- `docs/plans/2025-11-19-haxeflixel-port.md`

**Preserved:**
- Git branch: `flash-original`
- Git tag: `v1.0-flash`

**Unchanged (yet):**
- All original Flash files in `src/`
- All assets in `assets/`
- All maps in `map/`
- Original `index.html` (will update in Task 10)

---

## Support

If you encounter issues:
1. Check this file's "Common Issues" section
2. Check HaxeFlixel docs: https://haxeflixel.com/documentation
3. Check the implementation plan: `docs/plans/2025-11-19-haxeflixel-port.md`
4. Ask Claude Code for help with specific error messages

Good luck with the Windows setup!
