# Changelog - Dependency Fixes

## Version 1.4.4

### Updated

#### Puppeteer to Latest Version
- **Updated**: Puppeteer from `24.1.1` to `24.37.5` (latest)
- **Updated**: `@puppeteer/browsers` from `2.7.0` to `2.13.0` (via Puppeteer update)
- **Benefit**: Better dependency management, latest Chrome support, security fixes
- **Compatibility**: Fully compatible with puppeteer-extra and all plugins
- **Result**: Zero breaking changes, all existing code works without modification

### Fixed

#### Critical Installation Error
- **Fixed**: `yallist_1.Yallist is not a constructor` error during npm installation
- **Fixed**: `lru_cache_1.default is not a constructor` error in Puppeteer browser download
- **Root Cause**: Incompatibility between lru-cache v10+ (ES modules) and CommonJS dependencies
- **Solution**: Added override to force lru-cache v7.18.3 (last stable CommonJS version)

#### Deprecation Warnings Eliminated
- **Fixed**: `glob@7.2.3` deprecation warning (security vulnerabilities)
- **Fixed**: `rimraf@3.0.2` deprecation warning (unsupported version)
- **Fixed**: `inflight@1.0.6` deprecation warning (memory leak)
- **Solution**: Added overrides to force modern, maintained versions

#### TypeScript Compilation Errors
- **Fixed**: Unused `NodeConnectionType` import causing TS6133 error
- **Fixed**: Invalid group type `['puppeteer']` causing TS2322 error
- **Fixed**: NodeConnectionType enum usage causing TS2693 errors
- **Solution**: Updated to use string literals and valid n8n node configuration

### Changed

#### package.json
Added `overrides` section to ensure dependency compatibility:
```json
"overrides": {
  "lru-cache": "^7.18.3",
  "rimraf": "^6.0.0",
  "glob": "^13.0.0",
  "inflight": "npm:@zkochan/inflight@^2.0.0"
}
```

#### nodes/Puppeteer/Puppeteer.node.options.ts
- Removed unused `NodeConnectionType` import
- Changed `group` from `['puppeteer']` to `['transform']`
- Added proper `codex` metadata for n8n marketplace
- Added `subtitle` for better UX
- Changed `inputs`/`outputs` from enum to string literals

### Technical Details

**Main Dependency Updates:**
- `puppeteer`: `24.1.1` → `24.37.5` (direct update)
- `@puppeteer/browsers`: `2.7.0` → `2.13.0` (via Puppeteer)

**Forced Dependency Version Changes (via overrides):**
- `lru-cache`: Any version → `^7.18.3` (forced via override)
- `rimraf`: `3.0.2` → `6.1.3` (forced via override)
- `glob`: `7.2.3` → `13.0.6` (forced via override)
- `inflight`: `1.0.6` → `@zkochan/inflight@2.0.0` (forced via override)

**Installation Results:**
- ✅ Zero deprecation warnings
- ✅ 418 packages installed successfully
- ✅ TypeScript compilation successful
- ✅ Build completes without errors
- ✅ All functionality preserved

### Verification

```bash
# Clean install
rm -rf node_modules package-lock.json
npm install
# Output: No deprecation warnings

# Build
npm run build
# Output: Successful compilation

# Verify dependency tree
npm ls glob rimraf inflight lru-cache
# Output: All overridden to correct versions
```

### Migration Guide

For users upgrading from previous versions:

1. Pull the latest changes
2. Delete `node_modules` and `package-lock.json`
3. Run `npm install`
4. Run `npm run build`

No code changes required in your workflows - all fixes are internal to the package.

### Notes

- The overrides ensure compatibility across all transitive dependencies
- No breaking changes to the public API
- All existing Puppeteer functionality remains unchanged
- Compatible with latest n8n versions
- Security vulnerabilities in old glob versions are now resolved

### Files Modified

- `package.json` - Added overrides section
- `nodes/Puppeteer/Puppeteer.node.options.ts` - Fixed TypeScript errors and n8n compatibility
- `INSTALL_FIX.md` - Added (documentation of the fix)
- `CHANGELOG_FIXES.md` - Added (this file)

### Credits

These fixes address issues reported by the n8n community when installing the package via the Community Nodes interface.
