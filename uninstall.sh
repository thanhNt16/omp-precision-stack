#!/usr/bin/env bash
# Removes only the symlinks created by setup_omp_stack.sh.
# Upstream clones in ~/.agents/skill-packs/ are left intact.
set -euo pipefail

AGENTS_SKILLS_DIR="${HOME}/.agents/skills"
OMP_SKILLS_DIR="${HOME}/.omp/agent/skills"

SKILLS=(
  grill-me grilling domain-modeling wayfinder teach
  eg-brainstorm eg-prd eg-fix-bug eg-new-feature eg-precommit-review
  poteto-mode unslop create-verification-skill in-your-own-words correct
  typescript-best-practices architect figure-it-out
  writing-plans test-driven-development systematic-debugging subagent-driven-development using-superpowers
)

for name in "${SKILLS[@]}"; do
  for dir in "${AGENTS_SKILLS_DIR}" "${OMP_SKILLS_DIR}"; do
    target="${dir}/${name}"
    # Only remove symlinks (never real directories the user may have installed themselves)
    if [ -L "${target}" ]; then
      rm "${target}"
      echo "[-] removed ${target}"
    fi
  done
done

echo "Uninstall complete. Upstream clones preserved in ~/.agents/skill-packs/."
