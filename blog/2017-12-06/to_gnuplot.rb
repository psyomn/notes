#!/usr/bin/env ruby

RbFilename = 'stlkr.rb.stats.txt'
CrFilename = 'stlkr.cr.stats.txt'

def ps_metrics_to_files(filename)
  data = File.read(filename)

  time = 0
  step = 5

  cpu_metric = []
  mem_metric = []
  vsz_metric = []
  rss_metric = []

  data.lines.each do |line|
    parts = line.split

    cpu_per = parts[2].to_f
    mem_per = parts[3].to_f
    vsz = parts[4].to_i
    rss = parts[5].to_i

    cpu_metric.push [time, cpu_per]
    mem_metric.push [time, mem_per]
    vsz_metric.push [time, vsz]
    rss_metric.push [time, rss]
    time += step
  end

  File.write(filename + '.cpu', to_gnuplot(cpu_metric))
  File.write(filename + '.mem', to_gnuplot(mem_metric))
  File.write(filename + '.vsz', to_gnuplot(vsz_metric))
  File.write(filename + '.rss', to_gnuplot(rss_metric))
end

def to_gnuplot(metric)
  # metric is [ [time int, value] | ... ]
  metric.map { |x,y| "#{x},#{y}" }.join($/)
end

ps_metrics_to_files(RbFilename)
ps_metrics_to_files(CrFilename)
