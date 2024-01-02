function [ D ] = zeroinjection( A, z )
D=A;
%% remove all critical buses which connect with a ZI bus 
for i=1:size(z,2)
   S=find(D(z(i),:)==1);
   n=find(sum(D(S,:),2)==2);
   if size(n,1)>0
       D(S(n(1)),:)=0;
       D(:,S(n(1)))=0;
      z(i)=0;
   end
   clear n S
end
clear i
%% remove ZI bus which has two connected lines
z=nonzeros(z);
l=find(sum(D(z,:),2)==3);
for i=1:size(l,1)
   D(z(l(i)),z(l(i)))=0;
    S=find(D(z(l(i)),:)==1);
   D(S(1),S(2))=1;
   D(S(2),S(1))=1; 
   D(z(l(i)),:)=0;
    D(:,z(l(i)))=0;
   z(l(i))=0;
end
%% merge all ZI buses which connected 
z=nonzeros(z);
 DD=zeros(size(D,1));
    I1=DD;I2=DD; I1(z,:)=1;I2(:,z)=1; I=triu(I1.*I2);
   for i=1:size(z,1)
   S=find(D(z(i),:)==1);
   DD(z(i),S)=1;
   DD(S,z(i))=1;
   DD(z(i),z(i))=0;
end
  DD=DD.*I;
[c r]= find (DD==1);
for i=1:size(r,1)
   D(r(i),:)=D(r(i),:)|D(c(i),:);
   D(:,r(i))=D(:,r(i))|D(:,c(i));
   D(c(i),:)=0;
   D(:,c(i))=0;
   for ii=1:size(c,1)
      n=find(z==c(ii));
      if size(n,2)>0
      z(n)=0;
      end
   end
end
%% remove ZI which has three connected lines 
z=nonzeros(z);
l=find(sum(D(z,:),2)==4);
clear a
for i=1:size(l,1)
   D(z(l(i)),z(l(i)))=0;
    S=find(D(z(l(i)),:)==1);
    [~,I]=sort(sum(D(S,:),2));
    if D(S(I(3)),S(I(2)))==1;
       D(S(I(1)),S(I(3)))=1;
       D(S(I(3)),S(I(1)))=1;
       D(z(l(i)),:)=0;
       D(:,z(l(i)))=0;
       z(l(i))=0;
       continue;
   end    
if D(S(I(1)),S(I(3)))==1;
       D(S(I(2)),S(I(3)))=1;
       D(S(I(3)),S(I(2)))=1;
       D(z(l(i)),:)=0;
       D(:,z(l(i)))=0;
       z(l(i))=0;
       continue;
end  
 end

z=nonzeros(z);
for i=1:size(z,1)
   S=find(D(z(i),:)==1);
   l=find(sum(D(S,:),2)==min(sum(D(S,:),2)));
   if size(l,1)>1
       for j=1:size(l,1)
           SS=find(D(S(l(j)),:)==1);
           SS(find(SS==S(l(j))))=0;
           SS(find(SS==z(i)))=0;
           SS=nonzeros(SS);
           tic
           ll=find(sum(D(SS,:),2)==min(sum(D(SS,:),2)));
           W(j)=sum(D(SS(ll(1)),:),2);
       end
       II=find(W==min(W));
       D(S(l(II)),:)=0;
       D(:,S(l(II)))=0;
       
   else
      D(l,:)=0;
      D(:,l)=0;
   end
   z(i)=0;
 clear S SS l W II
end
% tic
end