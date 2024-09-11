#!/usr/bin/env fish

argparse -- $argv
if not test $argv[1]; return; end

set commondir $argv[1]

set dir "$commondir/MDtoLaTeX"
set documents (find "$dir/Documents" -mindepth 1 -maxdepth 1 -type f  \
! -name ".*" -a -iname "*$argv[2]*.md" | sort)

for doc in $documents
	pandoc "$doc" --to latex
end
