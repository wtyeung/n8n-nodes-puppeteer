# Quick Start - Local Development

## 🚀 Start Testing in 2 Steps

### Step 1: Install dependencies
```bash
npm install
```

### Step 2: Start development server
```bash
npm run dev
```

That's it! n8n will start at **http://localhost:5678** with your node loaded!

> **Note**: We use `@n8n/node-cli` which handles the dev environment automatically.

---

## 📝 Using Your Node

1. Open http://localhost:5678 in your browser
2. Create a new workflow
3. Click the **+** button to add a node
4. Search for **"Puppeteer Enhanced"**
5. Configure and test!

---

## 🧪 Quick Test Examples

### Example 1: Take a Screenshot

1. Add "Puppeteer Enhanced" node
2. Set:
   - **Operation**: Get Screenshot
   - **URL**: `https://example.com`
   - **Type**: PNG
   - **Full Page**: true
3. Click "Execute Node"
4. Check the output for your screenshot!

### Example 2: Get Page Content

1. Add "Puppeteer Enhanced" node
2. Set:
   - **Operation**: Get Page Content
   - **URL**: `https://example.com`
3. Click "Execute Node"
4. See the HTML in the output!

### Example 3: Custom Script

1. Add "Puppeteer Enhanced" node
2. Set:
   - **Operation**: Custom Script
   - **URL**: `https://example.com`
   - **Script**:
     ```javascript
     const title = await $page.title();
     const links = await $page.$$eval('a', anchors => 
       anchors.slice(0, 5).map(a => ({
         text: a.textContent,
         href: a.href
       }))
     );
     
     return [{ title, links }];
     ```
3. Click "Execute Node"
4. See the extracted data!

---

## 🔄 Development Workflow

### Making Changes

1. **Edit code** in `nodes/Puppeteer/`
2. **Rebuild**: `npm run build`
3. **Refresh** the n8n UI in your browser
4. **Test** your changes

### Watch Mode (Auto-rebuild)

For active development, use watch mode:

```bash
npm run watch:n8n
```

This will:
- Auto-rebuild when you save files
- Keep n8n running
- Just refresh the browser to see changes!

---

## 🛠️ Available Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Build + start n8n (recommended) |
| `npm run build` | Build the node once |
| `npm run watch` | Auto-rebuild on file changes |
| `npm run watch:n8n` | Auto-rebuild + run n8n |
| `npm run start:n8n` | Start n8n (without building) |
| `npm run lint` | Check code quality |

---

## 💡 Tips

- **First time?** Run `npm run dev` and open http://localhost:5678
- **Making changes?** Use `npm run watch:n8n` for auto-rebuild
- **Need to debug?** Check the terminal output for errors
- **Node not showing?** Make sure `npm run build` completed successfully

---

## 🐛 Troubleshooting

### Node doesn't appear in n8n

```bash
# Check if dist files exist
ls dist/nodes/Puppeteer/

# Should show:
# Puppeteer.node.js
# Puppeteer.node.options.js
# puppeteer.svg
```

If files are missing, run `npm run build`

### Changes not reflected

1. Stop n8n (Ctrl+C)
2. Run `npm run build`
3. Run `npm run dev`
4. Refresh browser

### Browser launch fails

See the main README.md for Chrome/Chromium installation instructions, or use a remote browser with WebSocket endpoint.

---

## 📚 More Info

- Full development guide: See `DEV_SETUP.md`
- Installation fixes: See `INSTALL_FIX.md`
- Architecture ideas: See `REDESIGN_PROPOSAL.md`
- Project overview: See `plan.md`

---

## 🎉 You're Ready!

Run `npm run dev` and start building awesome browser automation workflows!
