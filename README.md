# AgentDSL

[![CI](https://github.com/simbo1905/agent-dsl/actions/workflows/ci.yml/badge.svg)](https://github.com/simbo1905/agent-dsl/actions/workflows/ci.yml)
[![Java](https://img.shields.io/badge/Java-24-orange)](https://openjdk.org/projects/jdk/24/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Compile-time validated orchestration for LLM agent systems using Java 25 and reactive streams.

## Quick Start

```bash
# Setup
git clone https://github.com/simbo1905/agent-dsl.git
cd agent-dsl
just setup

# Build and test
just build
just test

# View all commands
just
```

## Overview

AgentDSL enables LLMs to generate executable workflow specifications that are validated at compile-time rather than runtime. By leveraging Java's type system and reactive stream abstractions, we catch structural errors before execution.

**Key Benefits**:
- Compile-time validation prevents runtime failures
- Type-safe tool composition
- Reactive orchestration with Mutiny/WebFlux
- Selective context loading reduces token usage
- DAG-based history supports parallel execution

## Documentation

- **[Technical Paper (PDF)](docs/agent-os-java.pdf)** - Detailed architecture and design
- **[Manifesto](AGENT_OS_MANIFESTO.md)** - Core philosophy and principles
- **[Development Guide](CLAUDE.md)** - Internal development guidelines

## Example

```java
// LLM generates this workflow specification
String workflowCode = """
    registry.readFile("src/main.py")
        .flatMap(content -> registry.runTests("test_*.py"))
        .onFailure().retry().withBackOff(2, 5).atMost(3)
        .checkpoint("tests_complete");
    """;

// Compile and validate
WorkflowCompiler compiler = new WorkflowCompiler();
Class<?> workflowClass = compiler.compile(workflowCode);

// Execute if compilation succeeds
workflow.execute(context).await().indefinitely();
```

## Project Structure

This is a polyglot repository managed through `just` commands:
- **agent-core/** - Core DSL and compiler (Java)
- **agent-tools/** - Standard tool implementations (Java)
- **agent-runtime/** - Execution engine (Java)
- **agent-web/** - Web interface (TypeScript/React)
- **agent-py/** - Python tools and integrations
- **docs/** - Documentation and papers

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

Apache 2.0 - See [LICENSE](LICENSE) file.

## Contact

- GitHub: [simbo1905/agent-dsl](https://github.com/simbo1905/agent-dsl)
- Issues: [GitHub Issues](https://github.com/simbo1905/agent-dsl/issues)

---

*"The compiler is your co-pilot"* - The AgentDSL Philosophy