	.globl	f
	.ent	f
	.type	f, @function
f:
	.frame	$fp,20,$31
	addiu	$sp,$sp,-20
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,20($fp)
	li	$2,1
	sw	$2,12($fp)
	li	$2,0
	sw	$2,8($fp)
$L0
	lw	$2,8($fp)
	lw	$3,20($fp)
	slt	$2,$2,$3
	andi	$2,$2,0x00ff
	beq	$2,$0,$L12
	nop
	li	$2,2
	lw	$3,12($fp)
	mul	$2,$2,$3
	sw	$2,12($fp)
	lw	$2,8($fp)
	addiu	$2,$2,1
	sw	$2,8($fp)
	b	$L0
$L1
	lw	$2,12($fp)
	move	$sp,$fp
	lw	$fp,16($sp)
	addiu	$sp,$sp,20
	j	$31
	nop

	.end	f
	.size	f, .-f
