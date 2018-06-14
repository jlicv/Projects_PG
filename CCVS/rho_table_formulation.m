function[table_r] = rho_table_formulation(rho_seriesx_1x_2,rho_seriesu_1u_2,rho_seriesu_1x_2,rho_seriesu_2x_1,rhox_1u_1,rhox_2u_2)
%Section2: The CCVS rho parameters example.
% rho_seriesx_1x_2 = -0.9:0.1:0.9;
% rho_seriesu_1u_2 = 0;
% rho_seriesu_1x_2 = 0;
% rho_seriesu_2x_1 = 0;
% rhox_1u_1 = -0.5;
% rhox_2u_2 = -0.5;

%'1':Number of rows;
%'2':Number of columns;
rlx_1x_2 = size(rho_seriesx_1x_2',1);
rlu_1u_2 = size(rho_seriesu_1u_2',1);
rlu_1x_2 = size(rho_seriesu_1x_2',1);
rlx_1u_2 = size(rho_seriesu_2x_1',1);

rlx_1u_1 = size(rhox_1u_1',1);
rlx_2u_2 = size(rhox_2u_2',1);
[r1,r2,r3,r4,r5,r6] = ndgrid(1:rlx_1x_2,1:rlu_1u_2,1:rlu_1x_2,1:rlx_1u_2,1:rlx_1u_1,1:rlx_2u_2);

%Subsetting rho vector columnwise, forcing the output be also a vector form.
%While next index's vector will be stored in next column, in other words,
%they are aligned along rowwise direction. As a result, the whole matrix
%should be transposed, to get the complete table.

varname = {'rhox_1x_2','rhou_1u_2','rhou_1x_2','rhou_2x_1','rhox_1u_1','rhox_2u_2'};
table_r = table(rho_seriesx_1x_2(:,r1)',rho_seriesu_1u_2(:,r2)',rho_seriesu_1x_2(:,r3)',rho_seriesu_2x_1(:,r4)',rhox_1u_1(:,r5)',rhox_2u_2(:,r6)','VariableNames',varname);

%Make a new table about the factorization outcome;
% rho_seriesx_1u_1 = repmat(rhox_1u_1,height(table_r),1);
% rho_seriesx_2u_2 = repmat(rhox_2u_2,height(table_r),1);
% table_r = vertcat(table_r,rho_seriesx_1u_1,rho_seriesx_2u_2);
end
%
% chol_flag = zeros(height(table_r),1);
% prc = chol_flag;
% time = chol_flag;
% err = chol_flag;
% table_output = table(chol_flag,prc,time,err);
% vertcat