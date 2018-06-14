%By: Juncheng Li;
%Date: 2018/03/21;
%Contact: jlicv@connect.ust.hk;
%Purpose: Check if correlation matrix can perform cholesky factorization.
%Input: Sequences of rho;
%Output: Txt file, in which the correlation matrix will be displayed.

%Sample Output Format:
% Correlation Matrix:
% 1.00 0.00 -0.50 0.00
% 0.00 1.00 -0.90 -0.50
% -0.50 -0.90 1.00 0.60
% 0.00 -0.50 0.60 1.00
% rho_x1_x2:0.00;
% rho_u1_u2:0.60;
% rho_x2_u1:-0.90;
% rho_x1_u2:0.00;
% rho_x1_u1:-0.50;
% rho_x2_u2:-0.50;
% Chol. ftz. Failed, Matrix must be positive definite..
% Eigenvalue of the matrix sigma = -0.05 0.54 1.09 2.42
%%
%Section1:The cholesky factorization test;
OutputFolder = 'C:\\Spring 2018-HKUST\\Code-Progress-0422\\Diagnosis_Toolbox\\Chol_Outputs\\';
Rho_Table_Folder = 'C:\\Spring 2018-HKUST\\Code-Progress-0422\\Risk_Profile\\Rho_Table\\';
%Order of the rho_sequence:
%rhox_1x_2
%rhou_1u_2
%rhou_1x_2
%rhou_2x_1
%rhox_1u_1
%rhox_2u_2

rho_seriesx_1x_2 = 0;
rho_seriesu_1u_2 = -0.6:0.1:0.6;
rho_seriesu_1x_2 = 0.1;
rho_seriesu_2x_1 = 0;
rhox_1u_1 = -0.5;
rhox_2u_2 = -0.5;

rlx_1x_2 = length(rho_seriesx_1x_2);
rlu_1u_2 = length(rho_seriesu_1u_2);
rlu_1x_2 = length(rho_seriesu_1x_2);
rlx_1u_2 = length(rho_seriesu_2x_1);
rlx_1u_1 = length(rhox_1u_1);
rlx_2u_2 = length(rhox_2u_2);
table_rho = rho_table_formulation(rho_seriesx_1x_2,rho_seriesu_1u_2,rho_seriesu_1x_2,rho_seriesu_2x_1,rhox_1u_1,rhox_2u_2);

chol_flag = zeros(height(table_rho),1);
output_path_string = sprintf('%schol_test_report_%s.txt',OutputFolder,datestr(now,'yyyy-mm-dd HH-MM-SS'));
fID = fopen(output_path_string,'wt');
Failtimes = 0;
Successtimes = 0;

for i = 1:height(table_rho)
    fprintf(fID,'Correlation Matrix:\n');
    sigma = [1 table_rho.rhox_1x_2(i) table_rho.rhox_1u_1(i) table_rho.rhou_2x_1(i);...
        table_rho.rhox_1x_2(i) 1 table_rho.rhou_1x_2(i) table_rho.rhox_2u_2(i);...
        table_rho.rhox_1u_1(i) table_rho.rhou_1x_2(i) 1 table_rho.rhou_1u_2(i);...
        table_rho.rhou_2x_1(i) table_rho.rhox_2u_2(i) table_rho.rhou_1u_2(i) 1];
    fprintf(fID,'%3.2f %3.2f %3.2f %3.2f\n',sigma);
    parameters_array = {'rho_x1_x2'...
        'rho_u1_u2','rho_x2_u1','rho_x1_u2','rho_x1_u1','rho_x2_u2';...
        table_rho.rhox_1x_2(i),table_rho.rhou_1u_2(i),table_rho.rhou_1x_2(i),table_rho.rhou_2x_1(i),table_rho.rhox_1u_1(i),table_rho.rhox_2u_2(i)};
    para_string = sprintf('%s:%3.2f;\n',parameters_array{:});
    fprintf(fID,para_string);
    try
        chol(sigma);
        fprintf(fID,'Chol. ftz. Succeeded.\n');
        chol_flag(i) = 1;
        Successtimes = Successtimes+1;
        fprintf(fID,'---------------------------\n');
    catch ME
        fprintf(fID,'Chol. ftz. Failed, %s.\n',ME.message);
        chol_flag(i) = -1;
        Failtimes = Failtimes+1;
        sigma_eigenvalue = eig(sigma);
        eigen_string = sprintf('Eigenvalue of the matrix sigma = %4.2f %4.2f %4.2f %4.2f\n',sigma_eigenvalue);
        fprintf(fID,eigen_string);
        fprintf(fID,'---------------------------\n');
        continue;
    end
end
count_string = sprintf('Successtimes = %d, Failuretimes = %d, Totaltimes = %d.',Successtimes,Failtimes,rlx_1x_2*rlu_1u_2*rlu_1x_2*rlx_1u_2*rlx_1u_1*rlx_2u_2);
fprintf(fID,count_string);
fclose(fID);
table_join = horzcat(table_rho,table(chol_flag));
table_rho_chol_success = table_rho(table_join.chol_flag == 1,:);
table_rho_chol_fail = table_rho(table_join.chol_flag == -1,:);
%%
Corridor_gbm = @(rhox_1x_2,rhou_1u_2,rhou_1x_2,rhou_2x_1,rhox_1u_1,rhox_2u_2) CorrdiorVariance_GBM(3,1.3,10000,rhox_1x_2,rhou_1u_2,rhou_1x_2,rhou_2x_1,rhox_1u_1,rhox_2u_2);
gbm_out = rowfun(Corridor_gbm,table_rho_chol_success,'OutputVariableName',{'var_estimate' 'err' 'time'});
table_gbm_output = horzcat(gbm_out,table_rho_chol_success);
%%
Corridor_qlv = @(rhox_1x_2,rhou_1u_2,rhou_1x_2,rhou_2x_1,rhox_1u_1,rhox_2u_2) CorrdiorVariance_QLV(3,1.3,10000,rhox_1x_2,rhou_1u_2,rhou_1x_2,rhou_2x_1,rhox_1u_1,rhox_2u_2);
qlv_out = rowfun(Corridor_qlv,table_rho_chol_success,'OutputVariableName',{'var_estimate' 'err' 'time'});
table_qlv_output = horzcat(qlv_out,table_rho_chol_success);
%%


