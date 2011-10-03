import PyRTcmix as p
import time
import random

rrr = p.pyRTcmix()
rrr.printOn()
time.sleep(3)
rrr.cmd("load", "STRUM")

for i in range(10):
   random.random()
   rrr.cmd("START", 0,1,7.1,1.0,0.1,20000.0,1.0,.5)
   time.sleep(.5)
