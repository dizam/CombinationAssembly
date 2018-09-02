#void swap(int* a, int*b){
# int temp = *a;
#*a = *b;
#*b = temp;
#}

.global swap
.equ wordsize, 4


swap:
  #prolgue
  pushl %ebp
  movl %esp, %ebp
  subl $wordsize, %esp #make space for temp
  
  .equ a, 2*wordsize #(%ebp)
  .equ b, 3*wordsize #(%ebp)
  .equ temp, -1*wordsize #(%ebp)
  
  #eax will be a
  #ecx will be b
  #edx will be scratch
  
  movl a(%ebp), %eax #get a from the stack
  movl b(%ebp), %ecx #get b from the stack
  
  #temp = *a
  movl (%eax), %edx
  movl %edx, temp(%ebp) 
  
  #*a = *b;
  movl (%ecx), %edx
  movl %edx, (%eax)
  
 #*b = temp
 movl temp(%ebp), %edx
 movl %edx, (%ecx)
 
 #epilogue
 movl %ebp, %esp
 pop %ebp
 
 ret
 
  
