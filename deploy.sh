#!/bin/bash

# Journey to the Thingamajig - Deployment Script
# Builds the HaxeFlixel game and deploys to GitHub Pages

set -e  # Exit on error

echo "========================================="
echo "Journey to the Thingamajig - Deployment"
echo "========================================="
echo ""

# Check if we're on the right branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "feature/haxeflixel-port" ] && [ "$CURRENT_BRANCH" != "gh-pages" ]; then
    echo "Warning: You're not on feature/haxeflixel-port or gh-pages branch."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deployment cancelled."
        exit 1
    fi
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "Error: You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

echo ""
echo "Step 1: Building production version..."
echo "---------------------------------------"

# Build the game (use lime or haxelib run lime depending on what's available)
if command -v lime &> /dev/null; then
    lime build html5 -final
elif command -v haxelib &> /dev/null; then
    haxelib run lime build html5 -final
else
    echo "Error: Neither 'lime' nor 'haxelib' found in PATH."
    echo "Please install Haxe and Lime, or add them to your PATH."
    exit 1
fi

echo ""
echo "Step 2: Checking build output..."
echo "---------------------------------------"

if [ ! -d "export/html5/bin" ]; then
    echo "Error: Build output directory not found at export/html5/bin/"
    exit 1
fi

if [ ! -f "export/html5/bin/index.html" ]; then
    echo "Error: index.html not found in build output"
    exit 1
fi

echo "Build output verified."

echo ""
echo "Step 3: Deploying to GitHub Pages..."
echo "---------------------------------------"

# Switch to gh-pages branch
echo "Switching to gh-pages branch..."
git checkout gh-pages

# Remove old build files (but keep assets, source, docs, etc.)
echo "Cleaning old build files..."
rm -f index.html
rm -f *.js
rm -f *.js.map
rm -rf mods/
rm -rf manifest/

# Copy new build files
echo "Copying new build files..."
cp -r export/html5/bin/* .

# Add and commit
echo "Committing changes..."
git add .
git commit -m "Deploy HaxeFlixel build to GitHub Pages

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>" || echo "No changes to commit"

echo ""
echo "Step 4: Pushing to GitHub..."
echo "---------------------------------------"

read -p "Push to GitHub? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push origin gh-pages
    echo ""
    echo "✓ Deployment complete!"
    echo "Your game should be live at:"
    echo "http://ethanfischer.github.io/Journey-to-the-Thingamajig/"
else
    echo "Skipped push. You can manually push later with:"
    echo "  git push origin gh-pages"
fi

echo ""
echo "Switching back to $CURRENT_BRANCH..."
git checkout "$CURRENT_BRANCH"

echo ""
echo "========================================="
echo "Deployment script finished!"
echo "========================================="
