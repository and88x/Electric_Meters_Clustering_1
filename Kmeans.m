function K_groups = Kmeans(matrix, k)
    N         = size(matrix,1);
    % inicio los centroides 
    percentages = round(100/(k+1));
    percentiles = linspace(percentages,percentages*k,k);
    centroids = prctile(matrix,percentiles);

    aux       = ones(N,1);
    K_groups  = zeros(N,1);
    % El algoritmo continuara hasta que no existan cambios en los grupos
    count = 0;
    while ~isequal(aux,K_groups) && count < 100
        count = count +1;
        aux   = K_groups;
        D     = pdist2(matrix,centroids);   % matriz de distancia hacia los centroides
        % Asigno las muestras al grupo con el centroide mas cercano
        [~, K_groups] = min(D,[],2);
        % Calculo los nuevos centroides
        for i = 1:k
            centroids(i,:) = mean(matrix(K_groups==i,:),1);
        end
    end
end