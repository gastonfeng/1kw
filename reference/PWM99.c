/* ���128*128�����ݵ�T3.c�� */
#include "stdio.h"
#include "math.h"
const double pi=3.141592654;
int c,i,k,m,p,n,u,v,w,x,y,z,b[129],pp;
double t=0.000000;
double r,s,s1,f,g,j,l,q,a[100];
double sum=0.000000;
int test(double q);
int table(int v);
 FILE *fp;                          /* ���ļ�ָ�� */
main()
{
  fp=fopen("T3.c","a+");            /* ���ļ�T3.c,�������������ļ� */
 if((fp=fopen("T3.c","a+"))==NULL)
 printf("error");
 n=0;                     /* n ����ڼ������� */
  q=1.000000;             /* q:0.666666--1 */
   while (n<=130)         /* 128 ������ */
    {
     printf("n=%d\n",n); 
      if(n>128)           /* n>128�Ľ����ȥ��Ҫ */
      fprintf(fp,"n=%d ",n); 
       test(q);
	q=q-0.0026041666;     /* ��q�ֳ�128�ݣ�ÿ��0.0026041666 */  
       n++;
    }
 fclose(fp);              /* ���������ر��ļ� */
}
test(double q)
{
 p=0,u=1,x=0,z=1,pp=0;
  for(w=0;w<128;w++)            /* ��һ���������߷ֳ�128�� */    
  {
   for (k=0;k<156;k++)          /* ÿ��ռ 156.25us */
    { 
     for(i=1;i<=100;i++)        /* ���ø��Ϸֽ⹫ʽ����ĳһʱ�̵����ǲ�ֵ */
      {
       l=(i%2==0)? -1.000000:1.000000;
	     j=l/((i*2-1)*(i*2-1)); 
	       f=j*sin(40000*(2*i-1)*pi*t);
	     f=8.33670275*f/(pi*pi);
       sum=sum+f;
      }
	 for(m=0;m<=127;m++)           /* ����ĳһʱ�̵�����ֵ */
	  {
	   if(t>=(m*0.00015625)&&t<=((m+1)*0.00015625))
	   {s=q*sin(100*pi*m*0.00015625);break;}
	  }
	    if(s>sum)        /* ����ֵ��������ֵ��������� */
	     {  
	       a[p]=t;
		    p++;
	       u=0;          /* ��־�����ŵ��Ǳ��μ����� */
	     }
	    else
	     {
	      if(u==0)
	       {
		 p--;
		  r=a[p]-a[0];        /* ���������ʱ��ֵ */
		   r=r*1000000;
		  v=r*128/47;         /* ��ʱ��ֵ��1000000���������λ������ȡ�� */
		  pp++;
		 if(pp==2)            /* ȡ�ڶ�������ֵ����λ�� */
		   table(v);          /* ����λ��ת��Ϊ��λ��ַ */
		 u++;
	       }
	      p=0;
	     }
	   t=t+0.000001;          
	sum=0;
    }
    pp=0;
      x++;
       if(x%16==0)                  /* 16������һ�� */
      {	printf("\n");  
      fprintf(fp,"\nDCB "); }
       if((w!=0)&&(w%4==0))         /* ʱ��У׼ */
     t=t+0.000001;                        
     z=1.000000;
  }
    t=0;
    return 0;      
}
table(int v)        /* ����λ��ת��Ϊ��Ӧ�ĸ�λ��ַ */
{
 int b[129];
 int e;
 int d=0x00;
 int ka=0x00;
 if((ferror(fp)!=0)||(feof(fp)!=0))
 {printf("error");
 fprintf(fp,"error");}
 for(e=1;e<=128;e++)                /* ����λ��ת��Ϊ��Ӧ�ĸ�λ��ַ */ 
  b[e]=d++;
 if((b[v]==0x0a)||(b[v]==0x0b)||(b[v]==0x0c)||(b[v]==0x0d)||(b[v]==0x0e)||(b[v]=    
=0x0f))
  fprintf(fp,"%x",ka);               /* a,b,c,d,e,fǰ��0 */   
   fprintf(fp,"%xH,",b[v]); 
  return 0;
}





