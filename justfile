# Default recipe shows available commands
default:
    @echo "Available commands:"
    @echo ""
    @echo "  just quick-test [args]  - Run tests with minimal output (recommended for token conservation)"
    @echo "  just test               - Run tests with full Maven output"
    @echo "  just build              - Full clean build with verify"
    @echo "  just clean              - Clean all build artifacts"
    @echo "  just setup              - Initial project setup"
    @echo "  just docs               - Build LaTeX documentation"
    @echo ""
    @echo "💡 TIP: Use 'just quick-test' to filter Maven output and avoid burning tokens on boilerplate!"
    @echo "         It only shows compile errors and test results."
    @echo ""
    @echo "Examples:"
    @echo "  just quick-test"
    @echo "  just quick-test -Dtest=AppTest"
    @echo "  just quick-test -Dtest=AppTest#shouldAnswerWithTrue -Djava.util.logging.ConsoleHandler.level=FINER"

# Quick test with minimal output - filters Maven boilerplate to save tokens
# Usage: just quick-test [maven test arguments]
# Examples:
#   just quick-test
#   just quick-test -Dtest=AppTest
#   just quick-test -Dtest=AppTest#shouldAnswerWithTrue -Djava.util.logging.ConsoleHandler.level=FINER
quick-test *ARGS:
    @if command -v mvnd >/dev/null 2>&1; then \
        echo "Using mvnd for faster testing..."; \
        mvnd test {{ARGS}} 2>&1 | awk '\
            BEGIN { \
                scanning_started = 0; \
                compilation_section = 0; \
                test_section = 0; \
            } \
            /INFO.*Scanning for projects/ { \
                scanning_started = 1; \
                print; \
                next; \
            } \
            !scanning_started && /^WARNING:/ { next } \
            /COMPILATION ERROR/ { compilation_section = 1 } \
            /BUILD FAILURE/ && compilation_section { compilation_section = 0 } \
            /INFO.*T E S T S/ { \
                test_section = 1; \
                print "-------------------------------------------------------"; \
                print " T E S T S"; \
                print "-------------------------------------------------------"; \
                next; \
            } \
            compilation_section { print } \
            test_section { print } \
            !test_section && scanning_started { \
                if (/INFO.*Scanning|INFO.*Building|INFO.*resources|INFO.*compiler|INFO.*surefire|ERROR|FAILURE/) { \
                    print; \
                } \
                if (/WARNING.*COMPILATION|ERROR.*/) { \
                    print; \
                } \
            }'; \
    else \
        echo "Using mvn (mvnd not available)..."; \
        mvn test {{ARGS}} 2>&1 | awk '\
            BEGIN { \
                scanning_started = 0; \
                compilation_section = 0; \
                test_section = 0; \
            } \
            /INFO.*Scanning for projects/ { \
                scanning_started = 1; \
                print; \
                next; \
            } \
            !scanning_started && /^WARNING:/ { next } \
            /COMPILATION ERROR/ { compilation_section = 1 } \
            /BUILD FAILURE/ && compilation_section { compilation_section = 0 } \
            /INFO.*T E S T S/ { \
                test_section = 1; \
                print "-------------------------------------------------------"; \
                print " T E S T S"; \
                print "-------------------------------------------------------"; \
                next; \
            } \
            compilation_section { print } \
            test_section { print } \
            !test_section && scanning_started { \
                if (/INFO.*Scanning|INFO.*Building|INFO.*resources|INFO.*compiler|INFO.*surefire|ERROR|FAILURE/) { \
                    print; \
                } \
                if (/WARNING.*COMPILATION|ERROR.*/) { \
                    print; \
                } \
            }'; \
    fi

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
