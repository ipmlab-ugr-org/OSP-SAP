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

%%
%incluye lista de nodos
n_gdl = 3;
gdl=[1:n_nodos*n_gdl];
n_gdlt=length(gdl);

%%
Target_DOFs_labels = [1,2,3]; % [0,1,0] corresponds to DOF 2

n_gdl_target = sum(Target_DOFs);
n_nodos=length(n_candidates);

nodo2=zeros(1,n_nodos*n_gdl_target); % stores the node name for each DOF
nodo2=zeros(1,n_nodos*n_gdl_target);
adof=zeros(1,n_nodos);
anode=zeros(1,length(n_candidates));

% nodo2 assigment
for i=1:n_gdl_target
    indices = (1:n_nodos) * n_gdl_target - (n_gdl_target-i);
    nodo2(indices) = n_candidates(:,1);
end

%% OTRA VERSIÓN CON CELL-ARRAYS

DAT=cell(2,n_gdl);  %Crea un array vacío de esas dimensiones
Target_DOFs_labels = [1,2,3]; % [0,1,0] corresponds to DOF 2
considered_dofs = Target_DOFs_labels(Target_DOFs>0);

i=0;
for j=1:n_gdlt
    
    [nodo,dof]=identificador(gdl(1,j),2);
    
    if ~ismember(dof, considered_dofs)
        continue; % or continue if inside a loop
    end
    i = i+1;
    
    DAT{1,i}=['D.O.F.- ' sprintf('%d',gdl(1,j))];
    sensors_GRL(i,1) = nodo2(i);
    if dof == 1
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Ux'];
        sensors_GRL(i,2:4) = [1,0,0];
    elseif dof == 2
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Uy'];
        sensors_GRL(i,2:4) = [0,1,0];
    elseif dof == 3
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Uz'];
        sensors_GRL(i,2:4) = [0,0,1];
    end
   
end
DAT=DAT';

%%
for i=1:n_gdlt;
    adof(i)=gdl(i);
    anode(i)=nodo2(i);
end

adof=gdl';
anode=nodo2';

DAT=DAT';
LISTA=DAT;
end