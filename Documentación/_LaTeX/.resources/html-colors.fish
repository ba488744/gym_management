#!/usr/bin/env fish

argparse -- $argv

set saturation "$argv[1]"; set prefix "$argv[2]"

set ss (echo "$saturation" | rev | cut -c 1 | tr a-z A-Z); set ss $ss$ss
set htmlpat "FF" "$ss"
set htmlcolors (
for c1 in $htmlpat; for c2 in $htmlpat; for c3 in $htmlpat
	echo $c1$c2$c3 | grep -Ev '(.)(.*\1){5}'
end; end; end)
set mid (math -b hex "($saturation+0xF)/2" | rev | cut -c 1 | tr a-z A-Z)
set htmlpat "FF" "$mid$mid" "$ss"
set htmlcolors $htmlcolors (
for c1 in $htmlpat; for c2 in $htmlpat; for c3 in $htmlpat
	echo $c1$c2$c3 | grep -Ev '(.)(.*\1){3}'
end; end; end)
set n 1
for htmlcolor in $htmlcolors
	echo '\definecolor{'"$prefix$n"'}{HTML}{'$htmlcolor'}'
	set n (math $n+1)
end
