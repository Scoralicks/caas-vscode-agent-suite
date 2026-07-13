#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REFERENCE_ROOT="${1:-$ROOT_DIR/.reference}"
REPO_DIR="$REFERENCE_ROOT/dynamics-365-contact-center"
DOCS_DIR="$REPO_DIR/contact-center"

mkdir -p "$REFERENCE_ROOT"

if [[ -d "$REPO_DIR/.git" ]]; then
  git -C "$REPO_DIR" fetch origin main --depth 1
  git -C "$REPO_DIR" reset --hard origin/main
  git -C "$REPO_DIR" clean -fd
else
  rm -rf "$REPO_DIR"
  git clone --depth 1 --single-branch --branch main \
    https://github.com/MicrosoftDocs/dynamics-365-contact-center.git "$REPO_DIR"
fi

[[ -d "$DOCS_DIR" ]] || { echo "Documentation directory not found: $DOCS_DIR" >&2; exit 1; }

COMMIT="$(git -C "$REPO_DIR" rev-parse HEAD)"
COMMIT_DATE="$(git -C "$REPO_DIR" show -s --format=%cI HEAD)"
COUNT="$(find "$DOCS_DIR" -type f -name '*.md' | wc -l | tr -d ' ')"

python3 - "$REFERENCE_ROOT" "$REPO_DIR" "$COMMIT" "$COMMIT_DATE" "$COUNT" <<'PY'
import json
import pathlib
import re
import sys
from datetime import datetime, timezone

reference_root = pathlib.Path(sys.argv[1])
repo_dir = pathlib.Path(sys.argv[2])
commit = sys.argv[3]
commit_date = sys.argv[4]
count = int(sys.argv[5])
docs_dir = repo_dir / "contact-center"

manifest = {
    "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
    "repository": "MicrosoftDocs/dynamics-365-contact-center",
    "branch": "main",
    "commit": commit,
    "commitDate": commit_date,
    "documentationPath": "contact-center",
    "markdownFileCount": count,
    "localPath": str(docs_dir),
    "learnRoot": "https://learn.microsoft.com/en-us/dynamics365/contact-center/",
}
(reference_root / "source-manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")

items = []
for path in sorted(docs_dir.rglob("*.md")):
    text = path.read_text(encoding="utf-8", errors="replace")
    title = None
    ms_date = None
    ms_topic = None
    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) == 3:
            front = parts[1]
            for line in front.splitlines():
                key, sep, value = line.partition(":")
                if not sep:
                    continue
                value = value.strip().strip('"\'')
                if key.strip() == "title" and not title:
                    title = value
                elif key.strip() == "ms.date" and not ms_date:
                    ms_date = value
                elif key.strip() == "ms.topic" and not ms_topic:
                    ms_topic = value
    if not title:
        match = re.search(r"^#\s+(.+)$", text, flags=re.MULTILINE)
        title = match.group(1).strip() if match else None
    items.append({
        "path": path.relative_to(repo_dir).as_posix(),
        "title": title,
        "msDate": ms_date,
        "msTopic": ms_topic,
        "sizeBytes": path.stat().st_size,
    })

index = {
    "generatedAtUtc": datetime.now(timezone.utc).isoformat(),
    "sourceCommit": commit,
    "count": len(items),
    "files": items,
}
(reference_root / "mdcc-doc-index.json").write_text(json.dumps(index, indent=2), encoding="utf-8")
PY

echo "Documentation synchronized successfully."
echo "Commit: $COMMIT"
echo "Markdown files: $COUNT"
echo "Docs: $DOCS_DIR"
