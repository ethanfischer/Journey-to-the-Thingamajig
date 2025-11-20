# Claude Code Project Context

## Project: Journey to the Thingamajig - HaxeFlixel Port

### Overview
Porting a Flash/ActionScript 3 game to HaxeFlixel for modern web browsers (HTML5/JavaScript).

### Current Status (2025-11-19)

**Working Branch:** `feature/haxeflixel-port`

**Completed:** Tasks 1-6 of 12
- Git preservation (flash-original branch, v1.0-flash tag)
- HaxeFlixel development environment installed
- Project structure created (Project.xml, source/)
- Main.hx entry point converted
- Registry.hx global state converted
- MainMenuState.hx basic stub created
- **Milestone: Game compiles and runs in browser!**

**Next:** Tasks 7-12
- AssetPaths helper class
- Full MainMenuState with assets
- Remove Flash source files
- Update index.html
- Update README
- Create deployment script

### Implementation Plan
See: `docs/plans/2025-11-19-haxeflixel-port.md`

### How to Continue Development

**Recommended approach:**
```
Use superpowers:subagent-driven-development to execute tasks 7-12
from docs/plans/2025-11-19-haxeflixel-port.md
```

**Alternative:**
Execute tasks manually, one at a time, following the plan.

### Build Commands

**Development:**
```bash
lime test html5
```

**Production:**
```bash
lime build html5 -final
```

### Key Files

- `Project.xml` - HaxeFlixel configuration
- `source/Main.hx` - Entry point
- `source/Registry.hx` - Global state container
- `source/MainMenuState.hx` - Menu state (currently stub)
- `docs/plans/2025-11-19-haxeflixel-port.md` - Implementation plan
- `docs/WINDOWS_SETUP.md` - Windows setup instructions

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
- Code review between tasks (using superpowers:code-reviewer)

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

**Strategy:**
- Minimal code changes (in-place conversion)
- Preserve original structure where possible
- Simplify dependencies (use built-in HaxeFlixel features)
- Focus on HTML5 web deployment

### Task Progress Tracking

When resuming development, use TodoWrite to track tasks 7-12:
```
Task 7: Create AssetPaths Helper
Task 8: Update MainMenuState with Real Assets
Task 9: Remove Flash Source Files
Task 10: Update index.html for HaxeFlixel
Task 11: Update README
Task 12: Create Deployment Script
```

### Design Documents

- `docs/plans/2025-11-19-haxeflixel-port-design.md` - High-level design
- `docs/plans/2025-11-19-haxeflixel-port.md` - Detailed implementation plan

### For Windows Development

See `docs/WINDOWS_SETUP.md` for complete Windows setup instructions.

### Verification

Test that current build works:
```bash
lime test html5
```

Expected: Browser shows blue gradient with "Journey to the Thingamajig" title.
