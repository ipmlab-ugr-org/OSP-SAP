%% Identifies the target dof given a DOF number

function target_dof=dof_identifier(n_fila,Target_DOFs, Target_DOFs_labels)
% INPUT:
%   -> n_fila: DOF number (from 1 to n_gdl * len(nodos))
%   -> Target_DOFs: list of length 3 with value 1 if the DOF is a target,
%   else 0 (e.g. [0,1,1] are Uy, Uz)
%   -> Target_DOFs_labels: target_dof number assigned to each Target_DOFs; in
%   general, Target_DOFs_labels=[1,2,3]; which means that Ux -> 1, Uy -> 2,
%   Uz -> 3
% OUTPUT:
%   -> target_dof: Target_DOFs_labels(1), Target_DOFs_labels(2) or Target_DOFs_labels(3);
%   if Target_DOFs_labels=[1,2,3] (which is set), then target_dof = 1 if
%   Ux, target_dof = 2 if Uy, target_dof = 3 if Uz;

% Getting de target_dof (1, 2 or 3)
n_gdl = sum(Target_DOFs);
node_id = ceil(n_fila/n_gdl); % the id (not the name!) of the node
dof_label_idx = n_fila - (node_id - 1) * n_gdl;
aux_labels = Target_DOFs_labels(find(Target_DOFs==1));
target_dof = aux_labels(dof_label_idx);

end