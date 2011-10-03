import PyRTcmix as p
from time import sleep

rtsampes=8192
pitches = (6.05, 6.07, 6.10, 7.00, 7.02, 7.04,
            7.05, 7.07, 7.09, 8.00, 8.02, 8.05, 8.07, 8.10)
start,pch,pchindex,stereo=0.0,0.0,0,0.0

rrr = p.pyRTcmix()
#rrr.printOn()
sleep(3)

print ("loading strum...")
rrr.cmd("load", "GRANSYNTH")
print("timeit()")

dur = 30

amp = rrr.cmd("maketable", "line", 1000, 0,0, 1,1, 2,0.5, 3,1, 4,0)
wave = rrr.cmd("maketable", "wave", 2000, 1, .5, .3, .2, .1)
granenv = rrr.cmd("maketable", "window", 2000, "hanning")
hoptime = rrr.cmd("maketable", "line", "nonorm", 1000, 0,0.01, 1,0.002, 2,0.05)
hopjitter = 0.0001
mindur = .04
maxdur = .06
minamp = maxamp = 1
#pitch = rrr.cmd("maketable", "line", "nonorm", 1000, 0,6, 1,9)
#transpcoll = rrr.cmd("maketable", "literal", "nonorm", 0, 0, .02, .03, .05, .07, .10)

# maketable, line   gen 6 (normalize), 18 (nonorm), 24
rrr.cmd("makegen", 6, 1000,  0,0,  1,1,   2,0.5,  3,1,  4,0)

# maketable, wave   gen 10 (harmonics) gen 9 (inharmonic)
rrr.cmd("makegen", 10, 2000, 1, 0.5, 0.3, 0.2, 0.1)

# maketable, window gen 25 makegen(table_number, 25, table_size, window_type) 1 hanning 2 hamming
rrr.cmd("makegen", 25, 2000, 1)

# maketable, literal gen 18 (never normalizes)
rrr.cmd("makegen", 18, 1000,  0,0.01,   1.0, 0.002,   2, 0.05)

pitchjitter = 1

st=0
rrr.cmd("bus_config", "GRANSYNTH", "out 0")
#rrr.cmd("GRANSYNTH", st, dur, amp*5000, wave, granenv, hoptime, hopjitter,
#   mindur, maxdur, minamp, maxamp, pitch, transpcoll, pitchjitter)
   
rrr.cmd("GRANSYNTH", st, dur, amp, wave, granenv, hoptime, hopjitter,
   mindur, maxdur, minamp, maxamp, pitch, transpcoll, pitchjitter)


#rrr.cmd("bus_config", "GRANSYNTH", "out 1")
#st = st+0.14
#pitch = pitch+0.002
#rrr.cmd("GRANSYNTH", st, dur, amp*5000, wave, granenv, hoptime, hopjitter,
#   mindur, maxdur, minamp, maxamp, pitch, transpcoll, pitchjitter)
   
#for i in range(50):
#    pchindex = int(rrr.cmd("random") * 14.0)
#    pch = pitches[pchindex]
#    stereo = rrr.cmd("random")
#    rrr.cmd("START", start, 1.0, pch, 1.0, 0.1, 20000.0, 1.0, stereo, 1.0)
#    start += 0.1
#    sleep(0.01)
    
while (True):
    sleep(.1)
