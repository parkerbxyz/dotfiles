#!/usr/bin/env zx
// Generate a Brewfile and add comments to it that describe what each package is

import { readFileSync } from "node:fs";
import tmp from "tmp";
import { spinner } from "zx";
import "zx/globals";

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

// Remove all controlled temporary objects on process exit
tmp.setGracefulCleanup();

// Create a temporary directory to store the Brewfile
const tmpDir = tmp.dirSync();
const tmpBrewfilePath = `${tmpDir.name}/Brewfile`;

try {
  // Create initial Brewfile
  await spinner(
    "Running brew bundle dump...",
    () => $`brew bundle --describe --no-restart dump --file ${tmpBrewfilePath}`
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
  process.exit(1);
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

  const masRegex = new RegExp(`^mas "(${excludedApps.join("|")})".*\n`, "gm");
  return brewfileContent.replace(masRegex, "");
}
