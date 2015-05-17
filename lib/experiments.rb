def chord_seq(*args)
  args.each_slice(2).reduce([]){|acc, notes| acc += chord(notes[0],notes[1])}
end
module Ambi
 def self.[](a)
  samples = Dir["/Users/josephwilk/Workspace/music/samples/AmbientElectronica_Main_SP/**/*.wav"]
  samples.select{|s| s=~ /#{a}/}[0]
 end
end
module Chill
 def self.[](a)
  samples = Dir["/Users/josephwilk/Workspace/music/samples/Sample\ Magic\ -\ Ambient\ and\ Chill\ -\ Wav/**/*.wav"]
  samples.select{|s| s=~ /#{a}/}[0]
 end
end
def deg_seq(*pattern_and_roots)
  pattern_and_roots = pattern_and_roots.reduce([]){|accu, id|
    if(/^[\d_]+$/ =~ accu[-1] && /^[\d_]+$/ =~ id)
      accu[0..-2] << "#{accu[-1]}#{id}"
    else
      accu << id
  end}
  patterns = pattern_and_roots.select{|a| /^[\d_]+$/ =~ a.to_s }
  roots   = pattern_and_roots.select{|a| /^[\d_]+$/ !~ a.to_s}
  notes = patterns.each_with_index.map do |pattern, idx|
    root = roots[idx]
    if(root[0] == ":")
      root = root[1..-1]
    end
    s = /[[:upper:]]/.match(root.to_s[0]) ? :major : :minor
    if(s == :minor)
      s = if    root.to_s[1] == "h"
        :harmonic_minor
      elsif root.to_s[1] == "m"
        :melodic_minor
      else :minor
      end
    end
    root = root[0] + root[2..-1] if root.length > 2
    pattern.to_s.split("").map{|d| d == "_" ? nil : degree(d.to_i, root, s)}
  end.flat_map{|x| x}
  (ring *notes)
end
def bowed_s(name, *args)
  s = Dir["/Users/josephwilk/Dropbox/repl-electric/samples/Bowed\ Notes/*_BowedGuitarNote_01_SP.wav"]
  s.sort!
  sample (if name.is_a? Integer
    s[name]
  else
  s.select{|s| s =~ /#{name}/}[0]
  end), *args
end
def live(name, opts={}, &block)
  idx = 0
  amp = if(opts[:amp])
    opts[:amp]
  else
    1
  end
  x = lambda{|idx|
    with_fx :level, amp: amp do
      block.(idx)
  end}
  live_loop name do |idx|
    x.(idx)
  end
end