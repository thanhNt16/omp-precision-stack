# omp-precision-stack

One-command installer for the **Precision Skill Stack** on [Oh My Pi (omp)](https://github.com/.omp) and any `~/.agents/skills`-compatible coding agent (Hermes, Claude Code via symlink, etc.).

Curates and symlinks the best skills from 4 upstream packs into a single active stack:

| Pack | Source | Skills installed |
|---|---|---|
| **Matt Pocock Skills** | [mattpocock/skills](https://github.com/mattpocock/skills) | `grill-me`, `grilling`, `domain-modeling`, `wayfinder`, `teach` |
| **Elephant/Goldfish** | [vshvedov/elephant-goldfish](https://github.com/vshvedov/elephant-goldfish) | `eg-brainstorm`, `eg-prd`, `eg-fix-bug`, `eg-new-feature`, `eg-precommit-review` |
| **pstack** | [backnotprop/pstack](https://github.com/backnotprop/pstack) | `poteto-mode`, `unslop`, `create-verification-skill`, `in-your-own-words`, `correct`, `typescript-best-practices`, `architect`, `figure-it-out` |
| **Superpowers** (if already present in `~/.agents/skills`) | local | `writing-plans`, `test-driven-development`, `systematic-debugging`, `subagent-driven-development` |

Total: **~22 curated skills**, symlinked (no duplication) into both:
- `~/.omp/agent/skills/` (Oh My Pi)
- `~/.agents/skills/` (generic agents)

## Install

```bash
git clone https://github.com/thanhNt16/omp-precision-stack.git
cd omp-precision-stack
chmod +x setup_omp_stack.sh
./setup_omp_stack.sh
```

Idempotent: safe to re-run. Existing links are kept, missing ones are added.

## What the stack gives the agent

- **Socratic gating** (grill-me / grilling): lock requirements before writing code
- **TDD discipline** (test-driven-development): red-green-refactor enforced
- **Systematic debugging** (systematic-debugging): root-cause before fix
- **Zero-slop output** (unslop / poteto-mode): strip AI-isms, keep voice
- **Pre-commit review** (eg-precommit-review): adversarial self-audit before done

## Uninstall

```bash
./uninstall.sh
```

Removes only the symlinks this installer created. Upstream clones stay in `~/.agents/skill-packs/`.

## License

MIT for the installer. Each skill pack keeps its own upstream license.
