	.globl	f
	.ent	f
	.type	f, @function
f:
	.frame	$fp,12,$31
	addiu	$sp,$sp,-12
	sw	$fp,8($sp)
	move	$fp,$sp
	sw	$4,12($fp)
	lw	$2,12($fp)
	addiu	$2,$2,1
	sw	$2,12($fp)
	li	$2,3
	lw	$3,12($fp)
	mul	$2,$2,$3
	sw	$2,12($fp)
	lw	$2,12($fp)
	li	$3,0
	slt	$2,$2,$3
	andi	$2,$2,0x00ff
	bne	$2,$0,$L0
	b	$L1
	nop
$L0
	li	$2,0
	b	$L2
	nop
$L1
	lw	$2,12($fp)
	b	$L2
	nop
$L2
	sw	$2,12($fp)
	lw	$2,12($fp)
	move	$sp,$fp
	lw	$fp,8($sp)
	addiu	$sp,$sp,12
	j	$31
	nop

	.end	f
	.size	f, .-f
