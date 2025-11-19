# HaxeFlixel Port Design

**Date:** 2025-11-19
**Goal:** Convert "Journey to the Thingamajig" from ActionScript 3/Flash to HaxeFlixel targeting HTML5/JavaScript for web deployment

## Overview

Port the Flash game to HaxeFlixel with minimal code changes, in-place replacement of the Flash project, preserving the original via git history. Focus on web deployment to maintain GitHub Pages hosting.

## Project Setup & Preservation

**Git preservation:**
- Create archive branch `flash-original` from current state
- Tag current commit as `v1.0-flash`
- Continue work on current branch (gh-pages)

**File structure transformation:**
- Convert `src/*.as` → `source/*.hx` (HaxeFlixel convention)
- Keep `assets/` directory as-is (HaxeFlixel compatible)
- Keep `map/` directory for DAME map files
- Replace `jttt.as3proj` with `Project.xml` (HaxeFlixel project file)
- Add `project.json` for Haxe/Lime configuration
- Remove Flash-specific files: `*.swf`, `bin/`, `obj/`, `lib/*.swc`

**New build output:**
- `export/html5/bin/` - compiled JavaScript/HTML5 game
- Update `index.html` to load HaxeFlixel build

## Code Conversion Strategy

**ActionScript to Haxe syntax changes:**
- Package declarations: Keep same structure
- Imports: `import org.flixel.*` → `import flixel.*`
- Type changes: `int`→`Int`, `uint`→`UInt`, `Number`→`Float`, `Boolean`→`Bool`
- Constructor: `public function ClassName()` → `public function new()`
- Most other syntax compatible

**Flixel → HaxeFlixel API changes:**
- Package rename: `org.flixel.*` → `flixel.*`
- Core classes same: `FlxSprite`, `FlxState`, `FlxGroup`, `FlxText`, `FlxButton`
- Some method names may differ slightly
- Flash display list code removed (HaxeFlixel handles internally)

## Dependency Handling

**Core framework:**
- Flixel → HaxeFlixel: Direct conversion, APIs nearly identical

**Photon Storm plugins:**
- `FlxHealthBar`, `FlxWeapon`/Bullet system: Use `flixel-addons` equivalents
- Missing utilities: Simplify or use built-in alternatives

**GreenSock animation:**
- Replace with `FlxTween` (HaxeFlixel built-in tweening)
- Simpler API, sufficient for game needs

**Audio:**
- `FlxSound` works similarly in HaxeFlixel
- Asset embedding via `Project.xml` instead of `[Embed]` metadata

**DAME maps:**
- Custom loader or manual conversion if needed
- Fallback: Parse as CSV/raw data

## Build System & Deployment

**Development setup:**
1. Install Haxe (latest stable)
2. Install via haxelib: `flixel`, `flixel-addons`, `lime`, `openfl`
3. Setup: `haxelib run lime setup`

**Project configuration:**
- `Project.xml` defines: metadata, window size (800x400), assets, dependencies

**Build commands:**
- Development: `lime test html5`
- Production: `lime build html5 -final`

**GitHub Pages deployment:**
- Copy `export/html5/bin/` contents to root or update index.html
- Commit and push to gh-pages branch

## Implementation Approach

**Phase 1: Core infrastructure**
- Set up HaxeFlixel project
- Convert Main, Registry, MainMenuState
- Convert simplest level + Player with basic movement
- Get minimal playable version

**Phase 2: Game mechanics**
- Convert all entity classes (enemies, objects, particles)
- Convert all levels
- Implement collision and physics
- Port game states

**Phase 3: Polish & assets**
- Integrate audio
- Load sprites and animations
- Convert UI and text
- Implement effects

**Phase 4: Testing & deployment**
- Play through all levels
- Fix bugs
- Optimize
- Deploy to GitHub Pages

**Per-file workflow:**
1. Copy `src/File.as` to `source/File.hx`
2. Update package/imports
3. Fix syntax (types, constructor)
4. Update API calls
5. Test compile
6. Delete `.as` file once working

**Safety:**
- Commit after each working phase
- Flash branch available for reference

## Post-Conversion

**Deployment:**
- Build: `lime build html5 -final`
- Deploy to gh-pages
- Game accessible at http://ethanfischer.github.io/Journey-to-the-Thingamajig/

**Documentation:**
- Update README with HaxeFlixel build instructions
- Remove Flash-specific notes
- Add Haxe/HaxeFlixel information

**Cleanup:**
- Remove Flash artifacts
- Update `.gitignore` for Haxe outputs (`export/`, `.haxelib/`)
- Archive `flash-original` branch for reference

**Known limitations:**
- Some visual effects may differ slightly
- Performance characteristics different (JS vs Flash)
- Minor API differences may require small tweaks
- DAME map loading may need custom solution
