import PyRTcmix as p
from time import sleep
from random import Random

rtsampes=8192

rrr = p.pyRTcmix()
rrr.printOn()
sleep(3)

print ("loading metaflute...")
rrr.cmd("load", "METAFLUTE")
sleep(3)
rrr.cmd("makegen", 1, 24, 1000, 0.0, 1.0, 1.0, 1.0)
rrr.cmd("makegen", 2, 24, 1000, 0.0, 0.0, 0.05, 1.0, 0.95, 1.0, 1.0, 1.0)
rrr.cmd("SFLUTE", 0.0, 1.0, 0.1, 106.0, 25.0, 5000.0, 0.5)
rrr.cmd("SFLUTE", 1.0, 1.0, 0.1, 95.0, 21.0, 5000.0, 0.5)
rrr.cmd("SFLUTE", 2.0, 1.0, 0.1, 89.0, 19.0, 5000.0, 0.5)
rrr.cmd("SFLUTE", 3.0, 1.0, 0.1, 75.0, 19.0, 5000.0, 0.5)
rrr.cmd("SFLUTE", 4.0, 1.0, 0.1, 70.0, 15.0, 5000.0, 0.5)
rrr.cmd("SFLUTE", 5.0, 1.0, 0.1, 67.0, 16.0, 5000.0, 0.5)
rrr.cmd("SFLUTE", 6.0, 1.0, 0.1, 56.0, 17.0, 5000.0, 0.5)
rrr.cmd("SFLUTE", 7.0, 1.0, 0.1, 53.0, 25.0, 5000.0, 0.5)

while(True):
    sleep(0.1)
