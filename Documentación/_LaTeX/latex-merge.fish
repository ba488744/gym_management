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

function settype \
-d "Declara el tipo de documento y sus características generales."
	argparse 't/type=' 'l/lang=' 'p/pagesize=' 'm/margin=' \
	-- $argv; or return
	if [ "$_flag_type" ]; set type "$_flag_type"
	else; set type article; end
	if [ "$_flag_lang" ]; set lang "$_flag_lang"
	else; set lang spanish; end
	if [ "$_flag_pagesize" ]; set pagesize "$_flag_pagesize"
	else; set pagesize letterpaper; end
	if [ "$_flag_fontsize" ]; set fontsize "$_flag_fontsize"
	else; set fontsize 12pt; end
	if [ "$_flag_margin" ]; set margin "$_flag_margin"
	else; set margin 1in; end
	echo \
	"\documentclass[$lang, $fontsize]{$type}
	\usepackage[$pagesize, margin=$margin]{geometry}
	\usepackage[$lang]{babel}
	\usepackage{translator}"
end
function setformat \
-d "Declara el tipo de formato general usado por el documento."
	argparse 'a/align=' 's/stretch=' \
	-- $argv; or return
	if [ "$_flag_align" ]; set align "$_flag_align"
	else; set align justify; end
	if [ "$_flag_stretch" ]; set stretch "$_flag_stretch"
	else; set stretch 1.2; end
	echo \
	"\usepackage[$align]{ragged2e}
	\usepackage{setspace}
	\setstretch{$stretch}"
end
function setfont -a mainfont monofont \
-d "Declara el tipo de fuente."
	argparse 'mainfont=' 'monofont=' \
	-- $argv; or return
	if [ "$_flag_mainfont" ]; set mainfont "$_flag_mainfont"
	else; set mainfont "IBM Plex Sans"; end
	if [ "$_flag_monofont" ]; set monofont "$_flag_monofont"
	else; set monofont "IBM Plex Mono"; end
	echo \
	"\usepackage{fontspec}
	\defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}
	\setmainfont{"$mainfont"}
	\setmonofont{"$monofont"}"
end
function setall
	settype
	setformat
	setfont
end

###############################################################################

function escribir
	setall
	cat "$dir/.resources/pre-common.tex"
	echo "\begin{document}"
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
	echo "\end{document}"
end

escribir > "$output.tex"
prettier \
--plugin=/usr/local/lib/node_modules/prettier-plugin-latex/dist/prettier-plugin-latex.js \
--write "$output.tex"
lualatex --output-directory="$dir" "$output.tex"
qpdf --linearize --replace-input "$output.pdf"
