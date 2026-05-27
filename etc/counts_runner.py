#!/usr/bin/env python3
"""
CLI wrapper around counts.py for use from counts.array.slurm.

Commands:
  count-files <filelist> <start> <end>   -- count files[start:end], tokenizer loaded once
  aggregate   [--force] <root_dir>       -- write counts.json for all dirs under root_dir
  report      [--depth N] <dir>          -- convert counts.json to counts.md and metadata.md
"""

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import counts


def cmd_count_files(filelist, start, end):
    from transformers import AutoTokenizer
    with open(filelist) as fh:
        files = [l.strip() for l in fh if l.strip()]
    tokenizer = AutoTokenizer.from_pretrained(
        "google/gemma-3-4b-it", trust_remote_code=True, use_fast=True)
    for path in files[start:end]:
        print(f"Counting: {path}", flush=True)
        counts.count_file(path, tokenizer=tokenizer)
        print(f"Done: {path}", flush=True)


def _per_file_counts_path(data_file):
    d = os.path.dirname(data_file)
    b = os.path.basename(data_file)
    for ext in (".zstd", ".zst", ".gz", ".jsonl", ".json"):
        if b.endswith(ext):
            b = b[:-len(ext)]
    return os.path.join(d, f".{b}.counts.json")


def _counts_file(d):
    """Return path to counts.json or .counts.json in d, preferring counts.json."""
    for name in ("counts.json", ".counts.json"):
        p = os.path.join(d, name)
        if os.path.isfile(p):
            return p
    return None


def _write_counts(d, total):
    import json
    out = os.path.join(d, "counts.json")
    with open(out, "w", encoding="utf-8") as fh:
        json.dump(total, fh, indent=2)
    print(f"Wrote: {out}", flush=True)


def _merge_keys(sub_counts):
    all_required = None
    all_optional = set()
    for c in sub_counts:
        ck = c.get("keys", {})
        if isinstance(ck, dict) and ("required" in ck or "optional" in ck):
            required = set(ck.get("required", []))
            optional = set(ck.get("optional", []))
        else:
            required = set(ck.keys())
            optional = set()
        all_required = required if all_required is None else all_required & required
        all_optional |= optional | (required - (all_required or required))
    return sorted(all_required or []), sorted(all_optional - (all_required or set()))


def cmd_aggregate(root, force=False):
    import json, re
    pattern = r"\.(zst|gz)$"
    root = os.path.realpath(root)

    # Find leaf dirs and their data files
    leaf_dirs = {}
    for dirpath, dirnames, filenames in os.walk(root):
        data_files = sorted(f for f in filenames if re.search(pattern, f))
        if data_files:
            leaf_dirs[dirpath] = data_files

    if not leaf_dirs:
        print(f"ERROR: no files matching {pattern!r} found under {root}", file=sys.stderr)
        sys.exit(1)

    # Validate all per-file counts exist
    missing = []
    for d, data_files in leaf_dirs.items():
        for fname in data_files:
            cp = _per_file_counts_path(os.path.join(d, fname))
            if not os.path.isfile(cp):
                missing.append(cp)

    if missing:
        for p in missing:
            print(f"MISSING: {p}", file=sys.stderr)
        if not force:
            print(f"ERROR: {len(missing)} per-file counts missing. Use --force to skip.",
                  file=sys.stderr)
            sys.exit(1)
        print(f"WARNING: {len(missing)} per-file counts missing, proceeding with --force.",
              file=sys.stderr)

    # Bottom-up traversal: os.walk with topdown=False visits leaves first, root last
    for dirpath, dirnames, filenames in os.walk(root, topdown=False):
        data_files = sorted(f for f in filenames if re.search(pattern, f))
        if data_files:
            # Leaf dir: aggregate from per-file counts
            total = {k: 0 for k in ("bytes", "documents", "segments", "tokens", "characters")}
            key_counts = {}
            for fname in data_files:
                cp = _per_file_counts_path(os.path.join(dirpath, fname))
                if not os.path.isfile(cp):
                    continue
                with open(cp) as fh:
                    c = json.load(fh)
                for k in total:
                    total[k] += c.get(k, 0)
                for key, count in c.get("keys", {}).items():
                    key_counts[key] = key_counts.get(key, 0) + count
            total_docs = total["documents"]
            total["keys"] = {
                "required": sorted(k for k, n in key_counts.items() if total_docs and n == total_docs),
                "optional": sorted(k for k, n in key_counts.items() if not total_docs or n != total_docs),
            }
            _write_counts(dirpath, total)
        else:
            # Non-leaf dir: aggregate from children that have counts.json
            sub_counts = []
            for e in sorted(dirnames):
                p = _counts_file(os.path.join(dirpath, e))
                if p:
                    with open(p) as fh:
                        sub_counts.append(json.load(fh))
            if sub_counts:
                total = {k: 0 for k in ("bytes", "documents", "segments", "tokens", "characters")}
                for c in sub_counts:
                    for k in total:
                        total[k] += c.get(k, 0)
                required, optional = _merge_keys(sub_counts)
                total["keys"] = {"required": required, "optional": optional}
                _write_counts(dirpath, total)
            else:
                print(f"WARNING: no counts found under {dirpath}, skipping", file=sys.stderr)


def cmd_report(target_dir, depth=1):
    import json

    def find_at_depth(base, d):
        subdirs = [
            os.path.join(base, e) for e in sorted(os.listdir(base))
            if os.path.isdir(os.path.join(base, e)) and not os.path.islink(os.path.join(base, e))
        ]
        if d == 0 or not subdirs:
            return [base]
        result = []
        for full in subdirs:
            result.extend(find_at_depth(full, d - 1))
        return result

    subdirs = find_at_depth(target_dir, depth)

    rows = []
    totals = {k: 0 for k in ("bytes", "documents", "segments", "tokens", "characters")}
    sub_counts = []

    for d in subdirs:
        p = _counts_file(d)
        if p is None:
            rel = os.path.relpath(d, target_dir)
            print(f"WARNING: no counts.json in {rel}, skipping", file=sys.stderr)
            continue
        with open(p) as fh:
            c = json.load(fh)
        row = {k: c[k] for k in ("bytes", "documents", "segments", "tokens", "characters")}
        row["name"] = os.path.relpath(d, target_dir)
        rows.append(row)
        for k in totals:
            totals[k] += c[k]
        sub_counts.append(c)

    required, optional = _merge_keys(sub_counts)

    counts_path = os.path.join(target_dir, "counts.md")
    with open(counts_path, "w", encoding="utf-8") as fh:
        fh.write("| **Partition** | **Bytes** | **Documents** | **Segments** | **Tokens** | **Characters** |\n")
        fh.write("|-------------|----------:|--------------:|-------------:|-----------:|---------------:|\n")
        for row in rows:
            fh.write("| {name} | {bytes:,} | {documents:,} | {segments:,} | {tokens:,} | {characters:,} |\n".format(**row))
        fh.write("| **Total** | {bytes:,} | {documents:,} | {segments:,} | {tokens:,} | {characters:,} |\n".format(**totals))
    print(f"Wrote {counts_path}")

    metadata_path = os.path.join(target_dir, "metadata.md")
    with open(metadata_path, "w", encoding="utf-8") as fh:
        fh.write("| **Field** | **Status** |\n")
        fh.write("|-----------|------------|\n")
        for key in required:
            fh.write(f"| {key} | required |\n")
        for key in optional:
            fh.write(f"| {key} | optional |\n")
    print(f"Wrote {metadata_path}")


if __name__ == "__main__":
    args = sys.argv[1:]
    cmd = args[0] if args else ""

    if cmd == "count-files":
        filelist, start, end = args[1], int(args[2]), int(args[3])
        cmd_count_files(filelist, start, end)

    elif cmd == "aggregate":
        force = "--force" in args
        rest = [a for a in args[1:] if not a.startswith("--")]
        if not rest:
            print("Usage: counts_runner.py aggregate [--force] <root_dir>", file=sys.stderr)
            sys.exit(1)
        cmd_aggregate(rest[0], force=force)

    elif cmd == "report":
        depth = 1
        rest = []
        i = 1
        while i < len(args):
            if args[i] == "--depth" and i + 1 < len(args):
                depth = int(args[i + 1])
                i += 2
            else:
                rest.append(args[i])
                i += 1
        if not rest:
            print("Usage: counts_runner.py report [--depth N] <dir>", file=sys.stderr)
            sys.exit(1)
        cmd_report(rest[0], depth=depth)

    else:
        print("Usage: counts_runner.py count-files <filelist> <start> <end>", file=sys.stderr)
        print("       counts_runner.py aggregate [--force] <root_dir>", file=sys.stderr)
        print("       counts_runner.py report [--depth N] <dir>", file=sys.stderr)
        sys.exit(1)
