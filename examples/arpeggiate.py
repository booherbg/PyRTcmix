import PyRTcmix as p
from time import sleep

rtsampes=8192
pitches = (6.05, 6.07, 6.10, 7.00, 7.02, 7.04,
            7.05, 7.07, 7.09, 8.00, 8.02, 8.05, 8.07, 8.10)
start,pch,pchindex,stereo=0.0,0.0,0,0.0

rrr = p.pyRTcmix()
rrr.printOn()
sleep(3)

print ("loading strum...")
rrr.cmd("load", "STRUM")
print("timeit()")


for i in range(50):
    pchindex = int(rrr.cmd("random") * 14.0)
    pch = pitches[pchindex]
    stereo = rrr.cmd("random")
    rrr.cmd("START", start, 1.0, pch, 1.0, 0.1, 20000.0, 1.0, stereo, 1.0)
    start += 0.1
    sleep(0.01)
    
while (True):
    sleep(.1)
