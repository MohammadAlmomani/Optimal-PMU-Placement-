clear all
clc
disp('Which Test Case do you want to use?');
disp('1. IEEE 14-bus');
disp('2. IEEE 30-bus');
disp('3. IEEE 57-bus');
disp('4. IEEE 118-bus');
disp('5. IEEE 24 bus');
disp('6. IEEE 33 bus');
disp('7. IEEE 34 bus');
disp('8. IEEE 123 bus');
disp('9. jordan 68 bus');
c=input ('Pleas input a number between 1-9 \n');
% connectivitiy matrix file
 [connectivityMat , z] =CM(c);clear c 
     D=connectivityMat;A=D;
 N=size(D,1);   %number of bus
%% zero injection bus
disp ('include zero injection bus? ')
 c=input ('1- YES \n 2- NO \n');
 tic;
  if c == 1
if size(z,2)>0
 % modified matrix which implement the ZI buses
[D]=zeroinjection (D,z);  
end
 end
A=D;
%% start algorithm
i=1;  %   i PMU index

 while (1)  
   X=sum(A,2);
     for j=1:N
      if X(j)>0
     X(j)=X(j)^-2;     % equation 1 
      end
     end
     
      for j=1:N
        B(1:N,j)=X.*D(:,j);    % B matrix
      end
      S=sum(B,1);  clear B;
         x=(find(S==max(S))); clear S;  % select maximum summation
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         if size(x,2)>1    % if more than maximum value of summation is found; the algorithm 
         for j=1:N          % use the matrix A to avoid any observable buses in the last selection  
        C(1:N,j)=X.*A(:,j);    %and select any bus which have the maximum value without any observable 
         end 
        SS=sum(C,1); clear C X;
        xx=find(SS==max(SS)); clear SS;
     for j=1:size(xx,2)
          newv=find(x==xx(j));
          if size(newv,2)>0
          break;
            end
     end
        if all(xx)>0
        x=xx(j);
        end
         end
      clear xx newv 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
       XX(i)=x;clear x;    % XX PMU vector
    
      m=find(D(XX(i),:)>0); 
       A(m,:)=0;
       A(:,m)=0; clear m;     % remove all observable buses from connectivity matrix
      i=i+1;
     if any(any(A))==0      % is all buses removed (that mean all system become observe)
       break;
   end
   clear x
 end
 clear A D i j N
 time=toc;
 fprintf('optimal Number of PMU :%d', size(XX,2));
 fprintf ('\n optimal PMU location :'); 
 fprintf(' %d ',sort(XX));
 fprintf('\n run time in (s)  : %d \n',time);
 disp('{{{{global connectivity matrix algorithm by Almomani Mohammad "monqedmohammad@gmail.com"}}}}');