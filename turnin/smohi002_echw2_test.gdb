# Test file for "EC2_cat_toy"


# commands.gdb provides the following functions for ease:
#   test "<message>"
#       Where <message> is the message to print. Must call this at the beginning of every test
#       Example: test "PINA: 0x00 => expect PORTC: 0x01"
#   checkResult
#       Verify if the test passed or failed. Prints "passed." or "failed." accordingly, 
#       Must call this at the end of every test.
#   expectPORTx <val>
#       With x as the port (A,B,C,D)
#       The value the port is epected to have. If not it will print the erroneous actual value
#   setPINx <val>
#       With x as the port or pin (A,B,C,D)
#       The value to set the pin to (can be decimal or hexidecimal
#       Example: setPINA 0x01
#   printPORTx f OR printPINx f 
#       With x as the port or pin (A,B,C,D)
#       With f as a format option which can be: [d] decimal, [x] hexadecmial (default), [t] binary 
#       Example: printPORTC d
#   printDDRx
#       With x as the DDR (A,B,C,D)
#       Example: printDDRB

echo ======================================================\n
echo Running all tests..."\n\n

test "on/off (on from off and vice versa)"
set state = off
setPINA 0xFF
timeContinue
expectPORTB 0x00
expect state off
setPINA 0xFE
timeContinue
expect state on
expect PORTB 0x01
setPINA 0xFF
timeContinue
expectPORTB 0x00
expect state off
setPINA 0xFE
timeContinue
expect state on
expect PORTB 0x01
timeContinue
checkResult

test "normal cw and ccw and wait"
expect state cw
expectPORTB 0x03
timeContinue
expect state ccw
expectPORTB 0x07
timeContinue
expect state cw
expectPORTB 0x03
timeContinue
expect state ccw
expect PORTB 0x07
timeContinue
expect state cw
expectPORTB 0x03
timeContinue
expect state wait
timeContinue
expectPORTB 0x01
expect state wait
timeContinue
expect state wait
timeContinue
expect state forward
expectPORTB 0x03
timeContinue
expect state forward
expectPORTB 0x03
timeContinue
expect state forward
expectPORTB 0x03
timeContinue
expect state forward
expectPORTB 0x03
timeContinue
expect state forward
timeContinue
checkResult

test "cat on toy from cw 3 separate hits"
expect state cw
expectPORTB 0x03
timeContinue
expect state ccw
setPINA 0xFC
timeContinue
expect state cw
timeContinue
expect state ccw
timeContinue
expect state cw
timeContinue
expect state hit
timeContinue
expect state hit
timeContinue
timecontinue
expectPORTB 0x01
expect state hit
timeContinue
expect state hit
timeContinue
expect state cw
checkResult

test "shutdown on cw and restart"
setPINA 0xFF
timeContinue
expect state off
setPINA 0xFE
timeContinue
expect state on
timeContinue
checkResult

test "cat on toy from ccw (3 inputs straight)"
setPINA 0xFC
expect state cw
expectPORTB 0x03
timeContinue
expect state ccw
timeContinue
expect state cw
timeContinue
expect state hit
timeContinue
expect state hit
timeContinue
expect state hit
timeContinue
timecontinue
expect state hit
timeContinue
setPINA 0xFE
expect state cw
timeContinue
expect state ccw
timeContinue
timecontinue
timeContinue
expect state cw
checkResult

test "shutdown on wait and restart"
timeContinue
expect state wait
setPINA 0xFF
timeContinue
expect state off
setPINA 0xFE
timeContinue
expect state on
timeContinue
checkResult

test "test shutdown on ccw and restart"
expect state cw
timeContinue
expect state ccw
setPINA 0xFF
timeContinue
expect state off
setPINA 0xFE
timeContinue
expect state on
checkResult

# Report on how many tests passed/tests ran
set $passed=$tests-$failed
eval "shell echo Passed %d/%d tests.\n",$passed,$tests
echo ======================================================\n
