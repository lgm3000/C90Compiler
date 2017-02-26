	.globl	f
	.ent	f
	.type	f, @function
f:
	.frame	$fp,16,$31
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	li	$2,3
	sw	$2,16($fp)
	sw	$2,16($fp)
	sw	$2,8($fp)
	sw	$2,16($fp)
	sw	$2,16($fp)
	sw	$2,16($fp)
	sw	$2,16($fp)
	lw	$2,16($fp)
	lw	$3,8($fp)
	addu	$2,$2,$3
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	j	$31
	nop

	.end	f
	.size	f, .-f
