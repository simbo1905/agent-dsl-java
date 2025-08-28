# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Simple Java 21 Hello World application with Maven build.

## Build Commands

**IMPORTANT**: This is a polyglot repository. Use `just` commands exclusively - never run underlying tools (mvn, gradle, npm, etc.) directly.

```bash
# Recommended - filters Maven output to save tokens
just quick-test

# Full Maven output
just test

# See all available commands
just
```

## You Can Crash At Any Time

Do not undertake unsafe ordering of steps. If you crash you leave the system corrupted. You are not running a global TX you moron. You must reorder all steps to have the maxiumum infomation and never under take intermediate steps that will be confusing when not tidied up. 

MUST NOT: 
     "Let me rename tests to be disabled while I fix this..."
SHOULD:
     "I will run only one fresh simple test while I fix this..."

MUST NOT: 
     "I will delete the old tests, write the new code, then write new tests..."
SHOULD: 
     "Add new failing tests, only run those test, fix code, run only new tests, finally run all tests, and refactor test to ensure code coverage is maximised."

MUST NOT: 
     "I'll change everything at once and hope it works."
SHOULD"
     "To make X do Y: write a simple unrealistic test, get it working, then add more tests and code step by step. Do not delete the unrealistic test leave it as skaffolding until final PR push."

## No One Asked Your To Delete Things

Never delete or perform destructive actions unless explicitly told. Only add or refactor; prove all functionality in CI before any removals. You have been warned.

## Java Coding Standards

### Core Principles

* Use Records for all data structures
* Prefer static methods
* Default to package-private scope  
* Use JEP 467 Markdown documentation: `/// good markdown` not legacy `/** bad html */`
* Use Stream operations instead of traditional loops
* Use `final var` for local variables

### Testing

* JUnit 5 with AssertJ for fluent assertions
* All code must include tests

## Software Engineering Practices

### Issue/Commit/PR Guidelines

**Issues** MUST only state "what" and "why":

- MUST outline which functionality is either needed or broken
- MUST NOT speculate or get excited or state the reasons or benefits or any other "sell the idea". 
- MUST NOT offer solution approaches, implementation details, or technical specifics in the body. Comments are discussions on the issue and comments and discussions on a PR are the only appropriate place for "how" or "approach". 
- MUST focus on business requirements and user impact without justifying the need or impact just state as cold facts what is aimed at
- MUST NOT have detours; fresh issues/improvements must be raised as new Issues. A PR (below) may close many issues but we MUST NOT have scope/creep on any issue while.
- MUST NOT EVER be edited by you the agent. You many only Comment on issues asking for me to edit them to correct them based on the actual work done.
- MAY have comments that accurately reflect the work being done as the work is being done do not wait until you need to push a PR to raise to discuss how the implementation work may require rescoping of the Issue.
- You MAY raise fresh minor Issues for small tidy-up work as you go. This must be named in the Commit(s) and PR(s) below. 

**Commits** MUST only state "what" was achieved and "how" to test:

- MUST name the issues/issue numbers being worked on
- MUST NOT repeat any content that is on the Issue
- MAY contain a link to the issue
- MUST give a clear indication if more commits will follow. 
- MUST say how to verify the changes work (test commands, expected number of successful test results, naming number of new tests, and their names)
- MAY outline some technical implementation details ONLY if they are surprising and not "obvious in hindsight" based on just reading the issue
- MUST NOT EVER Include Co-authored-by for AI assistance or any advertising whatsoever.

**Pull Requests** MUST only describe "what" was done not "why"/"how":

- MUST only be created if all tests pass locally.
- MUST name and link to the Issue(s) being closed.
- MUST close the issues on merge as uses the correct GitHub closes issue syntax
- MUST NOT include any edits or work that is not linked to a Issue as you MAY raise fresh minor Issues for small tidy-up work.
- MUST not be made if there are any deviation between the Issue and the PR rather you MAY raise a comments on the issue for them to be updated to properly match the PR and you MAY raise small tidy-up issues (e.g. fixing )
- MUST NOT report any success as it isn't possible to report that the checks run the PR will pass when creating the PR.
- MUST list out what additional tests in total have been added.
- MUST have a CI action that runs the new tests, plus all tests, and also checks that the total count of tests reported in the PR were seen to have been actually run.
- MUST NOT Highlight important implementation decisions those should have been raised and discussed as comments on the Issue
- MUST be changed to status Draft if the PR checks fail
  
CRITICAL you MUST NOT make a PR just because your TASKS.md say to make a PR. The only valid reason to make a PR is that it would close the Issue(s) named in the PR which must be issues named in the commit.

**CRITICAL: Zero Broken Tests Policy**

- MUST NOT create a PR with failing tests
- MUST be changed to status Draft if the PR checks fail
- The CI MUST verify exact test counts to prevent silent failures
- Any test failures MUST be fixed before marking PR as ready for review it must be in Draft state before it is fixed. 

**NEVER modify existing quality code when debugging tests!** Instead:

1. **Preserve Original Code**: Keep the original working code intact (e.g., don't change loop counts from 8 to 1)
2. **Create Separate Debug Tests**: Build new minimal test files from scratch to isolate issues
3. **Manual Baby Steps**: Add one line at a time with console.log, timing, and sleep statements (never sleep for long times on local code use single or low double digit seconds)
4. **Line-by-Line Logging**: Debug the manual way with detailed logging at each step
5. **Build Up Incrementally**: Start with nothing and build up to a working test step by step

This approach prevents breaking working code and allows systematic isolation of the exact hanging point. The original author spent significant effort creating quality software - respect that by debugging properly without shortcuts.

**SOFTWARE ENGINEERING PATTERN (CRITICAL):**

When debugging complex issues, follow this pattern religiously:

1. **Baby steps first** - get the core functionality working step by step in debug files
2. **Keep everything in sync** - the moment you see an error in baby steps, immediately fix it in BOTH baby steps AND all real test files
3. **Iterate until baby works** - only when baby steps are completely solid do you run the full test suite
4. **Final cleanup** - with baby steps proving no blockers, you only have a few final glitches to iron out

This prevents wasting time on broken approaches and ensures systematic progress. Also agents crash, forget, and get distracted, so the systematic methodology ensures work gets done systematically. Don't run full suites until baby steps prove the approach works.

## Note on CLAUDE.md Symlink

The CLAUDE.md symlink exists because Anthropic models are not standards compliant with the open AGENTS.md specification. This is not a mistake.