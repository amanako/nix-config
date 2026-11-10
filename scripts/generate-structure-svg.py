#!/usr/bin/env python3
"""Regenerate assets/structure.svg from the repo layout.

The tree shape, depth and comments are declared below. Aspect folder names are
read from the filesystem, so a rename under ``modules/den/aspects`` shows up on
the next run; only the ``ASPECT_COMMENTS`` map needs a matching edit.

Usage:
    python3 scripts/generate-structure-svg.py            # write assets/structure.svg
    python3 scripts/generate-structure-svg.py -          # print to stdout
    python3 scripts/generate-structure-svg.py --check    # exit 1 if file is stale
"""

from __future__ import annotations

from dataclasses import dataclass, field
from html import escape
from pathlib import Path
import sys

X0 = 16.0
INDENT = 33.6
COMMENT_X = 284.8
ROW0 = 46.0
ROW_H = 20.0
WIDTH = 1057

BG = "#282828"
FG = "#ebdbb2"
MUTED = "#928374"
STROKE = "#504945"

FONT = (
    "'VictorMono NF', 'DejaVu Sans Mono', 'Liberation Mono', "
    "Consolas, Menlo, Monaco, 'Courier New', monospace"
)

# Descriptions for the top-level aspect folders. Keep them in the same
# comma-separated style as the other tree comments.
ASPECT_COMMENTS = {
    "basic": "# git, timezone, desktop entries, backups",
    "core": "# boot, hardware, disks, nix, impermanence",
    "dev": "# editors, shells, tools, terminal",
    "security": "# gpg, sops, ssh",
    "sys": "# system services: forgejo, grafana, prometheus, syncthing",
    "ui": "# bars, desktop-shells, launchers, niri, notifications, wallpaper-managers",
    "utilities": "# anki, browsers, mpv, pdf-viewers, terminal TUIs",
    "extra": "# opt-in: gaming, performance, stylix, nix-utils, bleeding-edge",
}


# Preferred display order; unknown folders are appended alphabetically.
ASPECT_ORDER = ("basic", "core", "security", "dev", "sys", "ui", "utilities", "extra")


@dataclass
class Node:
    name: str
    comment: str = ""
    children: list["Node"] = field(default_factory=list)


def leaf(name: str, comment: str = "") -> Node:
    return Node(name, comment)


def build_tree(root: Path) -> Node:
    aspects_dir = root / "modules" / "den" / "aspects"
    names = sorted(p.name for p in aspects_dir.iterdir() if p.is_dir())
    names.sort(key=lambda name: (ASPECT_ORDER.index(name) if name in ASPECT_ORDER else len(ASPECT_ORDER), name))
    aspects = [leaf(name, ASPECT_COMMENTS.get(name, "")) for name in names]

    return Node(
        ".",
        children=[
            leaf("assets", "# Files, screenshots and other data accessed by users, hosts and aspects"),
            leaf("docs", "# Documentation regarding main cross-cutting topics"),
            leaf("flake.lock", "# Locked dependencies, flattened via fzakaria/nix-auto-follow integration"),
            leaf("flake.nix", "# Entry point - assembled via `flake-parts.lib.mkFlake` + `import-tree`"),
            leaf("justfile", "# Common commands runnable via `just` cli tool"),
            leaf("LICENSE", "# MIT"),
            leaf("README.md", "# Overall repo description"),
            Node(
                "modules",
                children=[
                    Node(
                        "den",
                        "# Den framework infrastructure",
                        children=[
                            Node("aspects", "# All present aspects, grouped by:", children=aspects),
                            leaf("classes", "# Additional classes alongside nixos, homeManager etc."),
                            leaf("entry-point", "# Flake-file definition for den, as well as some default settings"),
                            leaf("extras", "# Optional additions to framework"),
                            leaf("policies", "# Declarations of entity relation, data routing etc."),
                            leaf("quirks", "# Definitions allowing aspects to emit data to be consumed and assembled"),
                            leaf("schema", "# User and host schema options and includes"),
                        ],
                    ),
                    leaf("hosts", "# Machine entries that enable aspects for a system"),
                    leaf("packages", "# Packages for users / hosts or general usage made via flake-parts `perSystem` integration"),
                    leaf("shells", "# Development shells"),
                    leaf("users", "# User entries that enable aspects for a profile"),
                ],
            ),
        ],
    )


def num(value: float) -> str:
    return f"{value:.1f}"


def line(x1: float, y1: float, x2: float, y2: float) -> str:
    return (
        f'<line x1="{num(x1)}" y1="{num(y1)}" x2="{num(x2)}" y2="{num(y2)}" '
        f'stroke="{STROKE}" stroke-width="1.2"/>'
    )


def render(root: Node) -> str:
    # Each row carries its ancestor chain (node + x) so we can draw the
    # vertical spines without re-walking the tree.
    rows: list[tuple[Node, int, int, tuple[tuple[Node, float], ...], bool]] = []

    last_child_row_of: dict[int, int] = {}

    def walk(node: Node, depth: int, ancestors: tuple[tuple[Node, float], ...]) -> None:
        for index, child in enumerate(node.children):
            child_depth = depth + 1
            child_x = X0 + INDENT * child_depth
            child_row = len(rows)
            rows.append((child, child_depth, child_row, ancestors, index == len(node.children) - 1))
            if index == len(node.children) - 1:
                last_child_row_of[id(node)] = child_row
            walk(child, child_depth, ancestors + ((child, child_x),))

    walk(root, 0, ((root, X0),))

    height = 60 + 20 * len(rows)
    out = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{WIDTH}" height="{height}" '
        f'viewBox="0 0 {WIDTH} {height}" font-family="{FONT}" font-size="14">',
        f'<rect width="100%" height="100%" rx="6" fill="{BG}"/>',
        f'<text x="{num(X0)}" y="31.0" fill="{FG}">.</text>',
    ]

    for node, depth, row, ancestors, is_last in rows:
        branch_y = ROW0 + ROW_H * row
        text_y = branch_y + 5.0
        x = X0 + INDENT * depth

        # An ancestor's spine ends at its last direct child's row, and the
        # final segment stops at the branch instead of continuing past it.
        for ancestor, ancestor_x in ancestors:
            last_child_row = last_child_row_of[id(ancestor)]
            if row > last_child_row:
                continue
            end_y = branch_y if row == last_child_row else branch_y + 10.0
            out.append(line(ancestor_x, branch_y - 10.0, ancestor_x, end_y))

        out.append(line(X0 + INDENT * (depth - 1), branch_y, x, branch_y))

        # Short stem under nodes that close out their parent's subtree.
        if node.children and is_last:
            out.append(line(x, branch_y, x, branch_y + 10.0))

        padded = escape(node.name.ljust(32 - 4 * depth))
        out.append(f'<text x="{num(x)}" y="{num(text_y)}" fill="{FG}">{padded}</text>')
        if node.comment:
            out.append(
                f'<text x="{num(COMMENT_X)}" y="{num(text_y)}" fill="{MUTED}">'
                f"{escape(node.comment)}</text>"
            )

    out.append("</svg>")
    return "\n".join(out) + "\n"


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    target = root / "assets" / "structure.svg"
    output = render(build_tree(root))

    args = sys.argv[1:]
    if args == ["-"]:
        sys.stdout.write(output)
        return
    if args == ["--check"]:
        if not target.exists() or target.read_text() != output:
            print(f"{target} is stale; run {Path(__file__).name}", file=sys.stderr)
            raise SystemExit(1)
        return
    if args:
        print(f"usage: {Path(__file__).name} [- | --check]", file=sys.stderr)
        raise SystemExit(2)

    target.write_text(output)
    print(f"wrote {target}")


if __name__ == "__main__":
    main()
