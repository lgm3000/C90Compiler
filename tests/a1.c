int f(int a){
int c[10],i,s=0;
for(i=0;i<10;i++) c[i] = i;
for(i=9;i>=0;i--) s+=c[i];
return s+a;
}

int g(int a){
int c[10],i,s=0;
for(i=0;i<10;i++) c[i] = i;
for(i=9;i>=0;i--) s+=c[i];
return s+a;
}
