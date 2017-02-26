	.globl	f
	.ent	f
	.type	f, @function
f:
	.frame	$fp,12,$31
	addiu	$sp,$sp,-12
	sw	$fp,8($sp)
	move	$fp,$sp
	sw	$4,12($fp)
$L0
	lw	$2,12($fp)
	li	$3,10
	slt	$2,$2,$3
	andi	$2,$2,0x00ff
	beq	$2,$0,$L1
	nop
	lw	$2,12($fp)
	addiu	$2,$2,1
	sw	$2,12($fp)
	b	$L0
$L1
	lw	$2,12($fp)
	move	$sp,$fp
	lw	$fp,8($sp)
	addiu	$sp,$sp,12
	j	$31
	nop

	.end	f
	.size	f, .-f
