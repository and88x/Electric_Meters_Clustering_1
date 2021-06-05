clear all
close all

load 'A:\Programacion\MATLAB\Freelancer\Medidores clustering\wholedata.mat'
matrix(find(sum(isnan(matrix),2)),:) = [];
%%
[coeff,score,latent] = pca(matrix);
D = squareform(pdist(matrix));
N = length(D);

D2 = squareform(pdist(score));
N2 = length(D2);

clc
%% KNN
numero_de_pruebas_Knn = 10;
p.n_cluster           = round(linspace(1, 20, numero_de_pruebas_Knn)); 
knn_groups            = zeros(N,numero_de_pruebas_Knn);

for i = 1:numero_de_pruebas_Knn
    knn_groups(:,i) = knn(matrix, p.n_cluster(i));
end

p.algorithm = ' k-nearest neighbors';
p.labels    = knn_groups;
p.scores    = score(:,1:2);
p.dataset   = matrix;

generate_graphs(p);

%% Hierarchical clustering
numero_de_pruebas_H = 10;
h_groups = zeros(N,numero_de_pruebas_H);
for i = 2:numero_de_pruebas_H+1
    [groups, ~]     = hierarchical(D2, i);
    h_groups(:,i-1) = groups;
end

p.algorithm = ' Hierarchical Clustering';
p.labels    = h_groups;
p.scores    = score(:,1:2);
p.dataset   = score;%matrix;
p.n_cluster = 2:numero_de_pruebas_H+1;

generate_graphs(p);


%% DBSCAN
numero_de_pruebas_D = 10;

percentages = round(100/(numero_de_pruebas_D+1));
percentiles = linspace(percentages,percentages*numero_de_pruebas_D,numero_de_pruebas_D);
epsilons    = prctile(unique(D2),percentiles);

minPts      = 3;
d_groups    = zeros(N,numero_de_pruebas_D);
p.n_cluster = zeros(1, numero_de_pruebas_D);

for i = 1:numero_de_pruebas_D
    d_groups(:,i)  = DBSCAN(D2, epsilons(i), minPts);
    p.n_cluster(i) = length(unique(d_groups(:,i)));
end

p.algorithm = ' DBSCAN Clustering';
p.labels    = d_groups;
p.scores    = score(:,1:2);
p.dataset   = score;%matrix;

generate_graphs(p);

%% Kmeans
numero_de_pruebas_K = 10;
p.n_cluster         = 2:numero_de_pruebas_K+1;
K_groups            = zeros(N,numero_de_pruebas_D);

for i = 1:numero_de_pruebas_K
    K_groups(:,i) = Kmeans(score, p.n_cluster(i));
end

p.algorithm = ' Kmeans Clustering';
p.labels    = K_groups;
p.scores    = score(:,1:2);
p.dataset   = score;%matrix;

generate_graphs(p);

%% Spectral Clustering
numero_de_pruebas_S = 10;
p.n_cluster         = 3:numero_de_pruebas_S+2; 
knn                 = 5; 
S_groups            = zeros(N,numero_de_pruebas_S);

for i = 1:numero_de_pruebas_S
    S_groups(:,i) = spectral_clustering(matrix, p.n_cluster(i), knn);
end

p.algorithm = ' Spectral Clustering';
p.labels    = S_groups;
p.scores    = score(:,1:2);
p.dataset   = matrix;%;

generate_graphs(p);