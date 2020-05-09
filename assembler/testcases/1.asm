#comments are ignored
.ORG 0  
10
#empty lines are ignored 

.ORG 2  #this is the interrupt address
100

.ORG 10
NOT R1         #also comments here are ignored
ldm r4, 15
shl r4, 2
add R1, r2, r1
in r5
and r4, r4, r1
std r4, 200
ldm r7, 2
shl r7, 4
jmp r2


