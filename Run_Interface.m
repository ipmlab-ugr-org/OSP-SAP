%% Run_Interface.m
% Main which is executed to run the OSP-SAP interface

% OSP-SAP: A MATLAB graphical user interface for optimal sensor placement using SAP2000

%%
clear
clc

addpath(genpath('Algorithms'));
addpath(genpath('Utils'));

% Path to SAP2000
PROJECT_OSP.config.SAP_Dir = 'C:\Program Files\Computers and Structures\SAP2000 23\SAP2000.exe';
% Full path to API dll
PROJECT_OSP.config.SAP_dll_Dir = 'C:\Program Files\Computers and Structures\SAP2000 23\SAP2000v1.dll';
% Target DOFs
PROJECT_OSP.config.Target_DOFs = [1,1,1];
% Max. number of DOFs allowed for K, M matrices
PROJECT_OSP.config.K_M_matrices.MaxDOFs_K_M = 10000;

OSP_GUI