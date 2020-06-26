# Sine module

import math
import random

# Generates array of 256 elements of values 0b0 - 0b11111111
# (Python omits zeroes so 0b00000001 = 0b1)
def make_input(n):
    
    input_array = [None] * n # Empty array of n elements
    for i in range(len(input_array)):
        input_array[i] = bin(round(random.random()*255))  # random.random() generates float between 0-1. Multiply by 255 and round to get range 0-255. bin converts to binar
    
    return input_array



def funct(x):
    
    x_int = int(x,2) # Convert element of input_array to integer from binary
    y = 100*math.sin((x_int-128)*(math.pi/32)) # do funct part
    
    return y



def convert_to_32b(y):
    
    integer = int(y) # Integer part of number only
    decimals = abs(float(y-int(y))) # Decimal part of number only
    
    # Empty string declerations
    bin_int = "" # binary of integer part only 
    bin_dec = "" # binary of decimal part only
    bin_32b = "" # binary of integer and decimal parts combined
    
    bin_int = bin(integer) # [2:] # [2:0] removes the "0b" from the string
    if (bin_int[0:1] == "-"):
        bin_int = bin_int[3:]
    else:
        bin_int = bin_int[2:]
    
    if (len(bin_int)<16):
        zeroes = (16 - len(bin_int)) * "0"
        bin_int = zeroes + bin_int # will fill up the spaces infront of the binary integer value with 0s to get 16 bits
    
    for k in range(16): # Way to calculate decimals in binary
         
        decimals = decimals *2
        
        if (int(decimals >= 1)):
            bin_dec += "1"
            decimals = float(decimals-int(decimals))
        else:
            bin_dec += "0"
     
    if (integer <1):
        bin_32b = "-" + bin_int + "." + bin_dec # Concatination of negative binary integer and binary decimal parts
    else:
        bin_32b = bin_int + "." + bin_dec # Concatination of positive binary integer and binary decimal parts
    
    return bin_32b
            

