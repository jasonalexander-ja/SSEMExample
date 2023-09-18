# Example Manchester SSEM "Baby" Programs 

This contains example programs designed for use with the [ssemu](https://github.com/jasonalexander-ja/ssemu)
emulator of the Manchester Baby computer. 

## Installation

Ensure you have the emnulator installed via 
```
cargo install ssemu
```

Clone this repository with: 
```
git clone https://github.com/jasonalexander-ja/SSEMExample
``` 

## Running 

The example can be ran via:

```
ssemu run main.asm --exe-from asm --output-model
```

This will run the example through to completion, outputting the final state 
of the whole system:

```
Accumulator: 0xffffffff; Instruction Register: 0xe000 (stop instruction - 16391);
Instruction Address: 0x0004; Main Store:
0x00: 0x00004007; 0x01: 0x00002006; 0x02: 0x00006000; 0x03: 0x00000005;
0x04: 0x0000e000; 0x05: 0x00000001; 0x06: 0x00000001; 0x07: 0xfffffff6;
0x08: 0x00000000; 0x09: 0x00000000; 0x0a: 0x00000000; 0x0b: 0x00000000;
0x0c: 0x00000000; 0x0d: 0x00000000; 0x0e: 0x00000000; 0x0f: 0x00000000;
0x10: 0x00000000; 0x11: 0x00000000; 0x12: 0x00000000; 0x13: 0x00000000;
0x14: 0x00000000; 0x15: 0x00000000; 0x16: 0x00000000; 0x17: 0x00000000;
0x18: 0x00000000; 0x19: 0x00000000; 0x1a: 0x00000000; 0x1b: 0x00000000;
0x1c: 0x00000000; 0x1d: 0x00000000; 0x1e: 0x00000000; 0x1f: 0x00000000; 
End. 
```

## Breakdown 

To break down this example, this program loads and negates a value (-10) from 
memory into the accumulator, subtracts 1 from it, and jumps back to 
subtracting one if the accumulator is not negative, and when the accumulator 
becomes negative, halts. 

Basically, it counts back from 10, using the limmited instructions 
available to the Baby (it was only ever intended as a demonstrator,
but since we're crazy, we'd thought we would create a toolchain for it). 

### Line by line

The full program is this:

```asm
ldn $start_value  ; Loads 10 into the accumulator 

:loop_start_value ; The memory address the loop should return to 
sub $subtract_val ; Subtract 1 from the accumulator 
cmp               ; Skip the next jump instruction if the accumulator is negative 
jmp $loop_start   ; Jump to the start of the loop 
stp               ; Program stops when the accumulator is negative 

:loop_start       ; Pointer to the memory address the loop should return to 
abs $loop_start_value

:subtract_val     ; Value to be subtracted
abs 0d1

:start_value      ; Value to start in the accumulator 
abs 0d-10
```

Line by line this is: 

#### Line 1
```asm
ldn $start_value  ; Loads 10 into the accumulator 
```
This negatively loads the value underneath the tag named 
`start_value`  into the accumulator, which if we check at 
the bottom of the program: 

```asm
:start_value    ; Value to start in the accumulator 
abs 0d-10
```
We can see, is -10, so it loads a 10 into the accumulator. 

#### Line 2
```asm
sub $subtract_val    ; Subtract 1 from the accumulator 
```
This subtracts the value underneath the tag named 
`subtract_val` from the accumulator, which if we check 
towards the bottom of the program:

```asm
:subtract_val    ; Value to be subtracted
abs 0d1
```
We can see it's 1. 

#### Lines 3 & 4
```asm
cmp    ; Skip the next jump instruction if the accumulator is negative 
```
This checks if the accumulator is negative, if so, it will skip 
the next instruction which if we check the next line we can see
this is:

```asm
jmp $loop_start    ; Jump to the start of the loop 
```
This will jump and continue executing the instructions 
at the address underneath the tag named `loop_start`,
which if we check at the bottom of the program:

```asm
:loop_start    ; Pointer to the memory address the loop should return to 
abs $loop_start_value
```
We can see, that it's set to the value of `loop_start_value`,
if we look at the top of the program again: 

```
:loop_start_value ; The memory address the loop should return to 
sub $subtract_val ; Subtract 1 from the accumulator 
```
We can see that it's the address of the subtract instruction. 

So basically, if the accumulator is not negative, 
it will jump back to the subtract instruction in a loop. 

Confusing right? 

There is some logic to this, all operands to instructions 
in the Baby's ISA are accepted via indirection, meaning that 
you must specify the memory address where the computer will 
find the operand, and since tags act as aliases in our 
assembly for memory addresses in the program we can use them 
to make our program more readable. 

#### Line 5 
```asm
stp    ; Program stops when the accumulator is negative 
```
This stops the computer, and in our case, will exit the emulator
program, outputting the final state of the computer (since we 
have the `--output-model`) flag set. 

Since this is 
immediately after the jump instruction, this will be hit 
when the accumulator is negative. 


## Debug 

You can run a debug session by running the same command 
again and setting the `--break-addr` flag, this sets a 
breakpoint when a specific memory addrress it hit:

```
ssemu run main.asm --exe-from asm --output-model --break-addr 0
```

Passing 0 will cause a debug session to happen immediately. 

```
Debug
Accumulator: 0x00000000; Instruction Register: 0x4007 (negate instruction - -10);
Instruction Address: 0x0000; Main Store: 
0x00: 0x00004007; 0x01: 0x00002006; 0x02: 0x00006000; 0x03: 0x00000005; 
0x04: 0x0000e000; 0x05: 0x00000001; 0x06: 0x00000001; 0x07: 0xfffffff6; 
0x08: 0x00000000; 0x09: 0x00000000; 0x0a: 0x00000000; 0x0b: 0x00000000; 
0x0c: 0x00000000; 0x0d: 0x00000000; 0x0e: 0x00000000; 0x0f: 0x00000000; 
0x10: 0x00000000; 0x11: 0x00000000; 0x12: 0x00000000; 0x13: 0x00000000; 
0x14: 0x00000000; 0x15: 0x00000000; 0x16: 0x00000000; 0x17: 0x00000000; 
0x18: 0x00000000; 0x19: 0x00000000; 0x1a: 0x00000000; 0x1b: 0x00000000; 
0x1c: 0x00000000; 0x1d: 0x00000000; 0x1e: 0x00000000; 0x1f: 0x00000000; 
(ssemu-debug) 
```

From the `(ssemu-debug)` prompt you can use `help` for a list of commands. Here are a few 
basic commands. 

* To continue execution use `continue` or `c`.
* To end execution use `end` or `e`.
* To execute the next instruction use `next` or `n`.

You also have `print` (`p`) and `set` (`s`) commands, these 
can show any part of the emulation's state or configuration. 

For instance to set or print a register you can use:

```
(ssemu-debug) set reg accumulator 10
(ssemu-debug) print reg accumulator  
0x0000000a   
```

For a memory address you can use: 
```
(ssemu-debug) set mem 10 2
(ssemu-debug) print mem 10
0x06: 0x00000002
```

In the above example program, it subtracts the memory address `6`
from the accumulator, have a go at setting this to some other value 
and see how that changes the program. 
