
int f(int b){
int i,j = -1;
int *a;
i = 8;
a = &i;
b *= *a + j;
if(b > 0 )return b;
else return -1;
}

