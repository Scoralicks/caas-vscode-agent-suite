# Repository agent guidance

For any task concerning Microsoft Dynamics 365 Contact Center, use the agents in `.github/agents` and the common policy in `.github/instructions/mdcc-common.instructions.md`.

The official documentation must be synchronized with `scripts/sync-mdcc-docs.ps1` or the VS Code task **MDCC: Sync official documentation** before relying on local source files.

Do not answer product questions from model memory when official documentation is available.

For broad technical research, content production, ecosystem signals, and prototypes, use the `Technical Researcher` agent and the workspace `agent-reach` skill. Treat community sources as supplementary and keep official Microsoft evidence authoritative for MDCC product claims.
