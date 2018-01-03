#!/usr/bin/env bash

set -x

function plot() {
    gnuplot -e "givenunit='$1';name='$2';name2='$3';giventitle='$4';outputname='$5'" gnuplot-settings
}

plot 'cpu%' stlkr.rb.stats.txt.cpu stlkr.cr.stats.txt.cpu cpu cpu.png
plot 'mem%' stlkr.rb.stats.txt.mem stlkr.cr.stats.txt.mem mem mem.png
plot 'rss kb' stlkr.rb.stats.txt.rss stlkr.cr.stats.txt.rss rss rss.png
plot 'vsz kb' stlkr.rb.stats.txt.vsz stlkr.cr.stats.txt.vsz vsz vsz.png
