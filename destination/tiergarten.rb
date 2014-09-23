define :csample do |name|
  root = "/Users/josephwilk/Dropbox/repl-electric/samples/pi"
  "#{root}/#{name}"
end

s = csample "155837__corsica-s__halixic.wav"
s_dur = sample_duration(s)

t = csample "82365__timbre__clacker-rhythm.wav"
t_dur = sample_duration(t)

z = csample "49685__ejfortin__nano-blade-loop.wav"
j = csample "34786__stantones__crunchy-beat.aif"
j_dur = sample_duration(j)

g = csample "249181__gis-sweden__120bpm2smagnhildhh.wav"
a = csample "249182__gis-sweden__120bpm2smagnhildbd.wav"
b = csample "249185__gis-sweden__120bpmabramis4s-g.wav"
c = csample "96343__noisecollector__whisperloop.wav"
e = csample "202225__luckylittleraven__hypnoticsynth.wav"
f = csample "24088__lg__feedback21.wav"

g = csample "249174__gis-sweden__120bpmacantholabrus4s-g.wav"
h = csample "249175__gis-sweden__120bpmacantholabrus6s-g.wav"
i = csample "249173__gis-sweden__120bpmacantholabrus6s-a.wav"
k = csample "249176__gis-sweden__120bpmacantholabrus6s-d.wav"

#Beautiful
ethereal_femininity_s = csample "ethereal_femininity.wav"

define :highlights do
  sample [g, h, i, k].choose, rate: [1/2, 1/4, 1/8].choose
  sample s, rate: 0.2
  sample s

  if dice(6) > 3
    with_fx :slicer  do
      options = [2.0, 1.0 -2.0, -1.0]
      sample s, rate: options.choose
      sleep 1
      sample s, rate: options.choose
      sleep 0.5
      sample s, rate: options.choose
      sleep 0.5
      sample s, rate: options.choose
      sleep 1
    end
    sleep s_dur-2-1
  else
    sleep s_dur
  end

end

define :back do
  sample s, rate: 1
  with_fx :reverb, room: 0.5  do
    sample s, rate: 0.5
  end
  with_fx :echo, mix: lambda{rrand(0, 1)} do
    sample s, rate: 1.01, amp: 0.5
    sleep s_dur
  end
end

define :drums do
  sample :drum_snare_soft, rate: 0.4
  sleep j_dur/2
end

define :d2 do
  # default tempo is 60 bpm
  tempo = [60, 120, 240].choose
  with_bpm tempo do
    sample :drum_heavy_kick, rate: 0.8
    sleep j_dur/4
    with_fx :rlpf do
      sample j, pan: lambda{rrand(-1,1)}
    end
  end
end

define :d3 do
  sleep s_dur*3
  sample :ambi_choir, rate: 0.2, amp: 0.2
end

define :zoo do
  with_fx :reverb do
    sample z; sleep s_dur*4
  end
end

define :techo do
  with_fx :ixi_techno do
    sample t
    sleep t_dur
  end
end

define :echoer do
  rate = [1, -1].choose
  if dice(6) > 4
    sample e, rate: rate
    sleep sample_duration e
  end
end

define :highlights2 do
  rate = [0.7, -0.7].choose
  sample c, amp: 1, rate: rate
  sleep t_dur
end

define :highlights3 do
  with_fx :pan, pan: lambda{rrand(-1,1)}  do
    with_fx :echo do
      with_fx :reverb, mix: 0.9 do
        sample ethereal_femininity_s, amp: 0.9, rate: choose([1, 1/2, 1/4, 1/8])
      end
    end
  end

  sleep t_dur
end

in_thread(name: :a1) { loop {d3} }
in_thread(name: :b1) { loop {d2} }
in_thread(name: :c1) { loop {drums} }
in_thread(name: :d1) { loop {techo} }
in_thread(name: :e1) { loop {zoo} }
in_thread(name: :f1) { loop {highlights} }
in_thread(name: :g1) { loop {back} }
in_thread(name: :i1) { loop {echoer} }
in_thread(name: :j1) { loop {highlights2} }
in_thread(name: :k1) { loop {highlights3}}