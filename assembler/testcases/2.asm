#comments are ignored
.ORG 0  
10
#empty lines are ignored 

.ORG 2  #this is the interrupt address
100

.ORG 10
ldm r1, 10
dec R1         #also comments here are ignored
ldm r2, 5
sub r1, r1, r2
ldm r0, 11
or r0, r0, r1
shl r0, 5
std r0, 53
inc r0
nop
push r1