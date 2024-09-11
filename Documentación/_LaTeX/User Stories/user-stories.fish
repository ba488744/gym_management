#!/usr/bin/env fish

argparse -- $argv
if not test $argv[1]; return; end

set commondir "$argv[1]"
set dir (dirname "$commondir")
set stories (find "$dir/User Stories" -mindepth 1 -maxdepth 1 -type f ! -name ".*" -a ! -name "*.fish" | sort)
set c $argv[2]
if not test $c; set c 1; end

set pin Paperclip Pushpin Scotch None
set pinstyle 4
set columns 2
set deviation 3

if not test "$stories[1]"; return; end

set width (math "(1-((min($columns,"(count $stories)")-1)*0.004))/min($columns,"(count $stories)")")

function postitnotes
	for story in $stories
		set rotation (math (random choice (seq -(math $deviation'*10') (math $deviation'*10')))'/10')
		echo "\noindent\begin{minipage}{$width\linewidth}
		\noindent\begin{PostItNote}[Width=0.9\linewidth,Corner=true,Pin=$pin[$pinstyle],Color=html$c,Rotate=$rotation" (
		if test (cat "$story" | grep '^#' | head -n 1)
			echo ',Title={'(cat "$story" | grep '^#' | head -n 1 | sed 's/^#//g')'},FontTitle={\bfseries\itshape}'
		else
			echo ""
		end) "]"
		if test (echo "$story" | rev | cut -d '.' -f 1 | rev) = md
			cat "$story" \
			| grep -v '^#' \
			| pandoc --from markdown --to latex
		else
			cat "$story" \
			| grep -v '^#'
		end
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
	fish "$commondir/.resources/html-colors.fish" 7 html
	postitnotes
end

stories-format
