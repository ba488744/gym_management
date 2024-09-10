#!/usr/bin/env fish

set commondir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/Documentación/_LaTeX"
set dir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/Documentación/User Stories"
set stories (find "$dir/Stories" -mindepth 1 -maxdepth 1 -type f ! -name ".*" | sort)
set c 1

set pin Paperclip Pushpin Scotch None
set pinstyle 4
set columns 3
set deviation 3

if not test $stories[1]; return; end

set width (math "(1-((min($columns,"(count $stories)")-1)*0.004))/min($columns,"(count $stories)")")

function pre
	echo '
	\begin{landscape}'
end
function post
	echo '
	\end{landscape}'
end
function postitnotes
	for story in $stories
		echo '\noindent\begin{minipage}{'$width'\linewidth}
		\noindent\begin{PostItNote}[Width=0.9\linewidth,Corner=true,Pin='$pin[$pinstyle]',Color=html'$c',Rotate='(
		math (random choice (seq -(math $deviation'*10') (math $deviation'*10')))'/10')(
		if test (cat "$story" | grep '^#' | head -n 1)
			echo ',Title={'(cat "$story" | grep '^#' | head -n 1 | sed 's/^#//g')'},FontTitle={\bfseries\itshape}'
		else
			echo ""
		end)']'
		cat "$story" | grep -v '^#'
		echo '\end{PostItNote}
		\vspace{0.5cm}
		\end{minipage}'
		set c (
		if test $c -eq 12
			echo 1
		else
			math $c + 1
		end)
	end
end
function stories-format
	pre
	fish "$commondir/.resources/html-colors.fish" 7 html
	postitnotes
	post
end

stories-format
