function PROJECT_OSP = OSP_run(PROJECT_OSP)

method = PROJECT_OSP.config.method; % 'EFI', 'KEMRO', 'SEMRO' or 'EFIWM'
n_modes = numel(PROJECT_OSP.config.selmodes);
sel_modes = PROJECT_OSP.config.selmodes;

% Get references
sensors = PROJECT_OSP.geometry.sensors;
all_nodes = PROJECT_OSP.geometry.nodes;
if ~isfield(PROJECT_OSP.geometry,'References') | PROJECT_OSP.config.runGlobalOSP
    ref = [];
    gdl_ref = [];
else %(possibility of lacking nodes)
    if ~isempty(PROJECT_OSP.geometry.References)
        References = PROJECT_OSP.geometry.References;
        References_id = References; % Attention! sensors(:,1) are id, not nodes labels
        ref = References(:,1)';
        [is_member, References_id(:,1)] = ismember(ref, all_nodes(:, 1));
        [is_member, gdl_ref] = ismember(References_id, sensors, 'rows');
        gdl_ref = gdl_ref.';
        for i = 1:size(gdl_ref, 2)
            if isequal(References(i, 2:4),[1,0,0])
                dir_ref(i) = 1;
            elseif isequal(References(i, 2:4),[0,1,0])
                dir_ref(i) = 2;
            else
                dir_ref(i) = 3;
            end
        end
    else
        ref = [];
        gdl_ref = [];
    end
end

%% OPTIMIZACIÓN OSP

% % Número de grados de libertad
% op = 2; % If we only want vertical dofs: op=1
% if op==1
%     n_gdl = 1;
% else
%     n_gdl = 3;
% end

%% MODOS DE VIBRACIÓN
MOD = PROJECT_OSP.modalprop.Mode_shape;

%% LISTS
% n_setup decides if running a global or a multisetup OSP
n_setup = PROJECT_OSP.geometry.Nsetups;
if n_setup == 0 | PROJECT_OSP.config.runGlobalOSP
    n_setup = 1;
end

%  LIST NODES
[LISTA_GRL_tot,adof_grl_tot,anode_grl_tot,sensors_GRL_tot] = idtot_c(all_nodes);
LISTADO_SETUP = cell(7,n_setup);

for sets = 1:n_setup
    LISTA_GRL = LISTA_GRL_tot;
    if n_setup>1
        eval(['setup_nodes = PROJECT_OSP.geometry.Setup_',int2str(sets),';']);
        setup_nodes = [setup_nodes(:), zeros(length(setup_nodes),3)];
        [isMember,indices] = ismember(setup_nodes(:,1), all_nodes(:,1));
        setup_nodes(:,2:4) = all_nodes(indices,2:4);       
        [dof_setup,nodes_setup,dir_setup] = dof_conv_2(setup_nodes, PROJECT_OSP.geometry.sensors, PROJECT_OSP.geometry.nodes);
    else
        existsCandidateDOFs = PROJECT_OSP.config.SAP2000_groups.existsCandidateDOFs;
        if existsCandidateDOFs
            aux = PROJECT_OSP.geometry.candiateNodes;
        else
            aux = PROJECT_OSP.geometry.candiateNodes_Setups;
        end
        candidates = zeros(length(aux), 4);
        candidates(:,1) = aux;
        [isMember,indices] = ismember(candidates(:,1), all_nodes(:,1));
        candidates(:,2:4) = all_nodes(indices,2:4);
        [dof_setup,nodes_setup,dir_setup] = dof_conv_2(candidates, PROJECT_OSP.geometry.sensors, PROJECT_OSP.geometry.nodes);
    end
    pos_ref_in_setup = [];
    if ~isempty(gdl_ref)
        for i=1:length(gdl_ref)
            if ~ismember(gdl_ref(i), dof_setup)
                dof_setup = [dof_setup,gdl_ref(i)];
                nodes_setup = [nodes_setup, References(i,1)];
                dir_setup = [dir_setup,dir_ref(i)];
            end
        end
        
        [dof_setup,ia,ic] = unique(dof_setup);
        nodes_setup = nodes_setup(ia);
        dir_setup = dir_setup(ia);
        
        clear pos_ref_in_setup
        for ijijij = 1:numel(gdl_ref)
            pos_ref_in_setup(ijijij) = find(dof_setup == gdl_ref(ijijij) & nodes_setup == ref(ijijij));
        end
    end
    
    % Main script
    warning ('off','all');
    Setups_OSP
    warning ('on','all');
    % ----------------------
    LISTADO_SETUP{1,sets}=[LISTA_OSP_C]; % evolution of DOF and NODE
    LISTADO_SETUP{2,sets}=[surv_DOF_C]; % evolution of DOF
    LISTADO_SETUP{3,sets}=[minED]; % evolution of minED
    LISTADO_SETUP{4,sets}=[surv_DOF_C]; % !! Same as LISTADO_SETUP{2,sets}
    LISTADO_SETUP{5,sets}=[surv_nodes_C];
    LISTADO_SETUP{6,sets}=[surv_dir];
    LISTADO_SETUP{7,sets}=[Edserie];
end

% Make all setups have the same number of iterations
min_sens = min(cellfun(@numel,LISTADO_SETUP(1,:)));
for i=1:size(LISTADO_SETUP,1)
    for j=1:size(LISTADO_SETUP,2)
        item = LISTADO_SETUP{i,j};
        nelem = numel(LISTADO_SETUP{i,j});
        LISTADO_SETUP{i,j} = item(nelem-min_sens+1:end);
    end
end

PROJECT_OSP.OSP_results.LISTADO_SETUP = LISTADO_SETUP;
end