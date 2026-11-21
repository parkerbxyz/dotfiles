#!/usr/bin/env node
// Generate a Brewfile with descriptions aligned to the right of each package.
// brew bundle dump includes descriptions by default (the --describe switch is now disabled).
// Uses only Node built-ins, so it runs without installing anything from npm.

import { execFileSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

// Configuration
const CONFIG = {
  // Apps to exclude from the final Brewfile
  excludedApps: ["GarageBand", "iMovie", "Keynote", "Numbers", "Pages"],
  // Section headers
  sectionHeaders: {
    taps: "Taps",
    formulae: "Formulae",
    casks: "Casks",
    mas: "Mac App Store",
    vscode: "VS Code Extensions"
  },
  // Minimum padding between package and comment
  minPadding: 1
};

const tmpDir = mkdtempSync(join(tmpdir(), "brewfile-"));
const tmpBrewfilePath = join(tmpDir, "Brewfile");

try {
  // Create initial Brewfile
  console.error("Running brew bundle dump...");
  execFileSync(
    "brew",
    ["bundle", "dump", "--no-restart", "--file", tmpBrewfilePath],
    { stdio: ["ignore", "ignore", "inherit"] }
  );

  let tmpBrewfile = readFileSync(tmpBrewfilePath, "utf8");

  // Move comments (lines starting with #) to the right of the line below
  const packageRegex = /^(#.*)\n(\w+ "[^"]*".*)/gm;
  const packages = [...tmpBrewfile.matchAll(packageRegex)];

  if (packages.length > 0) {
    // Count the length of the longest package line
    const longestPackageLineLength = Math.max(...packages.map(pkg => pkg[2].length));

    // Add padding (spaces) to the end of each package line to align the comments
    tmpBrewfile = tmpBrewfile.replace(
      packageRegex,
      (match, pkgDescription, pkg) => {
        const padding = " ".repeat(longestPackageLineLength - pkg.length + CONFIG.minPadding);
        return `${pkg}${padding}${pkgDescription}`;
      }
    );
  }

  // Extract and organize sections
  const sections = extractSections(tmpBrewfile);

  // Format the final Brewfile
  const formattedBrewfile = formatBrewfile(sections);

  // Remove excluded apps
  const finalBrewfile = removeExcludedApps(formattedBrewfile, CONFIG.excludedApps);

  console.log(finalBrewfile);
} catch (error) {
  console.error("Error generating Brewfile:", error.message);
  process.exitCode = 1;
} finally {
  rmSync(tmpDir, { recursive: true, force: true });
}

/**
 * Extract different sections from the Brewfile content
 */
function extractSections(brewfileContent) {
  const sections = {
    taps: [],
    formulae: [],
    casks: [],
    mas: [],
    vscode: []
  };

  brewfileContent.split('\n').forEach(line => {
    if (line.startsWith('tap ')) sections.taps.push(line);
    else if (line.startsWith('brew ')) sections.formulae.push(line);
    else if (line.startsWith('cask ')) sections.casks.push(line);
    else if (line.startsWith('mas ')) sections.mas.push(line);
    else if (line.startsWith('vscode ')) sections.vscode.push(line);
  });

  return sections;
}

/**
 * Format the Brewfile with section headers
 */
function formatBrewfile(sections) {
  const formattedSections = [];

  // Process each section if it has content
  Object.entries(sections).forEach(([sectionName, sectionContent]) => {
    if (sectionContent.length > 0) {
      const header = `# ${CONFIG.sectionHeaders[sectionName]}`;
      formattedSections.push(`${header}\n${sectionContent.join("\n")}`);
    }
  });

  return formattedSections.join("\n\n");
}

/**
 * Remove excluded apps from the Brewfile
 */
function removeExcludedApps(brewfileContent, excludedApps) {
  if (excludedApps.length === 0) return brewfileContent;

  const masRegex = new RegExp(`^mas "(${excludedApps.join("|")})".*(\n|$)`, "gm");
  return brewfileContent.replace(masRegex, "");
}
