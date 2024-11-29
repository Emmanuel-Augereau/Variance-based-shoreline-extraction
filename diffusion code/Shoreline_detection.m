% Ce code permet de détecter la ligne de rivage sur les images moyennées
% et la médiane des STD
% Les données sont enregsitrées sous forme d'une image et d'un tableau
% dateUV donnant la date et l'heure à laquelle la ligne a été détectée et
% ses coordonnées pixels (u,v)

% il faut renseigner les masques "zone" et "mask" et l'angle 
% de la plage "angle" : voir si dessous

%%%%%%%%%%%%%%

clear all


% charger la zone intertidale plus un masque éventuel (pour enlever une 
% zone de rochers par exemple)
load('zonePK.mat')
%load('mask2024.mat')
zone=mask; %dans le cas ou on n'a pas de différences entre le masque et la zone...

% angle où se situe la plage (sens trigonométrique), si la plage est à
% droite de l'image et l'océan à gauche : prendre angle = 0, si la plage
% est en bas et l'océan en haut prendre angle=-90, ...
%angle=-60; %PM
angle=-160 ;%PK
%angle=0; %BS & RU
%%%%%%%%%%

% sélection le dossier où les dossiers contenant les images moyennées sont
% contenus

folderPaths = listFolderPathsInDirectory();

% selectionner le dossiers où les lignes "dateUV" sont enregistrées
output = uigetdir(pwd,'Select folder where lines are put');


%%%%%%%%%%%%%%%%
% calcul

for k=1:size(folderPaths,2)
% accès aux chemins
[STD_paths,Moyennes_paths] = get_path_A_STD(folderPaths{1,k});
nv=length(STD_paths);
date=cell(1,nv);

%calcul des dates
for i=1:nv
    path=char(Moyennes_paths{i});
    date{i}=datenum(path(:,[end-17:end-14 end-13:end-12 end-11:end-10 end-9:end-8 end-7:end-6 end-5:end-4]),'yyyymmddhhMMSS');% recupere la date
end

dateUV=cell(nv,3);
for i=1:nv
disp([k i]);
% lecture des images moyennées et de la médiane des STD
STD=imread(STD_paths{i});
Amoy=imread(Moyennes_paths{i});

%détection de la lige de rivage
[u,v] = detect_shoreline_std(STD,zone,angle,mask);
dateUV{i,1}=date{i}; dateUV{i,2}=u; dateUV{i,3}=v;


% enregistrement de l'image avec la ligne de rivage et des coordonnées sous
% la forme dateUV
figure('visible', 'off');
imagesc(Amoy);
hold on
plot(u,v,'r.', 'MarkerSize', 2);
title(datestr(date{i},'yyyymmddHHMMSS'))
title('Détection de la shoreline')
subtitle(['Date (yyyymmddHHMMSS) : ',datestr(date{i},'yyyymmddHHMMSS')])
xlabel('Axe U [pixels]')
ylabel('Axe V [pixels]')
h1=plot(NaN, NaN, 'r-','DisplayName','Médiane des STD'); % Ligne continue pour la légende

legend(h1);

f = gcf;
exportgraphics(f,[folderPaths{1,k},'/shoreline_',datestr(date{i},'yyyymmddHHMMSS'),'_',num2str(i),'.jpg'],'Resolution',600)
close(f)
end

name_out=[output '/dateUV_' datestr(date{i},'yyyymmdd') '.mat'];
save(name_out,'dateUV')
end