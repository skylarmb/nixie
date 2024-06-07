// Modules to control application life and create native browser window
const { app, BrowserWindow, shell } = require("electron");
const path = require("node:path");

// Get the URL from the command-line arguments
const urlArg = process.argv[process.argv.length - 1];
console.log("------ URL argument:", urlArg, "------");
if (!urlArg) {
  console.error("No URL argument provided");
  process.exit(1);
}

function createWindow() {
  // Create the browser window.
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {},
  });
  console.log("------ Window created ------");

  // and load the index.html of the app.
  // win.setMenu(null);
  // Use the URL argument when loading the window
  // win.loadURL("https://app.slack.com/client/T016VMW1064/C015Z55806S");
  win.loadURL(urlArg);
  win.webContents.setWindowOpenHandler(({ url }) => {
    const parsedUrl = new URL(urlArg);
    const baseUrl = `${parsedUrl.protocol}//${parsedUrl.hostname}`;

    // allow links that are in the same domain as the app
    if (url.startsWith(baseUrl)) {
      return { action: "allow" };
    }

    // open url in a browser and prevent default for external links
    shell.openExternal(url);
    return { action: "deny" };
  });
}

// app.commandLine.appendSwitch(
//   "enable-features",
//   "UseOzonePlatform,WaylandWindowDecorations",
// );
// app.commandLine.appendSwitch("ozone-platform", "wayland");

// app.commandLine.appendSwitch(
//   "widevine-cdm-path",
//   "/home/skylar/workspace/chromium-widevine/WidevineCdm",
// );
// app.commandLine.appendSwitch("widevine-cdm-version", "4.10.2662.3");
//
// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.whenReady().then(() => {
  createWindow();

  app.on("activate", function () {
    // On macOS it's common to re-create a window in the app when the
    // dock icon is clicked and there are no other windows open.
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on("window-all-closed", function () {
  if (process.platform !== "darwin") app.quit();
});

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
