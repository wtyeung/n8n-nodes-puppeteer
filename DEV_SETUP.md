# Local Development Setup

This guide explains how to develop and test the n8n-nodes-puppeteer package locally.

## Prerequisites

- Node.js 18+ installed
- npm 9+ installed

## Initial Setup

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Build the node**
   ```bash
   npm run build
   ```

## Development Workflows

### Option 1: Quick Test (Recommended)

Build and start n8n with your node loaded:

```bash
npm run dev
```

This will:
1. Build the TypeScript code
2. Run Gulp tasks
3. Start n8n with your custom node loaded
4. Open n8n at http://localhost:5678

Your Puppeteer node will be available in the n8n UI under the "Transform" category.

### Option 2: Watch Mode (For Active Development)

If you're actively making changes and want auto-rebuild:

```bash
npm run watch:n8n
```

This runs two processes concurrently:
1. TypeScript compiler in watch mode (auto-rebuilds on file changes)
2. n8n server

**Note:** You'll need to refresh the n8n UI to see changes after rebuild.

### Option 3: Manual Build + Test

```bash
# Build once
npm run build

# Start n8n
npm run start:n8n
```

## Testing Your Node

1. **Access n8n**: Open http://localhost:5678 in your browser

2. **Create a workflow**:
   - Click "Add node" (+)
   - Search for "Puppeteer Enhanced"
   - Add it to your workflow

3. **Test operations**:

   **Get Screenshot:**
   ```
   URL: https://example.com
   Operation: Get Screenshot
   Type: PNG
   Full Page: true
   ```

   **Custom Script:**
   ```javascript
   await $page.goto('https://example.com');
   const title = await $page.title();
   return [{ title }];
   ```

4. **Execute**: Click "Execute Workflow" to test

## Project Structure

```
n8n-nodes-puppeteer/
├── nodes/
│   └── Puppeteer/
│       ├── Puppeteer.node.ts          # Main node implementation
│       ├── Puppeteer.node.options.ts  # Node configuration
│       └── puppeteer.svg              # Node icon
├── dist/                              # Compiled output (generated)
│   └── nodes/
│       └── Puppeteer/
│           ├── Puppeteer.node.js
│           └── Puppeteer.node.options.js
├── package.json                       # Package configuration
└── tsconfig.json                      # TypeScript config
```

## Common Development Tasks

### Rebuild After Changes

```bash
npm run build
```

### Check for TypeScript Errors

```bash
npx tsc --noEmit
```

### Lint Code

```bash
npm run lint
```

### Auto-fix Linting Issues

```bash
npm run lintfix
```

### Validate Node Structure

```bash
npm run nodelinter
```

## Debugging

### Enable Debug Logging

Set environment variable before starting n8n:

```bash
N8N_LOG_LEVEL=debug npm run start:n8n
```

### Check Console Output

When running custom scripts, use `console.log()`:

```javascript
await $page.goto('https://example.com');
console.log('Page loaded!');
const title = await $page.title();
console.log('Title:', title);
return [{ title }];
```

Output appears in:
- **Test mode**: n8n UI console
- **Production**: stdout (if `CODE_ENABLE_STDOUT=true`)

### Common Issues

**Issue: "Module not found"**
- Solution: Run `npm run build` to compile TypeScript

**Issue: "Node not appearing in n8n"**
- Solution: Check that `dist/nodes/Puppeteer/Puppeteer.node.js` exists
- Restart n8n after building

**Issue: "Browser launch failed"**
- Solution: Install Chrome/Chromium dependencies (see main README)
- Or use remote browser with WebSocket endpoint

**Issue: Changes not reflected**
- Solution: Rebuild with `npm run build` and refresh n8n UI
- Or use `npm run watch:n8n` for auto-rebuild

## Environment Variables

You can customize n8n behavior with environment variables:

```bash
# Custom extensions path
N8N_CUSTOM_EXTENSIONS=./dist

# Log level
N8N_LOG_LEVEL=debug

# Port (default: 5678)
N8N_PORT=5678

# Disable telemetry
N8N_DIAGNOSTICS_ENABLED=false

# Enable code stdout
CODE_ENABLE_STDOUT=true

# Allow external modules in scripts
NODE_FUNCTION_ALLOW_EXTERNAL=axios,lodash
```

## Testing with Docker

If you prefer to test in a containerized environment:

```bash
# Build the package
npm run build

# Create a test Docker container
docker run -it --rm \
  -p 5678:5678 \
  -v $(pwd)/dist:/data/custom-nodes \
  -e N8N_CUSTOM_EXTENSIONS=/data/custom-nodes \
  n8nio/n8n
```

## Publishing Workflow

Before publishing to npm:

1. **Update version** in `package.json`
2. **Build**: `npm run build`
3. **Test locally**: `npm run dev`
4. **Lint**: `npm run lint`
5. **Commit changes**: `git commit -am "Release v1.x.x"`
6. **Tag**: `git tag v1.x.x`
7. **Publish**: `npm publish`
8. **Push**: `git push && git push --tags`

## Tips

- **Use TypeScript**: Get better autocomplete and type checking
- **Test incrementally**: Build and test after each feature
- **Check examples**: See `examples/` directory for workflow templates
- **Read logs**: n8n logs provide valuable debugging information
- **Use stealth mode**: Enable for sites with bot detection

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community Nodes](https://docs.n8n.io/integrations/community-nodes/)
- [Puppeteer Documentation](https://pptr.dev/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)

## Getting Help

- Check `INSTALL_FIX.md` for installation issues
- See `REDESIGN_PROPOSAL.md` for architecture insights
- Review `plan.md` for project overview
- Open an issue on GitHub for bugs
