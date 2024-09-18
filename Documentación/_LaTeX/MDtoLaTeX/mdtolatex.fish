#!/usr/bin/env fish

argparse -- $argv
if not test $argv[1]; return; end

set commondir "$argv[1]"
set filter "$argv[2]"

set dir "$commondir/MDtoLaTeX"
set documents (\
find "$dir/Documents" -mindepth 1 -maxdepth 1 -type f \
! -name ".*" -a \
-iname "*$filter*.md" \
| sort)

for doc in $documents
	prettier --parser markdown -w "$doc" > /dev/null
	pandoc "$doc" --to latex
end
