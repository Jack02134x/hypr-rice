#!/usr/bin/env python3
"""
word_scrambler.py — generate randomized password candidates by scrambling whole words.

Usage examples:
  python3 word_scrambler.py \
    --words "IIST" "Indore" "Institute" "123" "." "and" \
    --count 50 --min-words 2 --max-words 4 --allow-sep --allow-suffix

This will print up to 50 unique candidates, never combining "IIST" and "Institute".
"""

import argparse
import random
import itertools
import sys

def parse_args():
    p = argparse.ArgumentParser(description="Generate randomized passwords by scrambling whole words (no letter changes).")
    p.add_argument('--words', nargs='+', required=True, help='Words/tokens to use (keep punctuation like "." as separate tokens if you want).')
    p.add_argument('--count', type=int, default=100, help='Number of unique candidates to generate (default 100).')
    p.add_argument('--min-words', type=int, default=2, help='Minimum number of tokens per candidate (default 2).')
    p.add_argument('--max-words', type=int, default=4, help='Maximum number of tokens per candidate (default 4).')
    p.add_argument('--allow-sep', action='store_true', help='Allow inserting separators between tokens (e.g. -, _, .).')
    p.add_argument('--allow-suffix', action='store_true', help='Allow appending random numeric suffixes (e.g. 123) or symbols.')
    p.add_argument('--seed', type=int, default=None, help='Random seed for reproducible output.')
    p.add_argument('--no-duplicates', action='store_true', help='Ensure generated candidates are unique (default behavior).')
    return p.parse_args()

SEPARATORS = ['', '-', '_', '.', '']  # empty meaning just concatenated with no separator
SUFFIXES = ['', '1', '123', '2025', '!', '@', '#', '99']

# Forbidden pair rule: never include both items in the same candidate (case-sensitive).
FORBIDDEN_PAIR = ('IIST', 'Institute')

def violates_forbidden(selected):
    a, b = FORBIDDEN_PAIR
    return (a in selected) and (b in selected)

def make_candidate(tokens, allow_sep, allow_suffix):
    # shuffle order
    tokens = list(tokens)
    random.shuffle(tokens)
    # choose separators between tokens
    out = []
    for i, t in enumerate(tokens):
        out.append(t)
        if i < len(tokens) - 1:
            sep = random.choice(SEPARATORS) if allow_sep else ''
            out.append(sep)
    candidate = ''.join(out)
    # optionally append a suffix
    if allow_suffix:
        candidate += random.choice(SUFFIXES)
    return candidate

def generate(words, count, min_w, max_w, allow_sep, allow_suffix, seed=None, no_dup=True):
    if seed is not None:
        random.seed(seed)
    words = list(words)
    if len(words) == 0:
        return []
    results = []
    seen = set()
    attempts = 0
    max_attempts = count * 50  # safety cap to avoid infinite loops
    while len(results) < count and attempts < max_attempts:
        attempts += 1
        k = random.randint(min_w, min(max_w, len(words)))
        selected = random.sample(words, k)
        if violates_forbidden(selected):
            continue
        cand = make_candidate(selected, allow_sep, allow_suffix)
        if no_dup:
            if cand in seen:
                continue
            seen.add(cand)
        results.append(cand)
    return results

def main():
    args = parse_args()
    # basic validation
    if args.min_words < 1:
        print("min-words must be >= 1", file=sys.stderr); sys.exit(1)
    if args.max_words < args.min_words:
        print("max-words must be >= min-words", file=sys.stderr); sys.exit(1)

    candidates = generate(
        words=args.words,
        count=args.count,
        min_w=args.min_words,
        max_w=args.max_words,
        allow_sep=args.allow_sep,
        allow_suffix=args.allow_suffix,
        seed=args.seed,
        no_dup=args.no_duplicates
    )

    for i, c in enumerate(candidates, 1):
        print(f"{i:03d}: {c}")

if __name__ == "__main__":
    main()
