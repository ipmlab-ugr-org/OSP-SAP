%IDENTIFICACION DE NODOS Y DOF

function [nodo,dof]=identificador(n_fila,op)
% INPUT:
%   -> n_fila: DOF number (from 1 to n_gdl * len(nodos))
%   -> op: if 1 we assume Uz DOF; else Ux, Uy, Uz DOFs
% OUTPUT:
%   -> nodo: the id (not the name!) of the node; if there is a total of 10
%   nodes, nodo ranges from 1 to 10 (althought 10th node is called "17")
%   -> dof: 1, 2 or 3 according to the DOF Ux, Uy, Uz

% SUBSTITUTE op BY Target_DOFs

%dofn=3;  %Grados de libertad en cada nodo
if op==1
    dofn=1;
else
    dofn=3;
end

n=n_fila;
nodo = ceil(n/dofn);      %nodo redondeado
dof = n-dofn*(nodo-1);

% By default, op=1 -> Uz
if dofn==1
    dof=3;
end

end




