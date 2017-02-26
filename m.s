	.globl	f
	.ent	f
	.type	f, @function
f:
	.frame	$fp,24,$31
	addiu	$sp,$sp,-24
	sw	$fp,20($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	li	$2,-1
	sw	$2,12($fp)
	li	$2,8
	sw	$2,8($fp)
	addiu	$2,$fp,8
	sw	$2,16($fp)
	lw	$3,16($fp)
	lw	$2,0($3)
	lw	$3,12($fp)
	addu	$2,$2,$3
	lw	$3,24($fp)
	mul	$2,$2,$3
	sw	$2,24($fp)
	lw	$2,24($fp)
	li	$3,0
	slt	$2,$3,$2
	andi	$2,$2,0x00ff
	beq	$2,$0,$L0
	nop
	lw	$2,24($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

	b	$L1
	nop
$L0:
	lw	$2,0($fp)
	move	$sp,$fp
	lw	$fp,20($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

$L1:
	.end	f
	.size	f, .-f


