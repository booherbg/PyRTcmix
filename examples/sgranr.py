'''
gen 1
    fills a function table with samples from a sound file.

gen 2
    fills a function table with numbers specified in the script or in a text file.

gen 3
    fills a function table with numbers from a data file.

gen 4
    makes a function having any number of line segments, with adjustable curvature for each segment, and defined in terms of time,value pairs.

gen 5
    makes a function having any number of exponential line segments.

gen 6
    makes a function having any number of straight line segments, defined in terms of time,value pairs.

gen 7
    makes a function having any number of straight line segments.

gen 9
    makes a function having one cycle of an arbitrary waveform, defined by triplets of floating-point partial number, amplitude, and phase.

gen 10
    makes a function having one cycle of an arbitrary waveform, defined by harmonic partials and their relative strengths.

gen 17
    makes a transfer function using Chebyshev polynomials.

gen 18
    works like gen 6, except it never normalizes the table to fit between -1 and 1.

gen 20
    fills a function table with random numbers using several different distributions (even, low-weighted linear, triangle linear, gaussian, cauchy, etc.).

gen 24
    makes a function having any number of straight line segments, defined in terms of time,value pairs. (This is subtly different from gen 6, but it's not clear why anyone would care.)

gen 25
    makes a window function using several different common window types (hanning, hamming, etc.). 
    
SGRANR:
*  function slot 1 is amp envelop
*   slot 2 is waveform 
*   slot 3 is grain env

    '''


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
rrr.cmd("load", "SGRANR")
rrr.printOn()
print("timeit()")

rrr.cmd("makegen", 1, 7, 1000, 1, 950, 1, 50, 0)
rrr.cmd("makegen", 1, 5, 1000, 0.1, 50, 1, 50, .8, 600, .8, 300, 0.1)
rrr.cmd("makegen", 2, 10, 1000, 1)
rrr.cmd("makegen", 2, 7, 1000, 0, 1, 1, 498, 1, 1, 0, 1, -1, 498, -1, 1, 0)
rrr.cmd("makegen", 2, 9, 1000, 1, 1, 0, 2, .5, 90, 3.2, .3, 0)
rrr.cmd("makegen", 3, 7, 1000, 0, 500, 1, 500, 0)

rrr.cmd("fplot", 3)
#makegen(1, 7, 1000, 1, 950, 1, 50, 0)
#makegen(2, 10, 1000, 1)
#makegen(3, 7, 1000, 0, 500, 1, 500, 0)

start = 0.0

rrr.cmd("SGRANR", start, 3, 5000,
.1, .1, .1, .1, 1.0,
.1, .1, .1, 2,
0.0, .5, 1.0, 1.0,
800, 5000, 9700, 2,
1,1)

#rrr.cmd("SGRANR", start, 3, 5000,
#.1, .1, .1, .1, 1.0,
#.1, .1, .1, 2,
#0.0, .5, 1.0, 1.0,
#100, 200, 300, 2,
#1,1)


#SGRANR(start, 3, 5000, 
#/* grain rate, ratevar values (must be positive, 
#	% until next grain possible displacement): */
#.1, 0.1, 0.1, 0.1, 1.0,
#/* duration values: */
#.1,.1,.1,2, 
#/* location values: */
#0.0,.5,1.0,1.0, 
#/* pitch values: */
#800,1000,9700,2,
#/* granlyrs, seed */
#1,1)


while (True):
    sleep(.1)
