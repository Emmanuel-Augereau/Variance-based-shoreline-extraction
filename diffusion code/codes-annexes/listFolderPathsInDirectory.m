function folderPaths = listFolderPathsInDirectory()
    % Ouvre une boîte de dialogue pour sélectionner un dossier
    directory = uigetdir(pwd,'sélection le dossier où les dossiers contenant les images moyennées sont contenus');
    
    % Vérifie si l'utilisateur a annulé la sélection
    if directory == 0
        disp('Sélection de dossier annulée.');
        folderPaths = {};
        return;
    end
    
    % Liste tous les fichiers et dossiers dans le dossier sélectionné
    items = dir(directory);
    
    % Filtre les résultats pour ne garder que les dossiers (pas les fichiers)
    % Exclut aussi les dossiers spéciaux '.' et '..'
    isFolder = [items.isdir] & ~ismember({items.name}, {'.', '..'});
    folderNames = {items(isFolder).name};
    
    % Construit les chemins complets pour chaque dossier
    folderPaths = fullfile(directory, folderNames);
    
    % Affiche les chemins complets des dossiers
    disp('Les chemins des dossiers dans le dossier sélectionné sont :');
    disp(folderPaths);
end
