set dir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/Documentación/_LaTeX/"
set output "$dir/output"

function user-stories
	echo "\subsection{Vision Board}\label{vision-board}"
	fish "$dir/User Stories/user-stories.fish" "$dir" 2
end
function gantt -a titulo
	echo "\subsection{$titulo}"
	fish "$dir/GANTT/gantt.fish" "$dir" 2 "$titulo"
end
function gantt-all
	echo '\begin{landscape}'
	echo "\section{Cronograma de actividades}\label{cronograma}"
	gantt "Análisis"
	echo '\end{landscape}'
end

function escribir
cat "$dir/.resources/pre-common.tex"
# Portada
	cat "$dir/Documentos LaTeX/0. Portada.tex"
# Tabla de contenidos
	echo '\tableofcontents'
# MD
	fish "$dir/MDtoLaTeX/mdtolatex.fish" "$dir"
# User Stories
	user-stories
# GANTT
	gantt-all

cat "$dir/.resources/post-common.tex"
end

escribir > "$output.tex"
prettier --plugin=/usr/local/lib/node_modules/prettier-plugin-latex/dist/prettier-plugin-latex.js "$output.tex" --write
lualatex --output-directory="$dir" "$output.tex"
qpdf --linearize --replace-input "$output.pdf"
