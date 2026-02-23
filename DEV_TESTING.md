# Local Development & Testing Guide

## The Problem

Installing n8n as a dev dependency causes dependency conflicts (lru-cache constructor errors). The solution is to test with a globally installed n8n instance instead.

---

## ✅ Recommended: Test with Global n8n

### Step 1: Install n8n Globally

```bash
npm install -g n8n
```

### Step 2: Build Your Node

```bash
npm run build
```

### Step 3: Install Your Node in n8n

**Option A: Via npm (Recommended for Testing)**

```bash
# In your node directory
npm pack

# This creates: laheud-n8n-nodes-puppeteer-1.4.4.tgz

# Install in n8n
n8n install @laheud/n8n-nodes-puppeteer@file:./laheud-n8n-nodes-puppeteer-1.4.4.tgz
```

**Option B: Via Community Nodes (After Publishing)**

1. Start n8n: `n8n start`
2. Open http://localhost:5678
3. Go to Settings > Community Nodes
4. Install `@laheud/n8n-nodes-puppeteer`

### Step 4: Start n8n

```bash
n8n start
```

Your Puppeteer node will be available at http://localhost:5678

---

## 🔄 Development Workflow

### Making Changes

1. **Edit code** in `nodes/Puppeteer/`
2. **Rebuild**: `npm run build`
3. **Reinstall** in n8n:
   ```bash
   npm pack
   n8n install @laheud/n8n-nodes-puppeteer@file:./laheud-n8n-nodes-puppeteer-1.4.4.tgz
   ```
4. **Restart n8n**: Stop (Ctrl+C) and run `n8n start`
5. **Refresh** browser

### Watch Mode

For active development:

```bash
# Terminal 1: Auto-rebuild on changes
npm run watch

# Terminal 2: Run n8n
n8n start

# After changes: Reinstall and restart n8n
```

---

## 🐳 Alternative: Docker Testing

If you prefer Docker (recommended for production-like testing):

### Build Docker Image

```bash
docker build -t n8n-puppeteer -f docker/Dockerfile .
```

### Run Container

```bash
docker run -it --rm \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8n-puppeteer
```

Access at http://localhost:5678

---

## 🧪 Quick Test Workflow

Once n8n is running, test your node:

### 1. Create New Workflow

- Open http://localhost:5678
- Click "Add workflow"

### 2. Add Puppeteer Node

- Click the "+" button
- Search for "Puppeteer Enhanced"
- Add to canvas

### 3. Test Screenshot

```
Operation: Get Screenshot
URL: https://example.com
Type: PNG
Full Page: true
```

Click "Execute Node" → Check output

### 4. Test Custom Script

```javascript
await $page.goto('https://example.com');
const title = await $page.title();
const links = await $page.$$eval('a', anchors => 
  anchors.slice(0, 5).map(a => ({
    text: a.textContent?.trim(),
    href: a.href
  }))
);

return [{ title, links, timestamp: new Date().toISOString() }];
```

Click "Execute Node" → Check output

---

## 📦 Publishing Workflow

### 1. Update Version

```bash
npm version patch  # or minor, or major
```

### 2. Build

```bash
npm run build
```

### 3. Test Locally

```bash
npm pack
n8n install @laheud/n8n-nodes-puppeteer@file:./laheud-n8n-nodes-puppeteer-1.4.4.tgz
n8n start
# Test thoroughly
```

### 4. Publish to npm

```bash
npm publish
```

### 5. Install in n8n

Users can now install via Community Nodes:
- Settings > Community Nodes
- Install `@laheud/n8n-nodes-puppeteer`

---

## 🛠️ Troubleshooting

### "Module not found" after install

```bash
# Rebuild
npm run build

# Repack and reinstall
npm pack
n8n install @laheud/n8n-nodes-puppeteer@file:./laheud-n8n-nodes-puppeteer-1.4.4.tgz
```

### Node doesn't appear in n8n

1. Check `dist/` folder exists
2. Verify `dist/nodes/Puppeteer/Puppeteer.node.js` is present
3. Restart n8n completely
4. Clear browser cache

### Browser launch fails

- **Docker**: Use the provided Dockerfile (includes Chrome)
- **Local**: Install Chrome/Chromium or use remote browser via WebSocket

### Changes not reflected

1. Stop n8n (Ctrl+C)
2. Rebuild: `npm run build`
3. Reinstall: `npm pack` then `n8n install ...`
4. Start n8n: `n8n start`
5. Hard refresh browser (Cmd+Shift+R / Ctrl+Shift+R)

---

## 💡 Why Not Dev Dependency?

Installing n8n as a dev dependency causes conflicts:
- n8n has its own dependency tree
- Our overrides don't affect n8n's dependencies
- Results in `lru_cache_1.LRUCache is not a constructor` error

**Solution**: Use globally installed n8n for testing.

---

## 📚 Additional Resources

- **Build**: See `package.json` scripts
- **TypeScript**: See `TYPESCRIPT_IMPROVEMENTS.md`
- **Installation Fixes**: See `INSTALL_FIX.md`
- **Quick Start**: See `QUICKSTART.md`
- **Architecture**: See `REDESIGN_PROPOSAL.md`

---

## ✅ Summary

**For Development:**
1. Install n8n globally: `npm install -g n8n`
2. Build your node: `npm run build`
3. Pack and install: `npm pack` then `n8n install ...`
4. Test: `n8n start` → http://localhost:5678

**For Production:**
1. Publish to npm: `npm publish`
2. Users install via Community Nodes in n8n UI

This approach avoids dependency conflicts and provides a clean testing environment!
