#!/usr/bin/env python3

import os
import shutil
import sys
from pathlib import Path


def rename_file(dest_dir: Path, filename: str) -> str:
    base, ext = os.path.splitext(filename)
    count = 1

    while (dest_dir / filename).exists():
        filename = f"{base}_{count}{ext}"
        count += 1

    return filename



args = sys.argv[1:]
max_depth = None

if "--max_depth" not in args:
    input_dir = Path(args[0])
    output_dir = Path(args[1])
else:
    max_depth = int(args[1])
    input_dir = Path(args[2])
    output_dir = Path(args[3])


output_dir.mkdir(parents=True, exist_ok=True)

for root, i, files in os.walk(input_dir):

    rel_path = os.path.relpath(root, input_dir)
    if rel_path != ".":
        depth = rel_path.count(os.sep) + 1
    else:
        depth = 0

    if max_depth is not None and depth >= max_depth:
        mas_rel_path = rel_path.split(os.sep)
        new_rel_path = output_dir
        for i in range(-max_depth + 1, 0):
            new_rel_path = new_rel_path / mas_rel_path[i]
    elif max_depth is None:
        new_rel_path = output_dir
    else :    
        new_rel_path = output_dir
        mas_rel_path = rel_path.split(os.sep)
        for i in range(0,len(mas_rel_path)):
            new_rel_path = new_rel_path / mas_rel_path[i]

    for file in files:
        src = Path(root) / file
        if max_depth is not None :
            new_rel_path.mkdir(parents=True, exist_ok=True)
        dest_name = rename_file(new_rel_path, file)
        shutil.copy2(src, new_rel_path / dest_name)

