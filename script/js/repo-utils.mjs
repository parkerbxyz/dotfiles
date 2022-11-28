#!/usr/bin/env zx
import { spinner } from "zx/experimental";
import "zx/globals";

// Don't print all executed commands/outputs
$.verbose = false;

// Get all directories with a .git directory
async function getRepos() {
  const repos = await spinner(
    "Finding Git repositories...",
    () => $`find ~/github.com -type d -name .git | xargs -I {} dirname {}`
  );
  // Turn the output into an array of strings and filter out empty lines
  const repoArray = repos.stdout
    .split("\n")
    .filter((repo) => repo !== "")
    .sort();

  // Cache repoArray so we don't have to find all the repos every time the script runs
  await fs.writeFile(".repos.txt", repoArray.join("\n"));
}

// Loop through the repos and find all stashes
async function findStashedChanges() {
  let reposWithStashedChanges = [];
  for (const repo of repoArray) {
    const stashes = await $`git -C ${repo} stash-list-branches`;
    if (stashes.stdout) {
      const numberOfStashes = stashes.stdout.split("\n").length;
      reposWithStashedChanges.push({
        repo,
        numberOfStashes,
      });
    }
  }
  console.log(`Repos with stashed changes:
  ${reposWithStashedChanges.map((repo) => repo.repo).join("\n")}`);
}

// Loop through the repos and prune branches
async function pruneBranches() {
  // $.verbose = true;
  let mergedBranchesPruned = [];
  let goneBranchesPruned = [];
  for (const repo of repoArray) {
    const defaultBranch = (await $`git -C ${repo} default`).toString().trim();
    await gitSwitch(repo, defaultBranch);
    const mergedBranches = await $`git -C ${repo} prune-branches`;
    if (mergedBranches.stdout) {
      mergedBranchesPruned.push(mergedBranches.stdout.split("\n"));
    }
    const goneBranches = await $`git -C ${repo} prune-gone-branches`;
    if (goneBranches.stdout) {
      goneBranchesPruned.push(goneBranches.stdout.split("\n"));
    }
  }
}

// async function reposWithUnpushedCommits() {
//   let reposWithUnpushedCommits = [];
//   for (const repo of repoArray) {
//     const unpushedCommits = await $`git -C ${repo} status --porcelain`;
//     if (unpushedCommits.stdout) {
//       reposWithUnpushedCommits.push(repo);
//     }
//   }
//   console.log(`Repos with unpushed commits:
//   ${reposWithUnpushedCommits.join("\n")}`);
// }

async function gitSwitch(repo, branch) {
  const currentBranch = (await $`git -C ${repo} branch --show-current`)
    .toString()
    .trim();
  // If the current branch is the same as the branch we want to switch to, don't switch
  if (currentBranch === branch) {
    return;
  }
  await $`git -C ${repo} switch ${branch}`;
}

// Get status of each repo and pipe output to a file
async function repoStatus() {
  const repoStatusFile = ".repo-status.txt";
  // Clear the .repos-status.txt file
  await fs.writeFile(repoStatusFile, "");
  for (const repo of repoArray) {
    const defaultBranch = (await $`git -C ${repo} default`).toString().trim();
    await gitSwitch(repo, defaultBranch);
    await $`git -C ${repo} fetch`;
    await $`echo ${repo} >> ${repoStatusFile}`;
    await $`git -C ${repo} branch-list-status >> ${repoStatusFile}`;
    await $`echo >> ${repoStatusFile}`;

    // Delete lines that start with 'undefined' from repoStatusFile
    await $`sed -i '' '/undefined/d' ${repoStatusFile}`;
  }
}

async function gitStatus(repo) {
  return (await $`git -C ${repo} status --porcelain`).toString().trim();
}

async function findReposWithUncommittedChanges() {
  let reposWithUncommittedChanges = [];
  for (const repo of repoArray) {
    // Get current branch and trim whitespace
    const currentBranch = (await $`git -C ${repo} rev-parse --abbrev-ref HEAD`)
      .toString()
      .trim();
    const allBranches = (await $`git -C ${repo} branch-list`)
      .toString()
      .trim()
      .split("\n");
    // Remove current branch from allBranches
    const featureBranches = allBranches.filter(
      (branch) => branch !== currentBranch
    );
    const branchStatus = await gitStatus(repo);
    if (branchStatus.length > 0) {
      reposWithUncommittedChanges.push([
        repo,
        currentBranch,
        branchStatus.length,
      ]);
      continue;
    }
    // Continue to the next iteration of this loop if there are no feature branches
    if (featureBranches.length < 1) {
      continue;
    }
    for (const branch of allBranches) {
      try {
        await gitSwitch(repo, branch);
      } catch (error) {
        console.log(`Error switching to ${branch} in ${repo}`);
        continue;
      }

      const branchStatus = await gitStatus(repo);
      if (branchStatus.toString()) {
        reposWithUncommittedChanges.push([
          repo,
          currentBranch,
          branchStatus.length,
        ]);
      }
    }
  }
  console.log(reposWithUncommittedChanges);
  console.log(
    `Repos with uncommitted changes: ${reposWithUncommittedChanges.length}`
  );
}

// await getRepos();

// Get the cached repoArray
const repoArray = fs.readFileSync(".repos.txt").toString().trim().split("\n");

await findReposWithUncommittedChanges();

await findStashedChanges();

await pruneBranches();

await repoStatus();
