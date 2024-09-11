set dir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/Documentación/_LaTeX/"
set output "$dir/output"

cat "$dir/.resources/pre-common.tex" > "$output.tex"

	cat "$dir/Documentos LaTeX/0. Portada.tex" >> "$output.tex"

	echo '\tableofcontents' >> "$output.tex"

	fish "$dir/MDtoLaTeX/mdtolatex.fish" "$dir" >> "$output.tex"
#	fish "$dir/GANTT/gantt.fish" "$dir" 2 >> "$output.tex"
#	fish "$dir/User Stories/user-stories.fish" "$dir" 2 >> "$output.tex"

cat "$dir/.resources/post-common.tex" >> "$output.tex"

prettier --plugin=/usr/local/lib/node_modules/prettier-plugin-latex/dist/prettier-plugin-latex.js "$output.tex" --write
lualatex --output-directory="$dir" "$output.tex"
qpdf --linearize --replace-input "$output.pdf"
