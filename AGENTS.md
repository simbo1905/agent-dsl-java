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