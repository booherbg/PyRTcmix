cdef extern from "RTcmix.h":
    cdef cppclass Instrument:
        pass
    cdef cppclass PFieldSet:
        pass
    cdef cppclass RTcmix:
#        unsigned int p_rule,p_seedIsRandom,p_seedStartingPosition,p_generationLength
#        int _overallIndex
        RTcmix()                # 44.1k/stereo default
        RTcmix(float, int)        # set SR and NCHANS
        # not a fan of const
        RTcmix(float, int, int)#, char*, char*, char*)   # set SR, NCHANS, BUFSIZE, up to 3 options

        Instrument* cmd(char*, int, double, ...) # for numeric params
        Instrument* cmd(char*, int, char*, ...) # for string params
        Instrument* cmd(char*, PFieldSet &) #/ for PFieldSet
    
        double cmd(char*) # for commands with no params
#        double cmdval(char*, int, double, ...) # value return (numeric params)
#        double cmdval(char*, int, char*, ...) # value return (string params)
    
        void printOn()
        void printOff()
        void panic()
        void close()
#        virtual void run();    

# Here, define what you want to use in the Python Class
# REMEMBER! This isn't python - this is C++!
cdef class pyRTcmix:
    '''
    The goal of this class is to expose the c++ library.  It is NOT, I repeat, NOT 
    meant to add new functionality.  If Automata:: needs new functions, freakin' put 
    it in the c++ class! :) -BB
    
    In order for this class to be able to say:
        self.p_rule = self.thisptr.p_rule
    define self.p_rule here with a cdef public / readonly statement. readonly means
    that outside *this* object, nothing can modify the variable
    '''
    cdef RTcmix *thisptr
    def __cinit__(self, *args):
        '''
            Constructor
            Creates a pointer to the C++ object at self.thisptr
            
            We can't overload the python function __cinit__ so we use variable **kwds
        '''
        self.thisptr = new RTcmix(44100.0, 2, 256)
    def printOn(self):
        self.thisptr.printOn()
    def printOff(self):
        self.thisptr.printOff()
    def __dealloc__(self):
        '''
            c++ destructor.  Delete the automata and any other memory objects
            that may be floating around
        '''
        del self.thisptr
    def cmd(self, scmd, *args):
        '''
        The big boy.
        
        params can either be all doubles or all char*.
        '''
        #print len(args)
        #print args
        n = len(args)
        # a bit of a hack for now...?
        if n == 0:
            return <double>self.thisptr.cmd(scmd)
#        if args[0].lower() == "maketable":
#            # maketable... oh yeah.
#            # There will be two string parameters arg[0] and arg[1]
#            # Then there could either be zero one OR two string params arg[2] and arg[3]]
#            # and then there is an integer, followed by doubles
#            #rrr.cmd("maketable", "line", "nonorm", 1000,  0,6,   1,9)
#            p1 = args[0]
#            p2 = args[1]
#            p3 = args[2]
#            if n == 1:
#                print "Need more parameters for maketable"
#            elif n == 2:
#                print "Need more parameters > 2 for maketable"
#            elif n == 3:
#                print "Need more parameters > 3 for maketable"
#            elif type(args[2]) == type(0):
#                # skipped optional sets
#                self.thisptr.cmd(<char *>scmd, n, <char *>args[0], <char *>args[1], <double>args[2],
#                <double>args[3], <double>args[4], <double>args[5], <double>args[6], <double>args[7], 
#                <double>args[8], <double>args[9], <double>args[10], <double>args[7],<double>args[8])
#            
            
            
            
            
        if type(args[0]) == type(""):
            # String Arguments
            if n == 1:
                self.thisptr.cmd(<char *>scmd, n, <char *>args[0])
                return 
            if args[0] == "bus_config":
                print "bus_config called"
                if n == 3:
                    self.thisptr.cmd(<char *>scmd, n, <char *>args[0], <char *>args[1], <char *>args[2])
                else:
                    print "bus_config invalid parameters for n != 3"
            else:
                print "Sorry, multi-string params not supported (yet)"
                
#            elif type(args[1]) == type("") and type(args[2]) == type("") and type(args[3]) == type("") and type(args[4]) == type(0):
#                # First is string, second is string, third is string
#                #rrr.cmd("maketable", "line", "nonorm", 1000,  0,6,   1,9)
#                if n == 4:
#                    self.thisptr.cmd(<char *>scmd, n, <char *>args[0], <char *>args[1], 
#                    <int>args[2], <int>args[3])
#                elif n==6:
#                    self.thisptr.cmd(<char *>scmd, n, <char *>args[0], <char *>args[1], 
#                    <int>args[2], <int>args[3], <int>args[4], <int>args[5])
#                elif n==8:
#                    self.thisptr.cmd(<char *>scmd, n, <char *>args[0], <char *>args[1], 
#                    <int>args[2], <int>args[3], <int>args[4], <int>args[5], <int>args[6],
#                    <int>args[7])
#                else:
#                    print "string aruments with 3 and n>8 not supported"
#            elif type(args[1] == type("") and type(args[2]) == type("") and type(args[3]) == type(0):
#                # First is string, second is string, third is integer
#                
#                 rrr.cmd("maketable", "wave", 2000,     1,    .5,.3, .2,.1)
#            else:
#                print "string arguments with n>1 not supported"
        else:
            # Double Arguments
            if n == 1:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0])
            elif n == 2:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1])
            elif n == 3:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2])
            elif n == 4:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3])
            elif n == 5:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4])
            elif n == 6:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5])
            elif n == 7:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6])
            elif n == 8:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7])
            elif n == 9:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8])
            elif n == 10:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9])
            elif n == 11:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10])
            elif n == 12:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11])
            elif n == 13:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12])
            elif n == 14:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13])
            elif n == 15:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14])
            elif n == 16:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14],
                                 <double>args[15])
            elif n == 17:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14],
                                 <double>args[15],<double>args[16])
            elif n == 18:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14],
                                 <double>args[15],<double>args[16],<double>args[17])
            elif n == 19:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14],
                                 <double>args[15],<double>args[16],<double>args[17],<double>args[18])
            elif n == 20:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14],
                                 <double>args[15],<double>args[16],<double>args[17],<double>args[18],
                                 <double>args[19])
            elif n == 21:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14],
                                 <double>args[15],<double>args[16],<double>args[17],<double>args[18],
                                 <double>args[19],<double>args[20])
            elif n == 22:
                self.thisptr.cmd(<char *>scmd, n, <double>args[0], <double>args[1], <double>args[2], 
                                 <double>args[3], <double>args[4], <double>args[5], <double>args[6], 
                                 <double>args[7], <double>args[8], <double>args[9], <double>args[10],
                                 <double>args[11],<double>args[12],<double>args[13],<double>args[14],
                                 <double>args[15],<double>args[16],<double>args[17],<double>args[18],
                                 <double>args[19],<double>args[20],<double>args[21])
            else:
                print "sorry, cmd() with more than `%d` arguments not supported" % (n,)
        
        

#    def iterateAutomata(self):
#        '''
#            Execute a single iteration of the cellular automata.  Creates a new
#            current "generation".
#        '''
#        #self._overallIndex += 1
#        self.thisptr.iterateAutomata()
#        self._overallIndex = self.thisptr._overallIndex
#        
#    def printBuffer(self):
#        '''    
#            Prints the "buffer".  The buffer is basically the history of all
#            generations thus far computed, with a maximum of <kAutomataGenerations>
#            in Automata.h
#        '''
#        self.thisptr.printBuffer()
#        
#    def fillBuffer(self):
#        '''
#            Executes iterateAutomata() <kAutomataGenerations> times.  If the number
#            of generations is > kAutomataGenerations, I believe the buffer pointer
#            is reset back into the beginning of the buffer (and execution is skipped).
#        '''
#        self.thisptr.fillBuffer()
#        self._overallIndex = self.thisptr._overallIndex
#        
#    def currentGenerationIndex(self):
#        '''
#            Returns the integer of the current generation index.
#            Will be 0 < index < kAutomataGenerations
#        '''
#        return self.thisptr.currentGenerationIndex()
#    
#    def __repr__(self):
#        '''
#            Python Display Functin
#        '''
#            
#        self.thisptr.printBuffer()
#        return ''
#    
#    def bStringFromCurrentGeneration(self):
#        '''
#            Returns the string representation of the binary values of the current
#            generation.  Basically each 0 is converted to an ascii '0', and each 
#            binary 1 is converted to an ascii '1'.  Could be used, for example, 
#            to dump ascii binary data to stdout for processing
#        
#            a good "last resort", guaranteed way of accessing computed data
#        '''
#        cdef string str1 = self.thisptr.bStringFromCurrentGeneration()
#        #print str[0]
#        cdef char *cstr = <char*>malloc(str1.size() + 1)
#        strcpy(cstr, str1.c_str())
#        s = str(cstr)
#        free(cstr)
#        # I feel unsafe simply returning a malloc'd cstr, so copy to str
#        #    and free it up.  kind of redundant, oh well. Let python handle
#        #    the garbage collection and let me handle explicitely "free"ing the
#        #    sucker.
#        return s
#    
#    def stringFromCurrentGeneration(self):
#        '''
#            Returns the string representation of the current generation, with the 
#            characters defined in Automata.h
#        '''
#        cdef string str1 = self.thisptr.stringFromCurrentGeneration()
#        cdef char *cstr = <char*>malloc(str1.size() + 1)
#        strcpy(cstr, str1.c_str())
#        s = str(cstr)
#        free(cstr)
#        return s
#    
#    def chunks_FromCurrentGeneration(self,unsigned int bits=8):
#        '''
#            Returns the unsigned byte representation of the current generation
#        '''
#        cdef unsigned long *c
#        cdef unsigned int n
#        c = self.thisptr.chunks_FromCurrentGeneration(n,bits)
#        
#        # Convert to list
#        l=[]
#        #a=PyLong_FromUnsignedLong(c[0]))
#        for i in range(n):
#            l.append(long(c[i]))
#        free(c)
#        return l
