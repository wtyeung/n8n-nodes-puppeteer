# n8n-nodes-puppeteer Development Plan

## Project Overview

**Repository**: `@laheud/n8n-nodes-puppeteer`  
**Version**: 1.4.3  
**Type**: n8n Community Node Package  
**Purpose**: Browser automation using Puppeteer for n8n workflows

This is a fork with improved browserWSEndpoint handling that provides browser automation capabilities including:
- Custom script execution with full Puppeteer API access
- Screenshot capture (JPEG, PNG, WebP)
- PDF generation
- Page content extraction
- Web scraping and automation

## Technology Stack

### Core Dependencies
- **Puppeteer**: v24.1.1 - Browser automation library
- **puppeteer-extra**: v3.3.6 - Plugin framework for Puppeteer
- **puppeteer-extra-plugin-stealth**: v2.11.2 - Detection avoidance
- **puppeteer-extra-plugin-human-typing**: Custom fork for realistic typing
- **@n8n/vm2**: v3.9.25 - Sandboxed script execution
- **n8n-workflow**: Peer dependency for n8n integration

### Development Tools
- **TypeScript**: v5.7.2
- **ESLint**: v9.17.0 with n8n-nodes-base plugin
- **Gulp**: v5.0.0 - Build automation
- **Prettier**: v3.4.2 - Code formatting

## Project Structure

```
n8n-nodes-puppeteer/
├── nodes/
│   └── Puppeteer/
│       ├── Puppeteer.node.ts          # Main node implementation
│       ├── Puppeteer.node.options.ts  # Node configuration & options
│       └── types.d.ts                 # TypeScript type definitions
├── docker/
│   ├── Dockerfile                     # Production Docker setup
│   └── docker-custom-entrypoint.sh    # Container initialization
├── .github/
│   └── workflows/                     # CI/CD pipelines
├── images/                            # Documentation screenshots
├── dist/                              # Compiled output (generated)
├── package.json                       # Project configuration
├── tsconfig.json                      # TypeScript configuration
├── gulpfile.js                        # Build tasks
└── README.md                          # Documentation
```

## Key Features

### Operations
1. **Get Page Content** - Extract full HTML from pages
2. **Get PDF** - Generate PDF documents from web pages
3. **Get Screenshot** - Capture page screenshots
4. **Custom Script** - Execute arbitrary Puppeteer scripts with full API access

### Advanced Capabilities
- **Device Emulation**: Simulate mobile/tablet devices
- **Stealth Mode**: Avoid bot detection
- **Proxy Support**: Route traffic through proxies
- **Remote Browser**: Connect to external Chrome instances via WebSocket
- **Cookie Management**: Store and reuse authentication cookies
- **Binary Data Handling**: Work with images, PDFs, and other binary formats
- **Batch Processing**: Process multiple pages concurrently

## Development Workflow

### Build Commands
```bash
npm run build      # Compile TypeScript and run Gulp tasks
npm run dev        # Watch mode for development
npm run watch      # TypeScript watch mode
npm run lint       # Run TSLint checks
npm run lintfix    # Auto-fix linting issues
npm run nodelinter # n8n-specific node validation
```

### Build Process
1. TypeScript compilation (`tsc`)
2. Gulp tasks for asset processing
3. Output to `dist/` directory
4. Main entry: `dist/nodes/Puppeteer/Puppeteer.node.js`

## Installation & Deployment

### Community Nodes (Recommended for Users)
Install via n8n UI: Settings > Community Nodes > Install `n8n-nodes-puppeteer`

### Docker (Recommended for Production)
```bash
docker build -t n8n-puppeteer -f docker/Dockerfile docker/
docker run -it -p 5678:5678 -v ~/.n8n:/home/node/.n8n n8n-puppeteer
```

### Manual Installation
```bash
cd /path/to/n8n
npm install n8n-nodes-puppeteer
```

## Browser Configuration

### Local Browser
- Uses bundled Chromium (default)
- Requires system dependencies (fonts, libraries)
- Docker setup includes all dependencies

### Remote Browser (WebSocket)
- Connect to external Chrome instance
- Services: browserless.io, browsercloud.io
- Self-hosted: `ghcr.io/browserless/chromium`
- Format: `ws://host:port?token=TOKEN`

## Code Architecture

### Main Node Implementation
- **File**: `nodes/Puppeteer/Puppeteer.node.ts`
- **VM Sandbox**: Uses @n8n/vm2 for secure script execution
- **Error Handling**: Graceful page cleanup and error propagation
- **Batch Processing**: Configurable concurrent page limit
- **Container Support**: Special launch args for Docker environments

### Special Variables (Custom Scripts)
- `$page` - Current Puppeteer page instance
- `$browser` - Browser instance
- `$puppeteer` - Puppeteer library
- Plus all n8n Code node variables (`$json`, `$input`, etc.)

## Security Considerations

1. **Sandboxed Execution**: Scripts run in isolated VM2 environment
2. **Environment Variables**: 
   - `NODE_FUNCTION_ALLOW_BUILTIN` - Allowed built-in modules
   - `NODE_FUNCTION_ALLOW_EXTERNAL` - Allowed external modules
   - `CODE_ENABLE_STDOUT` - Console output control
3. **Container Isolation**: Docker setup provides additional security layer

## Common Use Cases

1. **Web Scraping**: Extract data from dynamic websites
2. **Screenshot Automation**: Capture page states for monitoring
3. **PDF Generation**: Convert web pages to documents
4. **Form Automation**: Fill and submit web forms
5. **Authentication Flows**: Handle login and session management
6. **Testing**: Automated browser testing in workflows
7. **Data Collection**: Gather information from multiple sources

## Troubleshooting

### Missing Dependencies
- **Issue**: `libgobject-2.0.so.0` or `libnss3.so` errors
- **Solution**: Use Docker setup or install Chrome dependencies

### Memory Issues
- **Issue**: High memory usage with multiple pages
- **Solution**: Reduce batch size in node options

### Detection Problems
- **Issue**: Sites blocking automation
- **Solution**: Enable stealth mode, use device emulation

## Future Considerations

### Potential Improvements
- [ ] Add more device presets
- [ ] Enhanced error reporting with screenshots
- [ ] Performance metrics collection
- [ ] Advanced cookie management UI
- [ ] Browser pool management for better resource usage
- [ ] Support for browser extensions
- [ ] Network request interception capabilities
- [ ] Improved TypeScript type coverage

### Maintenance Tasks
- [ ] Keep Puppeteer updated with latest Chrome versions
- [ ] Monitor and update stealth plugin for detection changes
- [ ] Review and update Docker base image
- [ ] Ensure compatibility with latest n8n versions
- [ ] Update device emulation list periodically

## Resources

- **n8n Documentation**: https://docs.n8n.io
- **Puppeteer Docs**: https://pptr.dev
- **Puppeteer Troubleshooting**: https://pptr.dev/troubleshooting
- **Device Descriptors**: https://github.com/puppeteer/puppeteer/blob/main/src/common/DeviceDescriptors.ts
- **Repository**: https://github.com/laHeud/n8n-nodes-puppeteer

## License

MIT License - See LICENSE.md for full text
