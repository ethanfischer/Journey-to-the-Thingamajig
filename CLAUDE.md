# Claude Code Project Context

## Project: Journey to the Thingamajig - HaxeFlixel Port

### Overview
Porting a Flash/ActionScript 3 game to HaxeFlixel for modern web browsers (HTML5/JavaScript).

### Build Commands

**Development:**
```bash
./build.sh
```

**Production:**
```bash
lime build html5 -final
```

### CRITICAL: Build Verification Rules

After running `./build.sh`, check for "BUILD SUCCEEDED" or "BUILD FAILED" at the end of output.

**Rules:**
- NEVER use `| tail` to truncate build output
- If you see "BUILD FAILED", read the errors and fix them before proceeding
- Only warnings (deprecation, font warnings) are acceptable - errors are not

**Filename case sensitivity:** Haxe requires filenames to match class names exactly. `class Level1` must be in `Level1.hx`, not `level1.hx`. The Write tool on Windows/WSL may lowercase filenames. After writing, verify with `ls` and fix if needed:
```bash
mv source/file.hx source/File_temp.hx && mv source/File_temp.hx source/File.hx
```

### Key Files

- `Project.xml` - HaxeFlixel configuration
- `source/Main.hx` - Entry point
- `source/Registry.hx` - Global state container
- `source/Player.hx` - Player character class
- `source/PlayState.hx` - Main gameplay state
- `source/Level1.hx` - First level
- `source/AssetPaths.hx` - Asset path constants

### Original Flash Version

Preserved in:
- Branch: `flash-original`
- Tag: `v1.0-flash`
- Commit: 8627e62

### Project Conventions

**Worktree location:** `.worktrees/` (hidden directory, already in .gitignore)

**Commit style:**
```
feat: add feature description

Longer description if needed.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Git workflow:**
- Work on `feature/haxeflixel-port` branch
- Commit after each task completion

### Dependencies

**Haxe Libraries (via haxelib):**
- flixel 6.1.1
- flixel-addons 3.3.2
- lime 8.3.0
- openfl 9.5.0

**Environment Variables:**
- `NEKOPATH=/usr/local/neko` (Mac) or `C:\HaxeToolkit\neko` (Windows)
- `HAXE_STD_PATH` may be needed on some systems

### Architecture Notes

**HaxeFlixel vs Flash differences:**
- No `[Embed]` metadata - use string paths instead
- `Main` extends `Sprite` and creates `FlxGame` (not extends FlxGame)
- Asset loading via `Project.xml` instead of compiler flags
- Constructor: `public function new()` instead of `public function Main()`
- Types: `Int`, `Bool`, `Float` instead of `int`, `Boolean`, `Number`
- When overriding `update()`, call `super.update(elapsed)` to let parent handle animation frame advancement

### For Windows Development

See `docs/WINDOWS_SETUP.md` for complete Windows setup instructions.

### Verification

Test that current build works:
```bash
./build.sh
```

Expected: Game runs in browser with working player movement and animations.
