#!/usr/bin/env bash
# ==============================================================================
# Oh My Pi (omp) Precision Skill Stack Installer
# Installs & links: Pocock, Elephant/Goldfish, pstack + Superpowers (if present)
# Idempotent: safe to re-run.
# ==============================================================================
set -euo pipefail

SKILL_PACKS_DIR="${HOME}/.agents/skill-packs"
AGENTS_SKILLS_DIR="${HOME}/.agents/skills"
OMP_SKILLS_DIR="${HOME}/.omp/agent/skills"

mkdir -p "${SKILL_PACKS_DIR}" "${AGENTS_SKILLS_DIR}" "${OMP_SKILLS_DIR}"

echo "=== 1. Ensuring skill pack repositories ==="

clone_if_missing() {
  local url="$1"
  local dest="$2"
  if [ ! -d "${dest}/.git" ]; then
    echo "Cloning $(basename "${dest}")..."
    git clone --depth 1 "${url}" "${dest}"
  else
    echo "$(basename "${dest}") present."
  fi
}

clone_if_missing "https://github.com/mattpocock/skills.git"          "${SKILL_PACKS_DIR}/mattpocock-skills"
clone_if_missing "https://github.com/backnotprop/pstack.git"         "${SKILL_PACKS_DIR}/pstack"
clone_if_missing "https://github.com/vshvedov/elephant-goldfish.git" "${SKILL_PACKS_DIR}/elephant-goldfish"

echo "=== 2. Linking Curated Precision Stack ==="

LINKED=0
link_skill() {
  local src="$1"
  local name="$2"

  if [ ! -e "${src}/SKILL.md" ]; then
    echo "WARN: SKILL.md missing in ${src}, skipping ${name}"
    return
  fi

  if [ ! -e "${AGENTS_SKILLS_DIR}/${name}" ]; then
    ln -sfn "${src}" "${AGENTS_SKILLS_DIR}/${name}"
    echo "[+] ~/.agents/skills/${name}"
  fi

  if [ ! -e "${OMP_SKILLS_DIR}/${name}" ]; then
    ln -sfn "${src}" "${OMP_SKILLS_DIR}/${name}"
    echo "[+] ~/.omp/agent/skills/${name}"
  fi

  LINKED=$((LINKED + 1))
}

# --- Matt Pocock Skills ---
link_skill "${SKILL_PACKS_DIR}/mattpocock-skills/skills/productivity/grill-me"         "grill-me"
link_skill "${SKILL_PACKS_DIR}/mattpocock-skills/skills/productivity/grilling"         "grilling"
link_skill "${SKILL_PACKS_DIR}/mattpocock-skills/skills/engineering/domain-modeling"   "domain-modeling"
link_skill "${SKILL_PACKS_DIR}/mattpocock-skills/skills/engineering/wayfinder"         "wayfinder"
link_skill "${SKILL_PACKS_DIR}/mattpocock-skills/skills/productivity/teach"            "teach"

# --- Elephant / Goldfish ---
link_skill "${SKILL_PACKS_DIR}/elephant-goldfish/codex/skills/eg-brainstorm"       "eg-brainstorm"
link_skill "${SKILL_PACKS_DIR}/elephant-goldfish/codex/skills/eg-prd"              "eg-prd"
link_skill "${SKILL_PACKS_DIR}/elephant-goldfish/codex/skills/eg-fix-bug"          "eg-fix-bug"
link_skill "${SKILL_PACKS_DIR}/elephant-goldfish/codex/skills/eg-new-feature"      "eg-new-feature"
link_skill "${SKILL_PACKS_DIR}/elephant-goldfish/codex/skills/eg-precommit-review" "eg-precommit-review"

# --- pstack ---
link_skill "${SKILL_PACKS_DIR}/pstack/skills/poteto-mode"                  "poteto-mode"
link_skill "${SKILL_PACKS_DIR}/pstack/skills/unslop"                       "unslop"
link_skill "${SKILL_PACKS_DIR}/pstack/skills/create-verification-skill"    "create-verification-skill"
link_skill "${SKILL_PACKS_DIR}/pstack/skills/in-your-own-words"            "in-your-own-words"
link_skill "${SKILL_PACKS_DIR}/pstack/skills/correct"                      "correct"
link_skill "${SKILL_PACKS_DIR}/pstack/skills/typescript-best-practices"    "typescript-best-practices"
link_skill "${SKILL_PACKS_DIR}/pstack/skills/architect"                    "architect"
link_skill "${SKILL_PACKS_DIR}/pstack/skills/figure-it-out"                "figure-it-out"

# --- Superpowers (only if already present in ~/.agents/skills, e.g. installed by obra/superpowers) ---
for sp in writing-plans test-driven-development systematic-debugging subagent-driven-development using-superpowers; do
  if [ -d "${AGENTS_SKILLS_DIR}/${sp}" ] && [ ! -e "${OMP_SKILLS_DIR}/${sp}" ]; then
    ln -sfn "${AGENTS_SKILLS_DIR}/${sp}" "${OMP_SKILLS_DIR}/${sp}"
    echo "[+] ~/.omp/agent/skills/${sp} (from existing superpowers install)"
  fi
done

echo ""
echo "=== 3. Verification ==="
TOTAL=$(ls -1 "${OMP_SKILLS_DIR}" 2>/dev/null | wc -l | tr -d ' ')
echo "Curated skills verified this run: ${LINKED}"
echo "Total skills active in ~/.omp/agent/skills: ${TOTAL}"
echo ""
echo "Precision stack installation complete."
