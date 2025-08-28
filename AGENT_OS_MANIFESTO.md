# The Agent OS Manifesto

We are uncovering better ways of building autonomous agent systems by doing it and helping others do it.

Through this work we have come to value:

**Operating system abstractions** over application-level orchestration  
**Memory as first-class infrastructure** over conversational context  
**Process isolation and communication** over monolithic architectures  
**Resource scheduling and limits** over unbounded execution  
**System-level debugging** over prompt engineering  

That is, while there is value in the items on the right, we value the items on the left more.

## Principles behind the Agent OS Manifesto

1. **Agents are processes, not functions**  
   They deserve process tables, resource limits, and lifecycle management.

2. **Memory is infrastructure, not an implementation detail**  
   Shared memory, private memory, and inter-process communication are OS-level concerns.

3. **Tools are system calls, not library functions**  
   They should be mediated, monitored, and secured by the kernel.

4. **Scheduling is a kernel responsibility**  
   CPU time, memory allocation, and I/O bandwidth need fair arbitration.

5. **Security boundaries matter**  
   Agents should run with least privilege and clear capability constraints.

6. **Debugging requires system-level visibility**  
   Process traces, memory dumps, and execution logs are essential infrastructure.

7. **Resource accounting enables optimization**  
   You cannot improve what you cannot measure at the system level.

8. **Inter-agent communication needs protocols**  
   Message passing, shared memory, and synchronization primitives prevent chaos.

9. **The kernel protects agents from each other**  
   Isolation prevents cascade failures and enables safe experimentation.

10. **System calls should be deterministic**  
    The same inputs should produce predictable outputs, enabling reproducibility.

11. **Virtualization enables experimentation**  
    Agents should run in containers with checkpoint/restore capabilities.

12. **The OS provides, the agent consumes**  
    Infrastructure concerns belong in the kernel, not in agent logic.

## Core Subsystems

We implement these principles through:

### Process Management
- Agent lifecycle control (spawn, pause, resume, terminate)
- Process isolation with capability-based security
- Resource quotas and accounting

### Memory Management  
- Hierarchical memory spaces (system, user, shared)
- Memory-mapped files for persistent state
- Copy-on-write for efficient forking

### Filesystem
- Virtual filesystem for agent workspaces
- Versioned file access with audit trails
- Quota enforcement and access control

### Scheduling
- Priority-based CPU scheduling
- Memory pressure handling
- I/O bandwidth allocation

### Inter-Process Communication
- Message queues with delivery guarantees
- Shared memory segments with synchronization
- Event notification system

### System Calls
- Tool invocation as mediated system calls
- Standardized error handling and recovery
- Comprehensive audit logging

## Implementation Layers

```
┌─────────────────────────────────────┐
│         Agent Applications          │
├─────────────────────────────────────┤
│    Agent DSL (Workflow Layer)       │
├─────────────────────────────────────┤
│      Agent Runtime Library          │
├─────────────────────────────────────┤
│        System Call Interface        │
├─────────────────────────────────────┤
│         Agent OS Kernel             │
│  ┌─────────┬──────────┬─────────┐  │
│  │ Process │  Memory  │   I/O   │  │
│  │  Mgmt   │   Mgmt   │  Mgmt   │  │
│  └─────────┴──────────┴─────────┘  │
├─────────────────────────────────────┤
│      Hardware Abstraction Layer     │
└─────────────────────────────────────┘
```

## Join Us

The Agent OS movement seeks systems programmers, OS researchers, and distributed systems engineers who understand that agents need more than orchestration - they need an operating system.

We believe that applying OS principles to agent systems will enable:
- Multi-agent systems that scale to thousands of concurrent agents
- Reliable production deployments with system-level guarantees  
- Debugging tools that make agent behavior comprehensible
- Security models that enable safe multi-tenant execution

This manifesto is a living document. Fork it, discuss it, improve it.

---

*Initial signatories:*
- Simon Massey (@simbo1905) <322608+simbo1905@users.noreply.github.com>

*To add your name, submit a pull request to the manifesto repository.*

## Related Work

- **Agent DSL**: Compile-time validated workflow orchestration
- **LangKernel**: Experimental agent OS kernel in Rust
- **AgentContainer**: OCI-compatible agent runtime
- **MemFS**: Hierarchical memory filesystem for agents

## References

- "The Evolution of Operating Systems" - Tanenbaum
- "Microkernel-based Operating Systems" - Liedtke
- "Plan 9 from Bell Labs" - Pike et al.
- "The Synthesis Kernel" - Pu et al.