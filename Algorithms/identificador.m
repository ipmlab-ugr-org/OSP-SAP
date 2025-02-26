%IDENTIFICACION DE NODOS Y DOF

function [nodo,dof]=identificador(n_fila,op)

%ENTRADA
%n: posición de la fila en el vector de modos

%dofn=3;  %Grados de libertad en cada nodo
if op==1
    dofn=1;
else
    dofn=3;
end
%dofn: grados de libertad por nodos --> SE CONSIDERAN 6 POR DEFECTO

%SALIDA
%nodo: nodo identificado
%dof: grado de libertad del nodo

n=n_fila;

nodo = ceil(n/dofn);      %nodo redondeado
dof = n-dofn*(nodo-1);

if dofn==1
    dof=3;
end

end




