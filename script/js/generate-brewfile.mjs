#!/usr/bin/env zx
// Generate a Brewfile and add comments to it that describe what each package is

import { readFileSync } from "node:fs";
import tmp from "tmp";
import { spinner } from "zx/experimental";
import "zx/globals";

// Remove all controlled temporary objects on process exit
tmp.setGracefulCleanup();

// Create a temporary directory to store the Brewfile
const tmpDir = tmp.dirSync();
const tmpBrewfilePath = `${tmpDir.name}/Brewfile`;

// Create initial Brewfile
await spinner(
  "Running brew bundle dump...",
  () => $`brew bundle --describe dump --file ${tmpBrewfilePath}`
);

let tmpBrewfile = readFileSync(tmpBrewfilePath, "utf8");

// Move comments (lines starting with #) to the right of the line below
const packageRegex = /^(#.*)\n(\w+ ".*")/gm;
const packages = tmpBrewfile.matchAll(packageRegex);

// Count the length of the longest package line
const longestPackageLineLength = [...packages].reduce((a, b) => {
  return a[2].length > b[2].length ? a : b;
})[2].length;

// Add padding (spaces) to the end of each package line to align the comments
tmpBrewfile = tmpBrewfile.replace(
  packageRegex,
  (match, pkgDescription, pkg) => {
    const padding = " ".repeat(longestPackageLineLength - pkg.length + 1);
    return `${pkg}${padding}${pkgDescription}`;
  }
);

// Separate sections in the Brewfile with comment headers (Taps, Formulae, Casks, and Mac App Store)
const taps = tmpBrewfile.match(/tap ".*".*/g);
const formulae = tmpBrewfile.match(/brew ".*".*/g);
const casks = tmpBrewfile.match(/cask ".*".*/g);
const mas = tmpBrewfile.match(/mas ".*".*/g);

// Add comment headers to the Brewfile
const formattedBrewfile = `
# Taps
${taps.join("\n")}

# Formulae
${formulae.join("\n")}

# Casks
${casks.join("\n")}

# Mac App Store
${mas.join("\n")}
`.trim();

console.log(formattedBrewfile);
