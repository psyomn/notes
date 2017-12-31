#!/usr/bin/env bash

set -x

function plot() {
    gnuplot -e "name='$1';name2='$2';giventitle='$3';outputname='$4'" gnuplot-settings
}

# gnuplot -e "name='stlkr.cr.stats.txt.cpu';name2='stlkr.rb.stats.txt.cpu';giventitle='mytitlelol';outputname='cpu.png'" gnuplot-settings

plot stlkr.rb.stats.txt.cpu stlkr.cr.stats.txt.cpu cpu cpu.png
plot stlkr.rb.stats.txt.mem stlkr.cr.stats.txt.mem mem mem.png
plot stlkr.rb.stats.txt.rss stlkr.cr.stats.txt.rss rss rss.png
plot stlkr.rb.stats.txt.vsz stlkr.cr.stats.txt.vsz vsz vsz.png
