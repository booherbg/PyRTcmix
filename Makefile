all: PyRTcmix.so

#PyRTcmix.so:
#	python setup.py build_ext
#	
#all: PyRTcmix.so


RTCMIX_ABSOLUTE_PATH=/home/blaine/Dropbox/src/Thesis/src/RTcmix/RTcmix-all-120110/

PyRTcmix.so: PyRTcmix.cpp
	mkdir -p build/temp.linux-x86_64-2.6/
	mkdir -p build/lib.linux-x86_64-2.6/
	gcc -pthread -fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fPIC -I. -I${RTCMIX_ABSOLUTE_PATH}/include/ -I/usr/include/python2.6 -c PyRTcmix.cpp -o build/temp.linux-x86_64-2.6/PyRTcmix.o
	g++ -pthread -shared -Wl,-O1 -Wl,-Bsymbolic-functions build/temp.linux-x86_64-2.6/PyRTcmix.o -lstdc++ -o build/lib.linux-x86_64-2.6/PyRTcmix.so -lm -lrtcmix -lgen -L${RTCMIX_ABSOLUTE_PATH}/lib/
	ln -s -f build/lib.linux-x86_64-2.6/PyRTcmix.so PyRTcmix.so
	
clean:
	rm PyRTcmix.so
	rm -rf build/
