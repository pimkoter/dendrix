#!/usr/bin/env python3

import os
import subprocess

home = os.path.expanduser("~")

for root, dirs, _ in os.walk(home):
    # Skip directories we don't want to traverse
    dirs[:] = [d for d in dirs if d not in {".cache", ".local/share/Trash"}]

    subprocess.run(
        ["zoxide", "add", root],
        check=False,
    )
