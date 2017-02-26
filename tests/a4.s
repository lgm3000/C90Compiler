	.globl	f
	.ent	f
	.type	f, @function
f:
	.frame	$fp,16,$31
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	lw	$2,16($fp)
	li	$3,0
	slt	$2,$3,$2
	andi	$2,$2,0x00ff
	beq	$2,$0,$L0
	nop
	li	$2,10
	sw	$2,8($fp)
	b	$L1
	nop
$L0:
	lw	$2,16($fp)
	li	$3,0
	slt	$2,$2,$3
	andi	$2,$2,0x00ff
	beq	$2,$0,$L2
	nop
	li	$2,-10
	sw	$2,8($fp)
	b	$L3
	nop
$L2:
	li	$2,0
	sw	$2,8($fp)
$L3:
$L1:
	lw	$2,8($fp)
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	j	$31
	nop

	.end	f
	.size	f, .-f
