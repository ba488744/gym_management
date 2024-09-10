#!/usr/bin/env fish

argparse -- $argv

set commondir "$HOME/Sync/UAEH/Asignaturas/Bases de datos distribuidas/gym_management/Documentación/_LaTeX/"
set dir "$commondir/GANTT"
set activities (find "$dir/Actividades" -mindepth 1 -maxdepth 1 -type f ! -name ".*" | sort)
set responsable \
"Aimar Jair" \
"Cristian" \
"Gerardo" \
"Magaly" \
"Monserrat" \
"Valentín"
set responsable_completo \
"Barón Salinas Mauricio Valentín" \
"Cristóbal Silverio Cristian" \
"Gómez Daniel Aimar Jair" \
"Hernández Reyes Magaly" \
"Sánchez Carrasco Monserrat" \
"Ramírez Suárez Gerardo"
set c $argv[1]
if not test $c; set c 2; end

set element group bar linkedbar milestone linkedmilestone
set barpattern \
"dots" "crosshatch dots" \
"horizontal lines" "vertical lines" "grid" \
"north west lines" "north east lines" "crosshatch" \
"bricks" "checkerboard" \
"fivepointed stars" "sixpointed stars"

if not test $activities[1]; return; end

function extractdays -a column file
	for date in (cat "$file" | grep -v '^[1,4,5]' | sed '/^$/d' | cut -d \t -f "$column")
		date -d "$date" +%Y%m%d
	end
end
function getfirstday -a file
	if test "$file"
		set dates (extractdays 2 "$file")
	else
		set dates (
		for file in $activities
			extractdays 2 "$file"
		end)
	end
	set date (math "min ($dates[1]" (for d in $dates[2..]; echo ", $d"; end) ")")
	date -d "$date" "+%F"
end
function getlastday -a file
	if test "$file"
		set dates (extractdays 3 "$file")
	else
		set dates (
		for file in $activities
			extractdays 3 "$file"
		end)
	end
	set date (math "max ($dates[1]" (for d in $dates[2..]; echo ", $d"; end) ")")
	date -d "$date" "+%F"
end

set begin_day (getfirstday)
set end_day (getlastday)

function pre
	echo '
	\begin{landscape}
	\scalebox{0.9}{
	%\begin{adjustbox}{max size={0.9999\textwidth}{0.9999\textheight}}'
	echo '
	\def\pgfcalendarweekdayletter#1{%
	\ifcase#1L\or M\or M\or J\or V\or S\or D\fi%
	}'
	echo "
	\begin{ganttchart}[
		x unit=0.5cm,
		y unit title=1cm,
		y unit chart=1.1cm,
		time slot format=big-endian,
		vgrid,
		hgrid,
		title label font=\footnotesize,
		progress label text={},
		newline shortcut=true,
		group label node/.append style={align=right},
		bar label node/.append style={align=right},
		milestone label node/.append style={align=right},
		canvas/.style={
			draw=black,
			dotted
		}
	]{$begin_day}{$end_day}"
	echo '
	\gantttitlecalendar{year, month=name, weekday=letter, day} \\\\'
end
function post
	echo "
	\end{ganttchart}
	%\end{adjustbox}
	}
	\end{landscape}"
end
function list-activities
	for file in $activities
		set bp 1
		echo \
		"\ganttset{
			bar/.append style={
				pattern color=html$c
			},
			group/.append style={
				draw=black,
				fill=html$c
			},
			milestone/.append style={
				fill=html$c
			},
		}"
		for act in (cat "$file" | sed '/^$/d')
			echo \
			"\ganttset{
				bar/.append style={
					pattern=$barpattern[$bp]
				},
			}"
			set n (echo $act | cut -d \t -f 1)
			echo "\gantt$element[$n]"(
			if test $n -eq 1 || test $n -eq 4 || test $n -eq 5
				echo '[progress='(
					set count 0
					math '(' (for p in (cat "$file" | sed '/^$/d' | grep -v '^[1,4,5]' | cut -d \t -f 4)
						echo $p +
						set count (math $count +1)
					end) '0)/'"$count"
				)']{'(
					echo $act | cut -d \t -f 2
					if test (echo $act | cut -d \t -f 3)
						echo a
					end
				)'}{'(
				if test $n -eq 1
					getfirstday "$file"
				else
					getlastday "$file"
				end)'}{'(
					getlastday "$file"
				)'}'
			else
				echo '[progress='(
					echo $act | cut -d \t -f 4
				)']{'(
					echo (echo $act | cut -d \t -f 5) (
					if test (echo $act | cut -d \t -f 6) && test $n -le 3
						echo '\ganttalignnewline \footnotesize{ \textit{ \textcolor{gray}{ Responsable(s): } ' (
						for resp in (echo $act | cut -d \t -f 6 | sed 's/,/\t/g' | sort | uniq)
							echo ', \textcolor{html'$c'}{ \textbf{ '$responsable[$resp]'}}'
						end | sed 's/^, //g') '}}'
					end
				))'}{'(
					echo $act | cut -d \t -f 2
				)'}{'(
					echo $act | cut -d \t -f 3
				)'}'
			end) \\\\
			if test $n -ge 2
				set bp (
				if test $bp -eq (count $barpattern)
					echo 1
				else
					math $bp + 1
				end)
			end
		end
		set c (
		if test $c -eq 12
			echo 1
		else
			math $c + 1
		end)
	end
	echo "\ganttset{
	,vrule offset ="(math (date "+%H")'/24')",}
	\ganttvrule{HOY}{\the\year-\the\month-\the\day}"
end
function gantt-format
	pre
	fish "$commondir/.resources/html-colors.fish" 0 html
	list-activities
	post
end

gantt-format
