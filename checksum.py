# Checksum module

import functions
from tictocgenerator import tic, toc
import time

# Declare variables
x = functions.make_input(1000) # Create input array of n bytes
checksum = 0
# wrap_around = 0 # To see if wrap around occurs
 
tic() 
for i in range(len(x)):
    x[i] = functions.funct(x[i]) # Array of input bytes in integer form after sine function
toc()
    
for j in range(len(x)):
    if (checksum < 2**16): # Overflow condition
        checksum += x[j]
    else:
        # wrap_around += 1
        checksum = checksum - 2*16 
        checksum += x[j]
        
print(checksum) # Base 10 value of checksum
print (functions.convert_to_32b(checksum)) # Base 2 value of checksum in 32bit format
# print(wrap_around) # to see if wrap around had occured
#toc()