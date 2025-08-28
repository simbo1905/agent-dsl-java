# Default recipe shows available commands
default:
    @just --list

# Initial project setup
setup:
    @echo "Setting up AgentDSL repository..."
    @mkdir -p .mvn
    @echo "✓ Created .mvn directory for Maven Daemon"
    @if [ ! -L "CLAUDE.md" ]; then \
        ln -s AGENTS.md CLAUDE.md && \
        echo "✓ Created symlink: CLAUDE.md -> AGENTS.md"; \
    else \
        echo "✓ Symlink already exists: CLAUDE.md -> AGENTS.md"; \
    fi
    @if [ ! -L "GEMINI.md" ]; then \
        ln -s AGENTS.md GEMINI.md && \
        echo "✓ Created symlink: GEMINI.md -> AGENTS.md"; \
    else \
        echo "✓ Symlink already exists: GEMINI.md -> AGENTS.md"; \
    fi
    @echo "Setup complete!"

# Build LaTeX documentation to PDF
docs:
    @echo "Building LaTeX documentation..."
    @if command -v pdflatex >/dev/null 2>&1; then \
        cd docs && \
        pdflatex -interaction=nonstopmode agent-os-java.tex && \
        pdflatex -interaction=nonstopmode agent-os-java.tex && \
        echo "✓ PDF generated: docs/agent-os-java.pdf"; \
    else \
        echo "Error: pdflatex not found. Please install LaTeX."; \
        exit 1; \
    fi

# Clean generated files
clean:
    @echo "Cleaning generated files..."
    @# Clean maven build artifacts
    @if command -v mvnd >/dev/null 2>&1; then \
        mvnd clean; \
    else \
        mvn clean; \
    fi
    @echo "✓ Cleaned Maven build artifacts"
    @# Clean LaTeX build artifacts
    @rm -f docs/*.aux docs/*.log docs/*.out docs/*.toc docs/*.lof docs/*.lot docs/*.fls docs/*.fdb_latexmk docs/*.synctex.gz
    @echo "✓ Cleaned LaTeX build artifacts"


# Quick build - run tests
test:
    @echo "Running tests..."
    @if command -v mvnd >/dev/null 2>&1; then \
        echo "Using mvnd (Maven Daemon) for faster tests..."; \
        mvnd test; \
    else \
        mvn test; \
    fi

# Full build - clean and verify
build:
    @echo "Running a full build..."
    @just clean
    @if command -v mvnd >/dev/null 2>&1; then \
        echo "Using mvnd (Maven Daemon) for faster build..."; \
        mvnd verify; \
    else \
        mvn verify; \
    fi
    @echo "✓ Full build complete"
