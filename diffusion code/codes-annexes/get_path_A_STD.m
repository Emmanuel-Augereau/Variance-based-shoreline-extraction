% permet d'obtenir le chemin des images moyennées et de la moyenne des std
% dans un dossier

function [Variances_paths,Moyennes_paths] = get_path_A_STD(folderPath)
% Obtenez la liste de tous les fichiers dans le dossier
fileList = dir(folderPath);

% Initialisez une cellule pour stocker les chemins des fichiers correspondant
Variances_paths= {};
Moyennes_paths = {};

% Parcourez la liste des fichiers
for i = 1:length(fileList)
    % Vérifiez si le nom du fichier commence par 'Var' (en ignorant les dossiers)
    if ~fileList(i).isdir && startsWith(fileList(i).name, 'STD_')
        % Ajoutez le chemin complet du fichier à la liste
        Variances_paths{end+1} = fullfile(folderPath, fileList(i).name);
    end
    if ~fileList(i).isdir && startsWith(fileList(i).name, 'A_')
        % Ajoutez le chemin complet du fichier à la liste
        Moyennes_paths{end+1} = fullfile(folderPath, fileList(i).name);
    end
end


% Obtenir les dimensions des deux variables cellule
size1 = size(Variances_paths);
size2 = size(Moyennes_paths);

% Comparer les dimensions
if ~isequal(size1, size2)
    disp('Erreur : les deux variables cellule n ont pas les memes dimensions.');
end
end

