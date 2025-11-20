# Journey to the Thingamajig

A platformer game, originally created in Flash/ActionScript 3, now ported to HaxeFlixel for modern web browsers.

**Play it here:** http://ethanfischer.github.io/Journey-to-the-Thingamajig/

## About

This was my first personal project, started in summer 2013 and published on GameJolt and Kongregate in 2016.

In 2025, the game was ported from Flash to HaxeFlixel to ensure it continues to work in modern browsers (now that Flash is deprecated). The original Flash version is preserved in the `flash-original` branch and tagged as `v1.0-flash`.

## Technology

**Current (HaxeFlixel):**
- **Language:** Haxe
- **Framework:** HaxeFlixel
- **Target:** HTML5/JavaScript (web browsers)
- **Tools:** Haxe, Lime, OpenFL

**Original (Flash):**
- **Language:** ActionScript 3
- **Framework:** Flixel
- **Target:** Flash SWF
- **Tools:** Flex compiler, FlashDevelop, DAME (level editor), Piskel (sprites)

## Building from Source

### Prerequisites

1. Install Haxe: https://haxe.org/download/
2. Install required libraries:
   ```bash
   haxelib install lime
   haxelib install openfl
   haxelib install flixel
   haxelib install flixel-addons
   haxelib run lime setup
   ```

### Development Build

```bash
lime test html5
```

This compiles the game and opens it in your default browser. The build output is in `export/html5/bin/`.

### Production Build

```bash
lime build html5 -final
```

This creates an optimized build in `export/html5/bin/`.

### Deployment

To deploy to GitHub Pages:

```bash
./deploy.sh
```

This script copies the production build files to the root directory and commits them to the `gh-pages` branch.

## Project Structure

- `source/` - Haxe source code
- `assets/` - Game assets (graphics, audio, maps)
- `map/` - DAME level editor files
- `docs/` - Documentation and design notes
- `export/` - Build output (generated, not committed)

## Development Notes

- The game is currently in early HaxeFlixel port stage
- Main menu is functional with placeholder functionality
- Full game states and entities still need conversion
- Original Flash code preserved in `flash-original` branch for reference

## Windows Setup

See `docs/WINDOWS_SETUP.md` for detailed Windows development environment setup instructions.

## License

Feel free to modify the code as you wish.

## Credits

Created by Ethan Fischer
