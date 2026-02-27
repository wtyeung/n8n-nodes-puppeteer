# n8n-nodes-puppeteer

![n8n.io - Workflow Automation](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)

[n8n](https://www.n8n.io) node for browser automation using [Puppeteer](https://pptr.dev/). Execute custom scripts, capture screenshots and PDFs, scrape content, and automate web interactions using Chrome/Chromium's DevTools Protocol. Full access to Puppeteer's API plus n8n's Code node capabilities makes this node powerful for any browser automation task.

## How to install

### Community Nodes (Recommended)

For n8n version 0.187 and later, you can install this node through the Community Nodes panel:

1. Go to **Settings > Community Nodes**
2. Select **Install**
3. Enter `@wtyeung/n8n-nodes-puppeteer` in **Enter npm package name**
4. Agree to the [risks](https://docs.n8n.io/integrations/community-nodes/risks/) of using community nodes
5. Select **Install**

### Docker Installation (Recommended for Production)

We provide a ready-to-use Docker setup in the `docker/` directory that includes all necessary dependencies and configurations:

1. Clone this repository or copy the following files to your project:
   - `docker/Dockerfile`
   - `docker/docker-custom-entrypoint.sh`

2. Build your Docker image:
```bash
docker build -t n8n-puppeteer -f docker/Dockerfile docker/
```

3. Run the container:
```bash
docker run -it \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8n-puppeteer
```

### Manual Installation

For a standard installation without Docker:

```bash
# Navigate to your n8n root directory
cd /path/to/n8n

# Install the package
npm install @wtyeung/n8n-nodes-puppeteer
```

Note: By default, when Puppeteer is installed, it downloads a compatible version of Chromium. While this works, it increases installation size and may not include necessary system dependencies. For production use, we recommend either using the Docker setup above or installing system Chrome/Chromium and setting the `PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true` environment variable.

## Development

This project uses `@n8n/node-cli` for development, providing an integrated development environment with hot reload and proper tooling.

### Quick Start

```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

The dev server will start n8n at http://localhost:5678 with your node automatically loaded. Changes to the code will trigger automatic rebuilds.

### Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build TypeScript and run Gulp tasks
- `npm run build:watch` - Watch mode for TypeScript compilation
- `npm run lint` - Check code quality
- `npm run lint:fix` - Auto-fix linting issues
- `npm run format` - Format code with Prettier

For detailed development instructions, see [DEVELOPMENT.md](DEVELOPMENT.md).

### Recent Improvements

**v1.5.0**
- ✅ **Capture Downloads**: Automatically capture files downloaded during custom script execution as binary data
- ✅ **Auto Cleanup**: Downloaded files are automatically cleaned up after capture

**v1.4.16**
- ✅ **Installation Fix**: Resolved `yallist_1.Yallist is not a constructor` error when installing via n8n Community Nodes UI
- ✅ **Installation Fix**: Resolved `ENOENT: no such file or directory, proxy-agent/dist/index.js` error caused by n8n's shallow install strategy
- ✅ **Security**: WebSocket endpoint tokens are masked in all logs (`?***`)
- ✅ **Env Var Support**: `BROWSER_WS_ENDPOINT` and `BROWSER_WS_TOKEN` for vault-based secret management

**v1.4.4**
- ✅ **TypeScript**: Full type safety with zero `//@ts-ignore` comments
- ✅ **Modern Dev Tools**: Using `@n8n/node-cli` for integrated development
- ✅ **Updated Dependencies**: Puppeteer 24.x with latest security fixes
- ✅ **Dependency Fixes**: Resolved lru-cache and glob deprecation warnings
- ✅ **Better Documentation**: Comprehensive guides for development and deployment

## Browser Setup Options

### 1. Local Browser (Docker Setup - Recommended)

The included Docker setup provides the most reliable way to run Chrome/Chromium with all necessary dependencies. It uses Alpine Linux's Chromium package and includes all required fonts and libraries.

### 2. Remote Browser (Alternative for Cloud)

You can also connect to an external Chrome instance using the "Browser WebSocket Endpoint" option. This approach:
- Eliminates the need for Chrome dependencies in your n8n environment
- Simplifies deployment and maintenance
- Provides better resource isolation
- Works great for cloud and containerized deployments

Options include:
- **Managed Services**: Use [browserless](https://browserless.io) or [browsercloud](https://browsercloud.io)
- **Self-Hosted**: Run your own [browser container](https://docs.browserless.io/docker/config):
  ```bash
  docker run -p 3000:3000 -e "TOKEN=6R0W53R135510" ghcr.io/browserless/chromium
  ```

To use a remote browser, enable "Browser WebSocket Endpoint" in any Puppeteer node and enter your WebSocket URL (e.g., `ws://browserless:3000?token=6R0W53R135510`).

## Docker Requirements for Community Node Installation

When installing via n8n's **Community Nodes UI**, n8n uses a shallow install strategy that requires `proxy-agent` to be pre-installed globally in your n8n Docker image. Add it to your Dockerfile:

```dockerfile
FROM docker.n8n.io/n8nio/n8n:latest

USER root

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_SKIP_DOWNLOAD=true

RUN npm install -g proxy-agent

USER node
```

Without this, you may see: `ENOENT: no such file or directory, open '.../proxy-agent/dist/index.js'`

## Remote Browser Configuration

### Using Environment Variables (Recommended for Production)

Instead of entering the WebSocket endpoint in each workflow, set environment variables in your Docker image. The node will use them automatically when the UI field is left empty.

| Variable | Description |
|----------|-------------|
| `BROWSER_WS_ENDPOINT` | Base WebSocket URL, e.g. `wss://browser.example.com:9222` |
| `BROWSER_WS_TOKEN` | Secret token (from vault). Appended as `?token=<value>` |

```dockerfile
ENV BROWSER_WS_ENDPOINT=wss://browser.example.com:9222
ENV BROWSER_WS_TOKEN=your-secret-token
```

**Priority order:** UI field → env vars → local browser launch

Tokens are always masked as `?***` in logs for security.

## Troubleshooting

### `yallist_1.Yallist is not a constructor`

This error occurs when a dependency is specified as a GitHub source (e.g. `github:user/repo`). Fixed in v1.4.11 by switching `puppeteer-extra-plugin-human-typing` to the npm registry version.

### `ENOENT: no such file or directory, proxy-agent/dist/index.js`

n8n's shallow install strategy creates incomplete nested `node_modules`. Fix by adding `proxy-agent` to your Docker global install (see [Docker Requirements](#docker-requirements-for-community-node-installation) above).

### Missing shared libraries (`libgobject-2.0.so.0`, `libnss3.so`)

Either install the missing Chrome dependencies or switch to a remote browser using the WebSocket endpoint option.

For additional help, see [Puppeteer's troubleshooting guide](https://pptr.dev/troubleshooting).

## Node Reference

- **Operations**

  - Get the full HTML contents of the page
  - Capture the contents of a page as a PDF document
  - Capture screenshot of all or part of the page
  - Execute custom script to interact with the page

- **Options**

  - All Operations

    - **Batch Size**: Maximum number of pages to open simultaneously. More pages will consume more memory and CPU.
    - **Browser WebSocket Endpoint**: The WebSocket URL of the browser to connect to. When configured, puppeteer will skip the browser launch and connect to the browser instance.
    - **Emulate Device**: Allows you to specify a [device](https://github.com/puppeteer/puppeteer/blob/main/src/common/DeviceDescriptors.ts) to emulate when requesting the page.
    - **Executable Path**: A path where Puppeteer expects to find the bundled browser. Has no effect when 'Browser WebSocket Endpoint' is set.
    - **Extra Headers**: Allows you add additional headers when requesting the page.
    - **Timeout**: Allows you to specify the maximum navigation time in milliseconds. You can pass 0 to disable the timeout entirely.
    - **Wait Until**: Allows you to change how Puppeteer considers navigation completed.
      - `load`: The load event is fired.
      - `domcontentloaded`: The DOMContentLoaded event is fired.
      - `networkidle0`: No more than 0 connections for at least 500 ms.
      - `networkidle2`: No more than 2 connections for at least 500 ms.
    - **Page Caching**: Allows you to toggle whether pages should be cached when requesting.
    - **Headless mode**: Allows you to change whether to run browser runs in headless mode or not.
    - **Use Chrome Headless Shell**: Whether to run browser in headless shell mode. Defaults to false. Headless mode must be enabled. chrome-headless-shell must be in $PATH.
    - **Stealth mode**: When enabled, applies various techniques to make detection of headless Puppeteer harder. Powered by [puppeteer-extra-plugin-stealth](https://github.com/berstend/puppeteer-extra/tree/master/packages/puppeteer-extra-plugin-stealth).
    - **Capture Downloads**: When enabled, any files downloaded during script execution (via clicks, direct downloads, etc.) will be automatically captured and returned as binary data in the node output. Perfect for downloading PDFs, images, or other files triggered by user interactions. Files are automatically cleaned up after capture. Only applies to 'Run Custom Script' operation.
    - **Launch Arguments**: Allows you to specify additional command line arguments passed to the browser instance.
    - **Proxy Server**: Allows Puppeteer to use a custom proxy configuration. You can specify a custom proxy configuration in three ways:
      By providing a semi-colon-separated mapping of list scheme to url/port pairs.
      For example, you can specify:

            http=foopy:80;ftp=foopy2

      to use HTTP proxy "foopy:80" for http URLs and HTTP proxy "foopy2:80" for ftp URLs.

      By providing a single uri with optional port to use for all URLs.
      For example:

            foopy:8080

      will use the proxy at foopy:8080 for all traffic.

      By using the special "direct://" value.

            direct://" will cause all connections to not use a proxy.

  - Get PDF
    - **File Name**: Allows you to specify the filename of the output file.
    - **Page Ranges** field: Allows you to specify paper ranges to print, e.g. 1-5, 8, 11-13.
    - **Scale**: Allows you to scale the rendering of the web page. Amount must be between 0.1 and 2
    - **Prefer CSS Page Size**: Give any CSS @page size declared in the page priority over what is declared in the width or height or format option.
    - **Format**: Allows you to specify the paper format types when printing a PDF. eg: Letter, A4.
    - **Height**: Allows you to set the height of paper. You can pass in a number or a string with a unit.
    - **Width**: Allows you to set the width of paper. You can pass in a number or a string with a unit.
    - **Landscape**: Allows you to control whether to show the header and footer
    - **Margin**: Allows you to specify top, left, right, and bottom margin.
    - **Display Header/Footer**: Allows you to specify whether to show the header and footer.
    - **Header Template**: Allows you to specify the HTML template for the print header. Should be valid HTML with the following classes used to inject values into them:
      - `date`: Formatted print date
      - `title`: Document title
      - `url`: Document location
      - `pageNumber` Current page number
      - `totalPages` Total pages in the document
    - **Footer Template**: Allows you to specify the HTML template for the print footer. Should be valid HTML with the following classes used to inject values into them:
      - `date`: Formatted print date
      - `title`: Document title
      - `url`: Document location
      - `pageNumber` Current page number
      - `totalPages` Total pages in the document
    - **Transparent Background**: Allows you to hide the default white background and allows generate PDFs with transparency.
    - **Background Graphic**: Allows you to include background graphics.
  - Get Screenshot
    - **File Name**: Allows you to specify the filename of the output file.
    - **Type** field: Allows you to specify the image format of the output file:
      - JPEG
      - PNG
      - WebP
    - **Quality**: Allows you to specify the quality of the image.
      - Accepts a value between 0-100.
      - Not applicable to PNG images.
    - **Full Page**: Allows you to capture a screen of the full scrollable content.

## Custom Scripts

The Custom Script operation gives you complete control over Puppeteer to automate complex browser interactions, scrape data, generate PDFs/screenshots, and more. Scripts run in a sandboxed environment with access to the full Puppeteer API and n8n's Code node features.

Before script execution, you can configure browser behavior using the operation's options like:

- Emulate specific devices
- Set custom headers
- Enable stealth mode to avoid detection
- Configure proxy settings
- Set page load timeouts
- And more

Access Puppeteer-specific objects using:

- `$page` - Current page instance
- `$browser` - Browser instance
- `$puppeteer` - Puppeteer library

Plus all special variables and methods from the Code node are available. For a complete reference, see the [n8n documentation](https://docs.n8n.io/code-examples/methods-variables-reference/). Just like n8n's Code node, anything you `console.log` will be shown in the browser's console during test mode or in stdout when configured.

### Basic

```javascript
// Navigate to an IP lookup service
await $page.goto("https://httpbin.org/ip");

// Extract the IP address from the page content
const ipData = await $page.evaluate(() => {
  const response = document.body.innerText;
  const parsed = JSON.parse(response);
  return parsed.origin; // Extract the 'origin' field, which typically contains the IP address
});

console.log("Hello, world!");

console.log("IP Address", ipData);

// Return the result in the required format (array)
return [{ ip: ipData, ...$json }];
```

### Storing and re-using cookies

#### Node 1

```javascript
await $page.goto("https://www.example.com/login");

// Perform login
await $page.type("#login-username", "user");
await $page.type("#login-password", "pass");
await $page.click("#login-button");

// Store cookies for later use
const cookies = await $page.cookies();

return [{ cookies }];
```

#### Node 2

```javascript
const { cookies } = $input.first().json;

// Restore cookies
await $page.setCookie(...cookies);

// Navigate to authenticated page
await $page.goto("https://example.com/protected-page");

// Perform authenticated operations
const data = await $page.evaluate(() => {
  return document.querySelector(".protected-content").textContent;
});

return [{ data }];
```

### Working with Binary Data

```javascript
await $page.goto("https://www.google.com");
const imageData = await $page.screenshot({ type: "png", encoding: "base64" });
return [
  {
    binary: {
      screenshot: {
        data: imageData,
        mimeType: "image/png",
        fileName: "screenshot.png",
      },
    },
  },
];
```

### Capturing Downloads

Enable the **Capture Downloads** option to automatically capture files downloaded during script execution:

```javascript
// Navigate to a page with a download link
await $page.goto("https://example.com/downloads");

// Click the download button - file will be automatically captured
await $page.click("#download-pdf-button");

// Wait for download to complete
await $page.waitForTimeout(2000);

// Return your data - downloaded file will be added as binary data automatically
return [{ json: { status: "Downloaded" } }];
```

The downloaded file(s) will be automatically added to the output as binary data with the key `data` (or `data0`, `data1`, etc. for multiple files). Files are cleaned up automatically after capture.

## Screenshots

### Run Custom Script

![](images/script.png)

### Get Page Content

![](images/content.png)

### Get Screenshot

![](images/screenshot.png)

## Credits

This project is a fork of the original [n8n-nodes-puppeteer](https://github.com/drudge/n8n-nodes-puppeteer) by [Nicholas Penree](https://github.com/drudge).

### Original Author
- **Nicholas Penree** ([@drudge](https://github.com/drudge)) - Original creator and maintainer

### This Fork
- **laHeud** - Improved browserWSEndpoint handling and dependency management
- **Tim Yeung** ([@wtyeung](https://github.com/wtyeung)) - TypeScript improvements, modern dev tooling, and documentation

### Key Improvements in This Fork
- Enhanced WebSocket endpoint connection handling
- Updated to Puppeteer 24.x with latest features
- Full TypeScript type safety (removed all `//@ts-ignore`)
- Modern development workflow using `@n8n/node-cli`
- Resolved dependency conflicts (lru-cache, glob)
- Comprehensive development documentation
- Better error handling and debugging

Special thanks to the n8n community and all contributors who have helped improve this node!

## License

MIT License

Copyright (c) 2022-2024 Nicholas Penree <nick@penree.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
