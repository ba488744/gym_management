#!/usr/bin/env fish

argparse -- $argv

set commondir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/Documentación/_LaTeX"
set dir "$commondir/MDtoLaTeX"
set documents (find "$dir/Documents" -mindepth 1 -maxdepth 1 -type f  \
! -name ".*" -a -iname "*$argv*.md" | sort)

for doc in $documents
	pandoc "$doc" --to latex
end
