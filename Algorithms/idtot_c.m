function [LISTA,adof,anode,sensors_GRL] = idtot_c (n_candidates)

%{
   FUNCTION DUTIES:
-> LISTA: List to ease the understanding, first column contains the number of DOF,
second column the Node and direction of measurement
-> adof: Just a list with the numbered DOFS (e.g. if 10 DOFs, then it is
of length 10 and elements are 1, 2... 10
-> anode: list containing the names of the nodes to which each adof is
referred. Example: adof = 1, 2, 3, 4, 5, 6, anode = 2, 2, 2, 5, 5, 5 which
means that the first 3 adofs are related to node 2,the next 3 to node 5,
etc.
-> sensors_GRL: 4 columns, the first is the same as anode, the other 3 are
1, 0, 0 if the DOF measures on U1, 0, 1, 0 for U2, 0, 0, 1 for U3
%}


%% DATOS PRELIMINARES Y AUTOMATIZADOS

% n_gdl = 3;
% n_nodos = (length(MOD(:,1)))/n_gdl;
% n_gdlt = length(MOD(:,1));
% gdl=[1:n_gdlt];

%%
%incluye lista de nodos
n_gdl = 3;
n_nodos=length(n_candidates);
gdl=[1:n_nodos*n_gdl];
n_gdlt=length(gdl);

nodo2=zeros(1,n_nodos*n_gdl);
adof=zeros(1,n_nodos);
anode=zeros(1,length(n_candidates));

if n_gdl==1
    
    for i=1:1:length(nodo2);
        nodo2(i)= n_candidates(ceil(i/n_gdl));
    end
else
    
    for i=1:3:length(nodo2);
        nodo2(i)= n_candidates(ceil(i/n_gdl));
        nodo2(i+1)= n_candidates(ceil(i/n_gdl));
        nodo2(i+2)= n_candidates(ceil(i/n_gdl));
    end
end

%% OTRA VERSIÓN CON CELL-ARRAYS

DAT=cell(2,n_gdl);  %Crea un array vacío de esas dimensiones

for i=1:n_gdlt
    
    [nodo,dof]=identificador(gdl(1,i),2);
    
    DAT{1,i}=['D.O.F.- ' sprintf('%d',gdl(1,i))];
    sensors_GRL(i,1) = nodo2(i);
    if dof == 1
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Ux'];
        sensors_GRL(i,2:4) = [1,0,0];
    end
    if dof == 2
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Uy'];
        sensors_GRL(i,2:4) = [0,1,0];
    end
    if dof == 3
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Uz'];
        sensors_GRL(i,2:4) = [0,0,1];
    end
    if dof == 4
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Rx'];
    end
    if dof == 5
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Ry'];
    end
    if dof == 6
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Rz'];
    end
    
end

for i=1:n_gdlt;
    adof(i)=gdl(i);
    anode(i)=nodo2(i);
end

adof=gdl';
anode=nodo2';

DAT=DAT';
LISTA=DAT;
end