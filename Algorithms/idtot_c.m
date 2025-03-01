function [LISTA,adof,anode,sensors_GRL] = idtot_c (n_candidates, Target_DOFs)

%{
FUNCTION DUTIES:
    From candidate nodes, it obtains the DOFs;
INPUT:
    -> n_candidates: list containing all the model nodes; first column is the node label;
    columns 2 - 4 are the X, Y, Z coordinates
    -> Target_DOFs: Selected target dofs; example [0,1,1] if Uy, Uz; 
OUTPUT:
    -> LISTA: List to ease the understanding, first column contains the number of DOF,
    second column the Node and direction of measurement
    -> adof: Just a list with the numbered DOFS (e.g. if 10 DOFs, then it is
    of length 10 and elements are 1, 2... 10)
    -> anode: list containing the names of the nodes to which each adof is
    referred. Example: adof = 1, 2, 3, 4, 5, 6, anode = 2, 2, 2, 5, 5, 5 which
    means that the first 3 adofs are related to node 2,the next 3 to node 5,
    etc.
    -> sensors_GRL: 4 columns, the first is the same as anode, the other 3 are
    1, 0, 0 if the DOF measures on U1, 0, 1, 0 for U2, 0, 0, 1 for U3
%}

%%
% INCLUDE Target_DOFs as input
Target_DOFs_labels = [1,2,3]; % [0,1,0] corresponds to DOF 2
%incluye lista de nodos
n_gdl = sum(Target_DOFs);
%n_gdl = 3;
n_nodos=length(n_candidates);
gdl=[1:n_nodos*n_gdl];
n_gdlt=length(gdl);

nodo2=zeros(1,n_nodos*n_gdl); % stores the node name for each DOF
nodo2=zeros(1,n_nodos*n_gdl);
adof=zeros(1,n_nodos);
anode=zeros(1,length(n_candidates));

% nodo2 assigment
for i=1:n_gdl
    indices = (1:n_nodos) * n_gdl - (n_gdl-i);
    nodo2(indices) = n_candidates(:,1);
end

%% 

DAT=cell(2,n_gdl);  %Crea un array vacío de esas dimensiones

for i=1:n_gdlt
    % Retrieve the target_dof
    target_dof = dof_identifier(gdl(1,i),Target_DOFs,Target_DOFs_labels);
    
    % Fill the table
    DAT{1,i}=['D.O.F.- ' sprintf('%d',gdl(1,i))];
    sensors_GRL(i,1) = nodo2(i);
    if target_dof == Target_DOFs_labels(1);
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Ux'];
        sensors_GRL(i,2:4) = [1,0,0];
    elseif target_dof == Target_DOFs_labels(2)
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Uy'];
        sensors_GRL(i,2:4) = [0,1,0];
    elseif target_dof == Target_DOFs_labels(3)
        DAT{2,i}=['Node - ' sprintf('%d',nodo2(i)) ' - Uz'];
        sensors_GRL(i,2:4) = [0,0,1];
    end   
end

adof=gdl';
anode=nodo2';

DAT=DAT';
LISTA=DAT;
end