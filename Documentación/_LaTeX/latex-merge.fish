set dir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/Documentación/_LaTeX/"
set output "$dir/Proyecto"

###############################################################################

function user-stories
	echo "\subsection{Vision Board}\label{vision-board}"
	fish "$dir/User Stories/user-stories.fish" "$dir" 2
end
function gantt -a titulo color filtro
	if not [ "$filtro" ]; set filtro "$titulo"; end
	echo "\subsection{$titulo}"
	fish "$dir/GANTT/gantt.fish" "$dir" "$color" "$filtro" 0.85
end
function gantt-all
	#echo '\begin{landscape}'
	echo "\section{Cronograma de actividades}\label{cronograma}"
	set colores 1 3 4 5 6 7 8 9 10 11 12; set n 1
	for grafica in \
	"1-[1-2]_Definición de proyecto y Marco Teórico"
		gantt \
		(echo "$grafica" | cut -d '_' -f 2) \
		"$colores[$n]" \
		(echo "$grafica" | cut -d '_' -f 1)
		set m (math $m + 1)
		set n (
		if test $n -eq (count $colores)
			echo 1
		else
			math $n + 1
		end)
	end
	#echo '\end{landscape}'
end

###############################################################################

function settype -a type lang fontsize margin
	if not [ "$type" ]; set type article; end
	if not [ "$lang" ]; set lang spanish; end
	if not [ "$fontsize" ]; set fontsize 12pt; end
	if not [ "$margin" ]; set margin 1in; end
	echo \
	"\documentclass[$lang, $fontsize]{$type}
	\usepackage[letterpaper, margin=$margin]{geometry}"
end

###############################################################################

function escribir
settype

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
prettier \
--plugin=/usr/local/lib/node_modules/prettier-plugin-latex/dist/prettier-plugin-latex.js \
--write "$output.tex"
lualatex --output-directory="$dir" "$output.tex"
qpdf --linearize --replace-input "$output.pdf"
