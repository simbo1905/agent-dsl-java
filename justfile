# AgentDSL Justfile - Polyglot Build System
# This is the single source of truth for all build operations
# IMPORTANT: Never run underlying tools (mvn, gradle, npm, etc.) directly

# Default recipe shows available commands
default:
    @just --list

# Build LaTeX documentation to PDF
docs:
    @echo "Building LaTeX documentation..."
    @if command -v pdflatex >/dev/null 2>&1; then \
        cd docs && \
        pdflatex -interaction=nonstopmode agent-os-java.tex && \
        pdflatex -interaction=nonstopmode agent-os-java.tex && \
        echo "✓ PDF generated: docs/agent-os-java.pdf"; \
    else \
        echo "Error: pdflatex not found. Please install LaTeX:"; \
        echo "  brew install --cask mactex"; \
        echo "  or"; \
        echo "  brew install --cask basictex"; \
        exit 1; \
    fi

# Initial project setup for polyglot development
setup:
    @echo "Setting up AgentDSL polyglot repository..."
    
    # Create .mvn directory for Maven Daemon
    @mkdir -p .mvn
    @echo "✓ Created .mvn directory for Maven Daemon"
    
    # Create AGENTS.md symlink to CLAUDE.md
    @if [ ! -L "AGENTS.md" ]; then \
        ln -s CLAUDE.md AGENTS.md && \
        echo "✓ Created symlink: AGENTS.md -> CLAUDE.md"; \
    else \
        echo "✓ Symlink already exists: AGENTS.md -> CLAUDE.md"; \
    fi
    
    # Create polyglot directory structure
    @mkdir -p agent-core/src/main/java
    @mkdir -p agent-core/src/test/java
    @mkdir -p agent-tools/src/main/java
    @mkdir -p agent-runtime/src/main/java
    @mkdir -p agent-web
    @mkdir -p agent-py
    @mkdir -p docs
    @mkdir -p examples
    @echo "✓ Directory structure created"
    
    # Check for required tools
    @echo ""
    @echo "Checking polyglot dependencies..."
    @just check-deps
    @echo ""
    @echo "Setup complete! Use 'just' to see available commands."

# Clean generated files
clean:
    @echo "Cleaning generated files..."
    @rm -f docs/*.aux docs/*.log docs/*.out docs/*.toc docs/*.lof docs/*.lot docs/*.fls docs/*.fdb_latexmk docs/*.synctex.gz
    @echo "✓ Cleaned LaTeX build artifacts"

# Build and open documentation
docs-open: docs
    @if [ -f "docs/agent-os-java.pdf" ]; then \
        open docs/agent-os-java.pdf; \
    else \
        echo "Error: PDF not found"; \
        exit 1; \
    fi

# Check if all requirements are installed
check-deps:
    @echo "Checking polyglot dependencies..."
    @# Check for just
    @echo -n "just: "
    @command -v just >/dev/null 2>&1 && echo "✓ installed" || echo "✗ not found"
    @# Check for Java
    @echo -n "java: "
    @command -v java >/dev/null 2>&1 && echo "✓ installed ($(java -version 2>&1 | head -1))" || echo "✗ not found"
    @# Check for Maven
    @echo -n "maven: "
    @command -v mvn >/dev/null 2>&1 && echo "✓ installed" || echo "✗ not found"
    @# Check for Maven Daemon (optional but preferred)
    @echo -n "mvnd: "
    @command -v mvnd >/dev/null 2>&1 && echo "✓ installed (preferred for faster builds)" || echo "✗ not found (optional - install with: brew install mvndaemon/tap/mvnd)"
    @# Check for Python
    @echo -n "python3: "
    @command -v python3 >/dev/null 2>&1 && echo "✓ installed ($(python3 --version))" || echo "✗ not found"
    @# Check for Node.js
    @echo -n "node: "
    @command -v node >/dev/null 2>&1 && echo "✓ installed ($(node --version))" || echo "✗ not found"
    @# Check for pdflatex
    @echo -n "pdflatex: "
    @command -v pdflatex >/dev/null 2>&1 && echo "✓ installed" || echo "✗ not found (optional for docs)"

# Install LaTeX on macOS
install-latex:
    @echo "Installing LaTeX for macOS..."
    @echo "Choose one of the following:"
    @echo "  1. Full distribution (recommended, ~4GB):"
    @echo "     brew install --cask mactex"
    @echo ""
    @echo "  2. Minimal distribution (~200MB):"
    @echo "     brew install --cask basictex"
    @echo ""
    @echo "After installation, you may need to restart your terminal."

# === POLYGLOT BUILD COMMANDS ===

# Build all components
build:
    @echo "Building all polyglot components..."
    @just build-java
    @just build-python
    @just build-web
    @echo "✓ All components built"

# Build Java components
build-java:
    @echo "Building Java components..."
    @if [ -f "pom.xml" ]; then \
        if command -v mvnd >/dev/null 2>&1; then \
            echo "Using mvnd (Maven Daemon) for faster builds..."; \
            mvnd compile; \
        else \
            mvn compile; \
        fi; \
    else \
        echo "⚠️  No pom.xml found"; \
    fi

# Build Python components
build-python:
    @echo "Building Python components..."
    @if [ -d "agent-py" ]; then \
        cd agent-py && python3 -m py_compile *.py 2>/dev/null || echo "No Python files to compile"; \
    fi

# Build web components
build-web:
    @echo "Building web components..."
    @if [ -f "agent-web/package.json" ]; then \
        cd agent-web && npm install && npm run build; \
    else \
        echo "⚠️  No package.json found in agent-web/"; \
    fi

# Run all tests
test:
    @echo "Running all polyglot tests..."
    @just test-java
    @just test-python
    @just test-web

# Java tests
test-java:
    @echo "Running Java tests..."
    @if [ -f "pom.xml" ]; then \
        if command -v mvnd >/dev/null 2>&1; then \
            echo "Using mvnd (Maven Daemon) for faster tests..."; \
            mvnd test; \
        else \
            mvn test; \
        fi; \
    else \
        echo "⚠️  No Java build file found"; \
    fi

# Python tests
test-python:
    @echo "Running Python tests..."
    @if [ -d "agent-py" ]; then \
        cd agent-py && python3 -m pytest . 2>/dev/null || echo "No pytest installed or no tests found"; \
    fi

# Web tests
test-web:
    @echo "Running web tests..."
    @if [ -f "agent-web/package.json" ]; then \
        cd agent-web && npm test; \
    else \
        echo "⚠️  No package.json found"; \
    fi

# Run specific test
test-specific TEST:
    @echo "Running specific test: {{TEST}}"
    @# Try Java first
    @if [ -f "pom.xml" ]; then \
        if command -v mvnd >/dev/null 2>&1; then \
            mvnd test -Dtest={{TEST}} || true; \
        else \
            mvn test -Dtest={{TEST}} || true; \
        fi; \
    fi
    @# Try Python
    @if [ -d "agent-py" ]; then \
        cd agent-py && python3 -m pytest -k {{TEST}} 2>/dev/null || true; \
    fi

# Format all code
format:
    @echo "Formatting all code..."
    @just format-java
    @just format-python
    @just format-web

# Format Java code
format-java:
    @echo "Formatting Java code..."
    @find . -name "*.java" -type f | xargs -I {} echo "Would format: {}"
    @echo "TODO: Configure Java formatter (google-java-format or spotless)"

# Format Python code
format-python:
    @echo "Formatting Python code..."
    @if command -v black >/dev/null 2>&1; then \
        black agent-py/; \
    else \
        echo "⚠️  black not installed. Install with: pip install black"; \
    fi

# Format web code
format-web:
    @echo "Formatting web code..."
    @if [ -f "agent-web/package.json" ]; then \
        cd agent-web && npm run format 2>/dev/null || echo "No format script defined"; \
    fi

# Lint all code
lint:
    @echo "Linting all code..."
    @just lint-java
    @just lint-python
    @just lint-web

# Lint Java code
lint-java:
    @echo "Linting Java code..."
    @echo "TODO: Configure Java linter (checkstyle or spotbugs)"

# Lint Python code
lint-python:
    @echo "Linting Python code..."
    @if command -v ruff >/dev/null 2>&1; then \
        ruff check agent-py/; \
    else \
        echo "⚠️  ruff not installed. Install with: pip install ruff"; \
    fi

# Lint web code
lint-web:
    @echo "Linting web code..."
    @if [ -f "agent-web/package.json" ]; then \
        cd agent-web && npm run lint 2>/dev/null || echo "No lint script defined"; \
    fi

# === GIT OPERATIONS ===
# All git operations must go through just to ensure proper configuration

# Git status
status:
    @git status

# Git add all and commit with author configuration
commit MESSAGE:
    @git add -A
    @git -c user.name="Simon Massey" -c user.email="322608+simbo1905@users.noreply.github.com" commit -m "{{MESSAGE}}"

# Create a new feature branch
feature NAME:
    @git checkout -b feature/{{NAME}}

# Create a new experiment branch
experiment NAME:
    @git checkout -b experiment/{{NAME}}

# Push to origin
push:
    @git push

# Push and set upstream
push-upstream:
    @git push -u origin $(git branch --show-current)

# === DEVELOPMENT COMMANDS ===

# Start development environment
dev:
    @echo "Starting development environment..."
    @echo "TODO: Start all dev servers in parallel"

# Check and display current environment
doctor:
    @echo "AgentDSL Development Environment"
    @echo "================================"
    @echo ""
    @just check-deps
    @echo ""
    @echo "Git Configuration:"
    @echo "  Author: Simon Massey <322608+simbo1905@users.noreply.github.com>"
    @echo ""
    @echo "Project Structure:"
    @ls -la AGENTS.md 2>/dev/null && echo "  ✓ AGENTS.md symlink exists" || echo "  ✗ AGENTS.md symlink missing"
    @echo ""
    @echo "Remember: Always use 'just' commands - never run tools directly!"