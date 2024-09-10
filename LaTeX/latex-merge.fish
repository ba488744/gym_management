set dir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/LaTeX"
set output "$dir/output"

cat "$dir/.resources/pre-common.tex" > "$output.tex"

#	echo '\tableofcontents' >> "$output.tex"
#	fish "$dir/MDtoLaTeX/mdtolatex.fish" >> "$output.tex"
	fish "$dir/GANTT/gantt.fish" >> "$output.tex"
#	fish "$dir/User Stories/user-stories.fish" >> "$output.tex"

cat "$dir/.resources/post-common.tex" >> "$output.tex"

prettier --plugin=/usr/local/lib/node_modules/prettier-plugin-latex/dist/prettier-plugin-latex.js "$output.tex" --write
lualatex --output-directory="$dir" "$output.tex"
qpdf --linearize --replace-input "$output.pdf"
