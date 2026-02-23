# Development Guide

This project uses `@n8n/node-cli` for development, following the same pattern as [n8n-nodes-instance-secret](https://github.com/wtyeung/n8n-nodes-instance-secret).

---

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Start Development Server
```bash
npm run dev
```

This will:
- Build your TypeScript code
- Start n8n with your node loaded
- Watch for changes and auto-reload

Access n8n at **http://localhost:5678**

---

## 📝 Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server with hot reload |
| `npm run build` | Build TypeScript + Gulp tasks |
| `npm run build:watch` | Watch mode for TypeScript compilation |
| `npm run lint` | Check code quality with ESLint |
| `npm run lint:fix` | Auto-fix linting issues |
| `npm run format` | Format code with Prettier |
| `npm run format:check` | Check code formatting |

---

## 🔄 Development Workflow

### Making Changes

1. **Edit code** in `nodes/Puppeteer/`
2. **Save** - Changes auto-reload with `npm run dev`
3. **Test** in n8n UI (refresh browser if needed)

### Watch Mode (Alternative)

If you prefer manual control:

```bash
# Terminal 1: Watch TypeScript
npm run build:watch

# Terminal 2: Run n8n separately
npx n8n start
```

---

## 🧪 Testing Your Node

Once `npm run dev` is running:

1. Open http://localhost:5678
2. Create a new workflow
3. Add "Puppeteer Enhanced" node
4. Test any operation

### Example: Screenshot Test

```
Operation: Get Screenshot
URL: https://example.com
Type: PNG
Full Page: true
```

### Example: Custom Script

```javascript
await $page.goto('https://example.com');
const title = await $page.title();
const links = await $page.$$eval('a', anchors => 
  anchors.slice(0, 5).map(a => ({
    text: a.textContent?.trim(),
    href: a.href
  }))
);

return [{ title, links }];
```

---

## 🏗️ Project Structure

```
n8n-nodes-puppeteer/
├── nodes/
│   └── Puppeteer/
│       ├── Puppeteer.node.ts          # Main node implementation
│       ├── Puppeteer.node.options.ts  # Node configuration
│       ├── types.d.ts                 # Type declarations
│       └── puppeteer.svg              # Node icon
├── dist/                              # Compiled output (generated)
├── package.json                       # Package configuration
├── tsconfig.json                      # TypeScript config
└── gulpfile.js                        # Build tasks
```

---

## 🔧 Configuration

### TypeScript

The project uses strict TypeScript settings in `tsconfig.json`:
- Strict mode enabled
- No implicit any
- Strict null checks
- Full type safety

### ESLint

Linting is handled by `@n8n/node-cli` with n8n's recommended rules.

### Prettier

Code formatting follows n8n's style guide.

---

## 📦 Building for Production

### Build

```bash
npm run build
```

This creates the `dist/` folder with compiled code.

### Verify Build

```bash
ls dist/nodes/Puppeteer/
# Should show:
# - Puppeteer.node.js
# - Puppeteer.node.options.js
# - puppeteer.svg
# - .d.ts files
```

---

## 🚢 Publishing

### 1. Update Version

```bash
npm version patch  # or minor, or major
```

### 2. Build

```bash
npm run build
```

### 3. Publish

```bash
npm publish
```

The `prepublishOnly` script automatically runs the build.

---

## 🐛 Troubleshooting

### "Module not found" errors

```bash
npm install
npm run build
```

### Node doesn't appear in n8n

1. Check `dist/` folder exists
2. Restart dev server: Stop (Ctrl+C) and `npm run dev`
3. Clear browser cache

### TypeScript errors

```bash
# Check for errors
npx tsc --noEmit

# Fix linting
npm run lint:fix
```

### Browser launch fails

- Install Chrome/Chromium dependencies
- Or use remote browser via WebSocket endpoint
- See main README for Docker setup

---

## 🎯 Why @n8n/node-cli?

The `@n8n/node-cli` provides:

✅ **Integrated dev server** - No manual n8n setup needed  
✅ **Hot reload** - Changes reflect automatically  
✅ **Proper linting** - n8n's official ESLint rules  
✅ **Build tools** - Handles TypeScript compilation  
✅ **No dependency conflicts** - Manages n8n internally  

This is the **official n8n way** to develop community nodes.

---

## 📚 Resources

- **n8n Node CLI**: https://www.npmjs.com/package/@n8n/node-cli
- **Community Nodes Guide**: https://docs.n8n.io/integrations/community-nodes/
- **n8n Documentation**: https://docs.n8n.io/
- **Puppeteer Docs**: https://pptr.dev/

---

## ✨ Best Practices

1. **Use `npm run dev`** for development
2. **Run `npm run lint:fix`** before committing
3. **Format code** with `npm run format`
4. **Test thoroughly** before publishing
5. **Follow TypeScript** strict mode
6. **Document changes** in commit messages

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `npm run lint:fix`
5. Test with `npm run dev`
6. Submit a pull request

---

Happy coding! 🎉
