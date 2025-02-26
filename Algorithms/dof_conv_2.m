function [dof_setup,nodes_setup,dir_setup] = dof_conv_2(setup_nodes,sensors,nodes)
% INPUTS:
%   setup_nodes - Matrix of size (n2 x 4):
%       - Column 1: Names of the nodes included in the setup (or all candidate nodes if using a global EfI).
%                   These nodes must be present in the first column of the 'nodes' matrix.
%       - Columns 2-4: Node coordinates (not used in this function).
%
%   sensors - Array of size (3*N x 4):
%       - Column 1: Node ID from SAP2000 (a unique integer from 1 to N, without jumps).
%                   This ID is different from the node name, which belongs to the range 1 to N2 (where N2 >= N).
%                   Some node names may be omitted.
%       - Columns 2-4: DOF representation, where each row corresponds to a DOF:
%                      - [1, 0, 0] ? U1 (DOF in x-direction)
%                      - [0, 1, 0] ? U2 (DOF in y-direction)
%                      - [0, 0, 1] ? U3 (DOF in z-direction)
%
%   nodes - Matrix of size (N x 4), containing SAP2000 node data:
%       - Column 1: Node names (not node IDs).
%       - Columns 2-4: Node coordinates.
% OUTPUT:
%   dof_setup - Vector of size (1 x 3*n2):
%       - Contains the DOF numbers associated with each element in setup_nodes.
%       - Each DOF number is between 1 and 3*N.
%
%   nodes_setup - Vector of size (1 x 3*n2):
%       - Contains the names of the nodes to which each DOF in dof_setup belongs.
%       - Example:
%           If dof_setup = [1, 2, 3, 7, 8, 9] and nodes_setup = [2, 2, 2, 5, 5, 5],
%           it means:
%           - DOFs 1, 2, 3 belong to node 2.
%           - DOFs 7, 8, 9 belong to node 5.
%
%   dir_setup - Vector of size (1 x 3*n2):
%       - Indicates the direction of each DOF:
%           - 1 ? U1 (x-direction)
%           - 2 ? U2 (y-direction)
%           - 3 ? U3 (z-direction)

%indexes = cell(length(setup_nodes), 1);
indexes = cell(size(setup_nodes,1),1);
for i = 1:size(setup_nodes,1)
    indexes{i} = find(nodes(sensors(:,1),1) == setup_nodes(i));
end
dof_setup_aux = horzcat(indexes{:});
dof_setup = [];
for i=1:size(dof_setup_aux,2)
    dof_setup = [dof_setup, dof_setup_aux(:, i).'];
end

for i=1:length(dof_setup)
    if sensors(i,2:4) == [1, 0, 0]
        dir_setup(i) = 1;
    elseif sensors(i,2:4) == [0, 1, 0]
        dir_setup(i) = 2;
    else
        dir_setup(i) = 3;
    end
end

nodes_setup_aux = nodes(sensors(:,1),1).';
%isInSetupNodes = ismember(nodes_setup_aux, setup_nodes);
isInSetupNodes = ismember(nodes_setup_aux, setup_nodes(:,1));
nodes_setup = nodes_setup_aux(isInSetupNodes);

end