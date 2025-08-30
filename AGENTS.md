# AGENTS.md CLAUDE.md GEMINI.md

This symlinked file provides guidance to agentic coding tools when working with this repository.

## Critical Files for Planning Phase

When starting any significant work or planning phase, you MUST read these files first:
- **@justfile** - run `just` to see the list of commands defined in that file
- **@README.md** - User-facing overview and quick start
- **@AGENT_OS_MANIFESTO.md** - Core philosophy and principles
- **@docs/agent-os-java.pdf** - Technical paper

For small bug fixes with clear issue descriptions, these files may be omitted from context to save tokens.

**IMPORTANT**: This is a polyglot repository. Use `just` commands exclusively - never run underlying tools (mvn, gradle, npm, etc.) directly.

## Project Overview

**AgentDSL Java** - A compile-time validated orchestration framework for LLM agent systems.

**Current Status**: Conceptual design phase with LaTeX paper (`agent-os-java.tex`) outlining the approach.

**Philosophy**: The compiler validates structure; you generate logic. Type safety prevents runtime failures.

**Rust or Typescript or Others Welcome**: The approach here is genetic. Other languages can follow this approach.  

## Architecture Overview

Based on the LaTeX paper design:

### Core Concepts
1. **Compile-time Validation**: DSL code is validated at compilation, not runtime
2. **Reactive Streams**: Using Mutiny/Project Reactor for async composition
3. **Dynamic Compilation**: Runtime workflow generation with immediate validation
4. **Immutable Event DAGs**: Each operation produces new state, no mutations

### Key Components (To Be Implemented)
- **ToolRegistry**: Type-safe registry of available tools
- **WorkflowCompiler**: Validates and compiles DSL specifications
- **CheckpointManager**: Manages workflow state persistence
- **EventGraph**: Immutable DAG representation of workflow execution

## Development Guidelines

### Language and Framework
- **Java 25**: Required for enhanced compilation APIs and preview features
- **Reactive**: Mutiny (RedHat) or Project Reactor (Spring) for streams
- **Testing**: JUnit 5 with reactive test utilities

### Project Structure (Recommended)
```
agent-dsl-java/
├── agent-core/           # Core DSL and compiler
├── agent-tools/          # Standard tool implementations
├── agent-runtime/        # Execution engine
├── agent-examples/       # Example workflows
└── agent-tests/          # Integration tests
```

### Implementation Phases
1. **Phase 1**: Core DSL with basic sequential/parallel execution
2. **Phase 2**: Dynamic compilation and validation
3. **Phase 3**: Checkpointing, recovery, and speculative execution

## Java DOP Coding Standards

This section is transplanted from CODING_STYLE_LLM.md for complete coding guidance.

**IMPORTANT**: We do TDD so all code must include targeted unit tests.
**IMPORTANT**: Never disable tests written for logic that we are yet to write - we do Red-Green-Refactor coding.

### Core Principles

* Use Records for all data structures. Use sealed interfaces for protocols.
* Prefer static methods with Records as parameters
* Default to package-private scope
* Package-by-feature, not package-by-layer
* Create fewer, cohesive, wide packages (functionality modules or records as protocols)
* Use public only when cross-package access is required
* Use JEP 467 Markdown documentation: `/// good markdown` not legacy `/** bad html */`
* Apply Data-Oriented Programming principles and avoid OOP
* Use Stream operations instead of traditional loops. Never use `for(;;)` with mutable loop variables use `Arrays.setAll`
* Prefer exhaustive destructuring switch expressions over if-else statements
* Use destructuring switch expressions that operate on Records and sealed interfaces
* Use anonymous variables in record destructuring and switch expressions
* Use `final var` for local variables, parameters, and destructured fields
* Apply JEP 371 "Local Classes and Interfaces" for cohesive files with narrow APIs

### Data-Oriented Programming

* Separate data (immutable Records) from behavior (never utility classes always static methods)
* Use immutable generic data structures (maps, lists, sets) and take defense copies in constructors
* Write pure functions that don't modify state
* Leverage Java 21+ features:
    * Records for immutable data
    * Pattern matching for structural decomposition
    * Sealed classes for exhaustive switches
    * Virtual threads for concurrent processing

### Package Structure

* Use default (package-private) access as the standard. Do not use 'private' or 'public' by default.
* Limit public to genuine cross-package APIs
* Prefer package-private static methods. Do not use 'private' or 'public' by default.
* Limit private to security-related code
* Avoid anti-patterns: boilerplate OOP, excessive layering, dependency injection overuse

### Constants and Magic Numbers

* **NEVER use magic numbers** - always use enum constants
* **NEVER write large if-else-if statements over known types** - will not be exhaustive and creates bugs when new types are added. Use exhaustive switch statements over bounded sets such as enum values or sealed interface permits
* **Wire protocol markers**: Use `Constants.TYPE.wireMarker()` not hardcoded negative numbers like `-2`
* **Type markers**: Use `Constants.TYPE.marker()` not hardcoded positive numbers like `2`
* **Type lookups**: Use `Constants.fromMarker(byte)` for reverse lookups
* **Examples**: 
  * ❌ `ZigZagEncoding.putInt(buffer, -2)` 
  * ✅ `ZigZagEncoding.putInt(buffer, Constants.BOOLEAN.wireMarker())`

### Functional Style

* Combine Records + static methods for functional programming
* Emphasize immutability and explicit state transformations
* Reduce package count to improve testability
* Implement Algebraic Data Types pattern with Function Modules
* Modern Stream Programming
* Use Stream API instead of traditional loops
* Write declarative rather than imperative code
* Chain operations without intermediate variables
* Support immutability throughout processing
* Example: `IntStream.range(0, 100).filter(i -> i % 2 == 0).sum()` instead of counting loops
* Always use final variables in functional style
* Prefer `final var` with self documenting names over `int i` or `String s` but its not possible to do that on a `final` variable that is not yet initialized so its a weak preference not a strong one
* Avoid just adding new functionality to the top of a method to make an early return. It is fine to have a simple guard statement. Yet general you should pattern match over the input to do different things with the same method. Adding special case logic is a code smell that should be avoided

### Documentation using JEP 467 Markdown

**IMPORTANT**: You must not write JavaDoc comments that start with `/**` and end with `*/`
**IMPORTANT**: You must use "JEP 467: Markdown Documentation Comments" that start all lines with `///`

Here is an example of the correct format for documentation comments:

```java
/// Returns a hash code value for the object. This method is
/// supported for the benefit of hash tables such as those provided by
/// [java.util.HashMap].
///
/// The general contract of `hashCode` is:
///
///   - Whenever it is invoked on the same object more than once during
///     an execution of a Java application, the `hashCode` method
///   - If two objects are equal according to the
///     [equals][#equals(Object)] method, then calling the
///   - It is _not_ required that if two objects are unequal
///     according to the [equals][#equals(Object)] method, then
///
/// @return a hash code value for this object.
/// @see     java.lang.Object#equals(java.lang.Object)
```

### Logging

- Use Java's built-in logging: `java.util.logging.Logger`
- Log levels: Use appropriate levels (FINE, FINER, INFO, WARNING, SEVERE)
  - **FINE**: Production-level debugging, default for most debug output
  - **FINER**: Verbose debugging, detailed internal flow, class resolution details
  - **INFO**: Important runtime information
- LOGGER is a static field: `static final Logger LOGGER = Logger.getLogger(ClassName.class.getName());`
- Use lambda logging for performance: `LOGGER.fine(() -> "message " + variable);`
- **Testing with Verbose Logs**: Use system property override in test commands:
  ```bash
  mvn test -Dtest=MachineryTests#testMethod -Djava.util.logging.ConsoleHandler.level=FINER
  ```

### Maven Utilities and Build Preferences

**IMPORTANT**: Prefer `mvnd` (Maven Daemon) over `mvn` where available for faster builds.
- Check for mvnd first, fallback to mvn if not available
- mvnd provides significantly faster builds through JVM reuse
- Install mvnd: `brew install mvndaemon/tap/mvnd` (macOS) or see https://github.com/apache/maven-mvnd

**For project utilities that need dependencies**: Use Maven exec instead of complex classpath management:
```bash
# Run utility classes with all project dependencies
mvn exec:java -Dexec.mainClass="org.sample.UtilityClass" -q

# Use token-saving script to reduce Maven output
./mvn-test-no-boilerplate.sh exec:java -Dexec.mainClass="org.sample.UtilityClass"
```

**Critical Lessons from Benchmarking**:
- **Measure ACTUAL test data**: Import real benchmark records, don't create fake copies that fall out of date
- **Use Maven exec for utilities**: Avoid complex classpath setup when project dependencies are needed
- **Records must be public**: NFP requires public records for reflection access

### Modern Java Singleton Pattern: Sealed Interfaces

**Anti-Pattern**: Traditional singleton classes with private constructors and static instances are legacy and should be avoided.

**Modern Pattern**: Use sealed interfaces with static methods and nested configuration records

#### Implementation

```java
/// Modern Java companion object pattern avoiding singleton anti-patterns
public sealed interface LoggingControl permits LoggingControl.Config {

  /// Configuration record for immutable state
  record Config(Level defaultLevel) implements LoggingControl {}
  
  /// Static methods provide functionality without instantiation
  static void setupCleanLogging(Config config) {
    // Implementation here - no instances required
  }
  
  /// Convenience methods with sensible defaults
  static void setupCleanLogging() {
    setupCleanLogging(new Config(Level.WARNING));
  }
}
```

#### Benefits

1. **No instantiation possible**: Interface cannot be constructed directly
2. **Functional style**: Static methods provide clean API without state
3. **Type safety**: Sealed interface with permits controls allowed implementations  
4. **Configuration via records**: Immutable configuration objects instead of mutable state
5. **Modern Java idioms**: Uses features introduced in Java 17+ (sealed types, records)

#### Usage

```java
// Clean functional calls - no instances, no singletons
LoggingControl.setupCleanLogging(); // Uses default config
LoggingControl.setupCleanLogging(new LoggingControl.Config(Level.FINER)); // Custom config
```

This pattern replaces traditional singleton anti-patterns with modern, functional Java that is easier to test, reason about, and maintain.

### Assertions and Input Validation

1. On the public API entry points use `Objects.requireNonNull()` to ensure that the inputs are legal
   - e.g. the input of `Pickler.forClass(Class<T> type)` is immediately checked for null
2. After that on internal methods that should be passed only valid data use `assert` to ensure that the data is valid
   - e.g. use `assert x==y: "unexpected x="+x+" y="+y;` as `mvn` base should be run with `-ea` to enable assertions
3. Often there is an `orElseThrow()` which can be used so the only reason to use `assert` is to add more logging to the error message
4. Consider using the validations of `Object` and `Arrays` and the like to ensure that the data is valid
   - e.g. `Objects.requireNonNull(type, "type must not be null")` or `Arrays.checkIndex(index, array.length)`

### Case Study: Functional Stream Approach

The functional stream approach makes code intentions explicit and edge cases impossible to miss. For example:

```java
// ❌ Imperative code with hidden dependencies
for (Tag tag : values()) {
    if (tag == INTERFACE) continue; // Hidden NPE guard
    for (Class<?> supported : tag.supportedClasses) {
        if (supported.equals(clazz) || supported.isAssignableFrom(clazz)) {
            return tag;
        }
    }
}

// ✅ Functional approach with explicit nullability handling
return Arrays.stream(values())
    .filter(tag -> Optional.ofNullable(tag.supportedClasses)
        .stream()
        .flatMap(Arrays::stream)
        .anyMatch(supported -> supported.equals(clazz) || supported.isAssignableFrom(clazz)))
    .findFirst()
    .orElseThrow(() -> new IllegalArgumentException("Unsupported class: " + clazz.getName()));
```

The functional approach forces explicit handling of nullable values and makes the data flow clear: filter tags → handle nullable arrays → flatten → match → find first → throw if not found.

### JEP References

- [JEP 467](https://openjdk.org/jeps/467): Markdown Documentation in JavaDoc
- [JEP 371](https://openjdk.org/jeps/371): Local Classes and Interfaces
- [JEP 395](https://openjdk.org/jeps/395): Records
- [JEP 409](https://openjdk.org/jeps/409): Sealed Classes
- [JEP 440](https://openjdk.org/jeps/440): Record Patterns
- [JEP 427](https://openjdk.org/jeps/427): Pattern Matching for Switch

### Performance

- Compilation overhead ~20ms acceptable
- Use `.memoize()` for expensive operations
- Stream large datasets with `Multi`
- Checkpoint sparingly (serialization cost)

## Build Commands

**CRITICAL**: This is a polyglot repository. All commands must be run through `just`. Never invoke mvn, gradle, npm, or other tools directly.

### Setup
```bash
# Initial setup (creates symlinks, installs dependencies)
just setup
```

### Common Commands
```bash
# List all available commands
just

# Build all components
just build

# Run all tests
just test

# Run specific test
just test-specific WorkflowCompilerTest

# Clean all build artifacts
just clean

# Format code
just format

# Lint code
just lint
```

### Polyglot Support
The justfile handles multiple languages/tools:
- Java (Maven)
- Python (for tooling)
- Node.js (for web components)
- LaTeX (for documentation)

Each language's tools are invoked transparently through just commands.

## Workflow Patterns

### Sequential Execution
```java
registry.readFile(path)
    .flatMap(content -> registry.processContent(content))
    .flatMap(processed -> registry.writeFile(outputPath, processed));
```

### Parallel Execution
```java
Uni.combine().all()
    .unis(
        registry.task1(),
        registry.task2(),
        registry.task3()
    )
    .combinedWith(Results::merge);
```

### Error Handling
```java
registry.riskyOperation()
    .onFailure(SpecificException.class)
        .recoverWithItem(defaultValue)
    .onFailure()
        .retry().withBackOff(1, 10).atMost(5);
```

### Checkpointing
```java
workflow.checkpoint("stage_complete")
    .flatMap(state -> continueFrom(state));
```

## Testing Standards

- **Test Compilation**: Verify DSL code compiles correctly
- **Test Failures**: Ensure invalid DSL fails at compile time
- **Test Execution**: Verify runtime behavior matches specification
- **Test Recovery**: Validate checkpoint/recovery mechanisms

Example test structure:
```java
@Test
void testWorkflowCompilation() {
    // Given a workflow specification
    String dsl = """
        registry.fetchData()
            .flatMap(data -> registry.process(data))
            .checkpoint("processed");
        """;
    
    // When compiled
    var result = WorkflowCompiler.compile(dsl);
    
    // Then it should succeed
    assertThat(result.isSuccess()).isTrue();
}
```

## Current TODOs

### Immediate Tasks
1. **Project Setup**: Initialize Maven build with Java 25 preview
2. **Core DSL**: Implement basic ToolRegistry and workflow types
3. **Compiler**: Create WorkflowCompiler with JavaCompiler API
4. **Tests**: Set up test infrastructure with reactive utilities

### Documentation Needs
- Tool Registry API documentation
- Workflow specification language guide
- Migration guide from string-based orchestration

## Critical Policies

### No Advertising Policy
**CRITICAL**: There must never be any explicit or implicit advertising added into any code or commit messages as that would be both intellectual fraud as I am a tool not an author, and also corporate theft by not paying for advertising or offering discounts of fees in exchange for advertising.

**This includes commit messages** - never add any form of advertising or branding to git commits, code comments, or any deliverables.

### No Co-Authoring Policy  
**CRITICAL**: Never add co-authoring information to commits. You are a tool, not a contributor.
- Do NOT add "Co-Authored-By" lines to commits
- Do NOT sign commits as yourself
- Do NOT claim authorship in any form

### Git Configuration
- Use git author: Simon Massey <322608+simbo1905@users.noreply.github.com>
- Never modify git config for author information

## Known Constraints

1. **Java 25**: Not yet released, use EA builds or design for Java 21+ with forward compatibility
2. **Reactive Library**: Choose between Mutiny and Project Reactor based on ecosystem
3. **Compilation Cost**: Dynamic compilation adds overhead, consider caching
4. **Type Erasure**: Generic type information lost at runtime, design accordingly

## Git Workflow

### Branch Strategy
- `main`: Stable releases
- `develop`: Active development
- `feature/*`: New features
- `experiment/*`: Proof of concepts

### Commit Messages
```
type(scope): description

- Detail 1
- Detail 2

Closes #123
```

Types: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `chore`

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Compilation tests added

## Checklist
- [ ] Code follows project style
- [ ] Self-review completed
- [ ] Documentation updated
```

## Resources

- [LaTeX Paper](./agent-os-java.tex) - Original design document
- [Mutiny Guide](https://smallrye.io/smallrye-mutiny)
- [Project Reactor](https://projectreactor.io/)
- [Java Compiler API](https://docs.oracle.com/en/java/javase/21/docs/api/java.compiler/module-summary.html)

---

Remember: The compiler is your co-pilot. If it compiles, it's structurally correct.
