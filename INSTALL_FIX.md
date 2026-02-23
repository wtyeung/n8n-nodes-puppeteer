# Installation Error Fix

## Problem

When installing `n8n-nodes-puppeteer` via npm, users encountered the following error:

```
npm error yallist_1.Yallist is not a constructor
npm error lru_cache_1.default is not a constructor
```

This error occurred during the installation process when n8n tried to install the package with the command:
```bash
npm install --audit=false --fund=false --bin-links=false --install-strategy=shallow --ignore-scripts=true --package-lock=false
```

## Root Cause

The issue was caused by a dependency version conflict with the `lru-cache` package. Newer versions of `lru-cache` (v10+) use ES modules and have breaking changes in their constructor exports, which are incompatible with some of the dependencies used by Puppeteer and its related packages (specifically `@puppeteer/browsers`).

The error manifested in two ways:
1. `yallist_1.Yallist is not a constructor` - yallist is a dependency of lru-cache
2. `lru_cache_1.default is not a constructor` - lru-cache constructor issue with CommonJS imports

## Solution

### 1. Updated Puppeteer to Latest Version

Updated Puppeteer from `24.1.1` to `24.37.5` (latest). The newer version includes:
- Updated `@puppeteer/browsers` from `2.7.0` to `2.13.0`
- Better dependency management
- Latest Chrome/Chromium support
- Security fixes and improvements

### 2. Added Dependency Overrides

Added an `overrides` section to `package.json` to force npm to use compatible versions:

```json
"overrides": {
  "lru-cache": "^7.18.3"
}
```

### Why lru-cache v7?

- **v10+**: Uses ES modules with breaking changes, incompatible with CommonJS imports
- **v7.18.3**: Last stable v7 release, uses CommonJS, compatible with all dependencies
- **v6 and below**: Too old, missing features required by newer packages

## Changes Made

### 1. Updated `package.json`
Added the `overrides` section to force lru-cache v7.18.3 across all dependencies.

### 2. Fixed TypeScript Compilation Errors
Fixed compatibility issues in `nodes/Puppeteer/Puppeteer.node.options.ts`:
- Removed unused `NodeConnectionType` import
- Changed `group` from `['puppeteer']` to `['transform']` (valid n8n group)
- Added proper codex metadata for n8n marketplace
- Changed `inputs`/`outputs` from enum to string literals (`'main'`)

### 3. Regenerated Dependencies
```bash
rm -rf node_modules package-lock.json
npm install
npm run build
```

## Verification

After applying the fix:
- ✅ `npm install` completes successfully
- ✅ `npm run build` compiles without errors
- ✅ Package builds to `dist/` directory correctly
- ✅ No constructor errors during installation

## For Users

If you're experiencing this error when installing the package in n8n:

1. **If you're the package maintainer**: Publish a new version with these changes
2. **If you're a user**: Wait for the maintainer to publish the fixed version, or:
   - Clone this repository
   - Apply the changes from this fix
   - Build and publish to a private npm registry
   - Install from your private registry

## Additional Fixes Applied

### Deprecation Warnings Eliminated

The package also had deprecation warnings for:
- `glob@7.2.3` - Old version with security vulnerabilities
- `rimraf@3.0.2` - Unsupported version
- `inflight@1.0.6` - Memory leak issues

These were fixed by adding additional overrides to force modern versions:

```json
"overrides": {
  "lru-cache": "^7.18.3",
  "rimraf": "^6.0.0",
  "glob": "^13.0.0",
  "inflight": "npm:@zkochan/inflight@^2.0.0"
}
```

**Why these versions?**
- **rimraf v6**: Latest stable, uses modern glob v13
- **glob v13**: Latest version with security fixes
- **@zkochan/inflight v2**: Maintained fork without memory leaks

After these changes, `npm install` completes with **zero deprecation warnings**.

## Testing

To test the fix locally:

```bash
# Clean install
rm -rf node_modules package-lock.json
npm install

# Build the package
npm run build

# Verify dist output exists
ls -la dist/nodes/Puppeteer/
```

Expected output should include:
- `Puppeteer.node.js`
- `Puppeteer.node.options.js`
- Supporting files

## Version Compatibility

This fix has been tested with:
- Node.js: v18+ (recommended)
- npm: v9+
- n8n: Latest version
- Puppeteer: v24.1.1
