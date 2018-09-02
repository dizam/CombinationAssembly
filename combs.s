
	.global get_combs
	.equ wordsize, 4
get_combs:
	push %ebp
	movl %esp, %ebp
	subl $6*wordsize, %esp
	.equ items, 2*wordsize
	.equ k, 3*wordsize
	.equ len, 4*wordsize
	.equ rows, -1*wordsize
	.equ result, -2*wordsize
	.equ i, -3*wordsize
	.equ temp, -4*wordsize
	.equ row, -5*wordsize
	.equ rowchanger, -6*wordsize

	push %ebx
	
	push k(%ebp)
	push len(%ebp)
	call num_combs
	addl $2*wordsize, %esp
	
	movl %eax, rows(%ebp)
	shll $2, %eax
	push %eax
	call malloc
	addl $1*wordsize, %esp

	movl %eax, result(%ebp)

        movl k(%ebp), %ebx
	shll $2, %ebx
	push %ebx

	
#ECX will be i
	movl $0, %ecx
loop1:	
	cmpl rows(%ebp), %ecx
	jge end_loop1
	movl %ecx, i(%ebp)
	call malloc

	movl result(%ebp), %edx
	movl i(%ebp), %ecx
	movl %eax, (%edx, %ecx, wordsize)
	movl %edx, %eax
	incl %ecx
	jmp loop1
end_loop1:
        addl $1*wordsize, %esp
        movl k(%ebp), %ecx
	shll $2, %ecx
	push %ecx
	call malloc
	addl $1*wordsize, %esp
	movl %eax, temp(%ebp)
	
	movl temp(%ebp), %ebx
	

	movl $0, row(%ebp)
	leal row(%ebp), %edx
	push %edx
	push %ebx #1
	push $0 #2
	push $0 #3
	movl len(%ebp), %edx
	push %edx #4
	movl k(%ebp), %edx
	push %edx #5
	movl result(%ebp), %edx
	push %edx #6
	movl items(%ebp), %edx
	push %edx #7
	call combo
	addl $8*wordsize, %esp

	movl result(%ebp), %eax
	pop %ebx
	movl %ebp, %esp
	pop %ebp
	ret

	
	.global combo
	.equ wordsize, 4

combo:
	
	push %ebp
	movl %esp, %ebp
	subl $2*wordsize, %esp
	
	.equ items, 2*wordsize
	.equ results, 3*wordsize
	.equ k, 4*wordsize
	.equ len, 5*wordsize
	.equ start, 6*wordsize
	.equ index, 7*wordsize
	.equ temp, 8*wordsize
	.equ rowchanger, 9*wordsize
 	.equ j, -1*wordsize
	.equ i, -2*wordsize

        push %ebx
	push %esi
	push %edi

	movl results(%ebp), %eax
	movl k(%ebp), %ecx
	cmpl index(%ebp), %ecx
	jnz recurse
	#edx will be j
	movl $0, %edx
loop2:	
	cmpl index(%ebp), %edx
	jge end_loop2
	movl temp(%ebp), %ecx
	movl (%ecx, %edx, wordsize), %ecx
	movl results(%ebp), %esi
	movl rowchanger(%ebp), %ebx
        movl (%ebx), %ebx
	movl (%esi, %ebx, wordsize), %esi
	movl %ecx, (%esi, %edx, wordsize)

	incl %edx
	jmp loop2
end_loop2:

	movl rowchanger(%ebp), %ebx
	incl (%ebx)
	movl %ebx, rowchanger(%ebp)
	jmp ending
	
	
recurse:
	#ecx will be i
	movl start(%ebp), %ecx
loop3:	
	cmpl len(%ebp), %ecx
	jge end_loop3
	movl items(%ebp), %edx
	movl temp(%ebp), %esi
	movl (%edx, %ecx, wordsize), %edx
	movl index(%ebp), %edi
	movl %edx, (%esi, %edi, wordsize)
	movl %esi, temp(%ebp)
	


	movl rowchanger(%ebp), %edx
	push %edx
	movl temp(%ebp), %edx
	push %edx #1
	movl index(%ebp), %edx
	incl %edx
	push %edx #2
	movl %ecx, %edx
	incl %edx
	push %edx #3
	movl len(%ebp), %edx
	push %edx #4
	movl k(%ebp), %edx
	push %edx #5
	movl results(%ebp), %edx
	push %edx #6
	movl items(%ebp), %edx
	push %edx #7
	movl %ecx, i(%ebp)
	call combo
	addl $8*wordsize, %esp

	movl i(%ebp), %ecx
	incl %ecx
	jmp loop3
end_loop3:
	jmp ending
ending:
	pop %edi
	pop %esi
	pop %ebx
	
       movl result(%ebp), %eax
	movl %ebp, %esp
	pop %ebp
	ret
	 
	
/*int rows = num_combs(len, k);
  int **result = malloc(sizeof(int*) * rows);
  int i;
  for (i = 0; i < rows; i++)
  {
    result[i] = malloc(sizeof(int) * k);
  }
  int temp[k];
  int row = 0;
  int *rowchanger = &row;
  combo(items, result, k, len, rowchanger, 0, 0, temp);
 
  return result;*/
 	
/*
	{
  if (index == k)
    {
       int j;
       for (j = 0; j < k; j++)
	{
	  results[*row][j] = temp[j];
	  }
      *row = *row + 1;
      return;
    }
  int i;
  for (i = start; i < len; i++)
    {
       temp[index] = items[i];
       combo(items, results, k, len, row, i + 1, index + 1, temp);
    }
}
	*/
	
	
