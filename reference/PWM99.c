/* 输出128*128个数据到T3.c中 */
#include "stdio.h"
#include "math.h"
const double pi=3.141592654;
int c,i,k,m,p,n,u,v,w,x,y,z,b[129],pp;
double t=0.000000;
double r,s,s1,f,g,j,l,q,a[100];
double sum=0.000000;
int test(double q);
int table(int v);
 FILE *fp;                          /* 设文件指针 */
main()
{
  fp=fopen("T3.c","a+");            /* 打开文件T3.c,并将结果存入该文件 */
 if((fp=fopen("T3.c","a+"))==NULL)
 printf("error");
 n=0;                     /* n 代表第几条曲线 */
  q=1.000000;             /* q:0.666666--1 */
   while (n<=130)         /* 128 条曲线 */
    {
     printf("n=%d\n",n); 
      if(n>128)           /* n>128的结果舍去不要 */
      fprintf(fp,"n=%d ",n); 
       test(q);
	q=q-0.0026041666;     /* 将q分成128份，每分0.0026041666 */  
       n++;
    }
 fclose(fp);              /* 程序结束后关闭文件 */
}
test(double q)
{
 p=0,u=1,x=0,z=1,pp=0;
  for(w=0;w<128;w++)            /* 将一条正弦曲线分成128分 */    
  {
   for (k=0;k<156;k++)          /* 每分占 156.25us */
    { 
     for(i=1;i<=100;i++)        /* 利用富氏分解公式计算某一时刻的三角波值 */
      {
       l=(i%2==0)? -1.000000:1.000000;
	     j=l/((i*2-1)*(i*2-1)); 
	       f=j*sin(40000*(2*i-1)*pi*t);
	     f=8.33670275*f/(pi*pi);
       sum=sum+f;
      }
	 for(m=0;m<=127;m++)           /* 计算某一时刻的正弦值 */
	  {
	   if(t>=(m*0.00015625)&&t<=((m+1)*0.00015625))
	   {s=q*sin(100*pi*m*0.00015625);break;}
	  }
	    if(s>sum)        /* 正弦值大于三角值则存入数组 */
	     {  
	       a[p]=t;
		    p++;
	       u=0;          /* 标志数组存放的是本次计算结果 */
	     }
	    else
	     {
	      if(u==0)
	       {
		 p--;
		  r=a[p]-a[0];        /* 计算出脉宽时间值 */
		   r=r*1000000;
		  v=r*128/47;         /* 将时间值乘1000000并折算成移位数，并取整 */
		  pp++;
		 if(pp==2)            /* 取第二个脉宽值的移位数 */
		   table(v);          /* 将移位数转化为高位地址 */
		 u++;
	       }
	      p=0;
	     }
	   t=t+0.000001;          
	sum=0;
    }
    pp=0;
      x++;
       if(x%16==0)                  /* 16个数据一行 */
      {	printf("\n");  
      fprintf(fp,"\nDCB "); }
       if((w!=0)&&(w%4==0))         /* 时间校准 */
     t=t+0.000001;                        
     z=1.000000;
  }
    t=0;
    return 0;      
}
table(int v)        /* 将移位数转化为对应的高位地址 */
{
 int b[129];
 int e;
 int d=0x00;
 int ka=0x00;
 if((ferror(fp)!=0)||(feof(fp)!=0))
 {printf("error");
 fprintf(fp,"error");}
 for(e=1;e<=128;e++)                /* 将移位数转化为对应的高位地址 */ 
  b[e]=d++;
 if((b[v]==0x0a)||(b[v]==0x0b)||(b[v]==0x0c)||(b[v]==0x0d)||(b[v]==0x0e)||(b[v]=    
=0x0f))
  fprintf(fp,"%x",ka);               /* a,b,c,d,e,f前加0 */   
   fprintf(fp,"%xH,",b[v]); 
  return 0;
}





