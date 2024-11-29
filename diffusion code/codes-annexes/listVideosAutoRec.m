function [pathVideos, fullpathVideos] = listVideosAutoRec()

%listVideos 
%
%   Opens an interactive dialog to select a folder and searches all subfolders
% (avec l'architecture de l'enregistrement automatique) for instances of .mkv 

%   [pathVideos, fullpathVideos] = listVideos();
%
%   Output
%
%   pathVideos: The select path
%
% 
%   fullpathVideos: A list with the full pathes for all videos
%

                  


    pathVideos = uigetdir(pwd,'Select folder where the videosare located');
 
    i=1;
    liste=listRep(pathVideos); %listing initial
 
    while(1)
        if i>size(liste,2) %la boucle s'arrête quand on a atteint la fin de la liste
            break;
        end
 
        if isdir(char(liste(i)))    %si c'est un dossier
            liste=[liste listRep(liste(i))]; %On liste ce dossier et on le colle à la liste déjà créée
            liste(i)=[]; %on supprime l'item en cours, c'était un nom de dossier et on ne voulait que les fichiers
        else
            i=i+1;  %si c'est un fichier, on n'y touche pas et on passe à l'item suivant
        end
    end
 
       fullpathVideos ={};
        j=1;
    for i=1:size(liste,2)
        
     
        
        if ~isempty(strfind(liste{(i)},'.mkv'))~=0 | strfind(liste{(i)},'.avi')~=0
            
             fullpathVideos {j}=liste(i);
             j=j+1;
       

        end
    end

disp([num2str(j-1), ' videos have been detected.'])


    