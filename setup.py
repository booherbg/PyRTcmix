from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import os

# path to find include/ and lib/
if not (os.environ.has_key("RTCMIX_PATH")):
    ABSOLUTE_PATH_TO_RTCMIX = '/home/blaine/src/rtcmix/RTcmix-all-092811/'
else:
    ABSOLUTE_PATH_TO_RTCMIX = os.environ['RTCMIX_PATH']
    print "Found environment variable RTCMIX_PATH, using it: %s" % ABSOLUTE_PATH_TO_RTCMIX

print "#"*60
print "using the following path, please make sure it is correct!"
print "if not correct, please update ABSOLUTE_PATH_TO_RTCMIX in setup.py"
print ""
print "    path: %s" % (ABSOLUTE_PATH_TO_RTCMIX)
print ""
print "#"*60


#Boilerplate setup.py
# Call with python setup.py build_ext --inplace
# Also don't forget about python setup.py build_ext --embed
ext = Extension(
    "PyRTcmix",                 # name of extension
    ["PyRTcmix.pyx"],     # filename of our Cython source
    language="c++",              # this causes Cython to create C++ source
    include_dirs=['.', os.path.join(ABSOLUTE_PATH_TO_RTCMIX, "include/")],# usual stuff
    libraries=["stdc++"],             # ditto
    extra_link_args=["-lm","-lrtcmix", "-lgen", "-L%s" % os.path.join(ABSOLUTE_PATH_TO_RTCMIX, "lib/")],       # if needed
    )

setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules=[ext],
    name="PyRTcmix",
    version="0.1",
    description="python bindings for rtcmix so we can use rtcmix from vanilla python",
    author = "Blaine Booher",
    author_email = "bgbooher@gmail.com",
    long_description='''
    A cython module that lets us use rtcmix
    ''',
    classifiers=[], # Cheese Shop?
)
