% code pour générer des images moyennées et les images de variance pour une 
% liste de vidéos (ie: 1
% image/vidéo)
clear all

% charger la zone d'intérêt (éviter d'enregistrer des mouvements en dehors
% de la zone intertidale) -> calcul de cette zone avec la fonction
% calculate_zone_mask
load('zoneBS.mat')

%%%%%%%%%


% selection du dossier contenant les fichiers vidéos
[pathVideos, fullpathVideos1] = listVideosAutoRec(); % arborescence de l'enregistrement automatique

output = uigetdir(pwd,'Selection du dossier où les images moyennées sont rangées');


%averaging
nv=length(fullpathVideos1);


% calcul de la date des vidéos sélectionnées
date=cell(1,nv);
for i=1:nv
    path=char(fullpathVideos1{i});
    date{i}=datenum(path(:,[end-23:end-20 end-19:end-18 end-17:end-16 end-14:end-13 end-12:end-11 end-10:end-9]),'yyyymmddhhMMSS');% recupere la date
end


%moyennage et calcul de la médianes des std
parfor i=1:nv
%accès au chemin de la vidéo
path=char(fullpathVideos1{i});

%conversion en .mp4 pour lire la video avec le VideoReader
% création d'une vidéo temporaire
temp_name=strcat('temp',num2str(i),'.mp4');
command=['ffmpeg -i ',path,' -codec copy ',temp_name];
system(command);

% ouverture de la vidéos
frameid=0;
video=VideoReader(temp_name);
nbim=floor(video.Duration*video.FrameRate);

% T : durée de la tranche sur laquelle les std de la couleur des pixels
% sont caculés
T=30;
nbimT=floor(T*video.FrameRate);
nbl=floor(nbim/nbimT);

%moyennage
A1=read(video,1);

% ne pas traiter les vidéos en niveaux de gris
if ~isequal(A1(:,:,1), A1(:,:,2)) && ~isequal(A1(:,:,1), A1(:,:,3))
[n,m,c]=size(A1);
Amoy_tot=zeros(n,m,c);
Lst_STD=zeros(n,m,nbl);

% calcul des STD et de la moyenne par tranche
for j=0:nbl-1
    Amoy=zeros(n,m,c);
    A_quad=zeros(n,m);
    for k=1:nbimT
        A=read(video,j*nbimT+k);
        Amoy = Amoy+double(A);
        A_quad = A_quad+mean(double(A),3).^2;
    end
    Amoy=Amoy./nbimT;
    A_quad=A_quad./nbimT;
    Var=A_quad-mean(Amoy,3).^2;
    Var(Var<=0)=0;
    Amoy_tot=Amoy_tot+Amoy;
    Lst_STD(:,:,j+1)=sqrt(Var);
end

% supression de la vidéo temporaire
delete(temp_name)


% calcul de la moyenne totale et de la médiane des STD, mise en format pour
% l'enregistrement en .jpg
Amoy_tot=Amoy_tot./nbl;
STD=median(Lst_STD,3);

STD(~mask)=0;
STD=STD./max(STD(:))*255;


Amoy_tot(find(Amoy_tot>255))=255;
Amoy_tot(find(Amoy_tot<0))=0;
Amoy_tot = uint8(Amoy_tot);

STD(find(STD>255))=255;
STD(find(STD<0))=0;
STD = uint8(STD);


% séparer les images en fonction des jours d'acquisition
dateString = datestr(date{i},'yyyymmdd');
dateFolder = fullfile(output, dateString);

if ~exist(dateFolder, 'dir')
    mkdir(dateFolder);
end


%enregistrement en .jpg de l'image moyennée 'A', l'image initiale 'I' et de
%la médiane des std 'STD'
imwrite(Amoy_tot,[dateFolder,'/A_',datestr(date{i},'yyyymmddHHMMSS'),'.jpg'],'jpg','Quality',100);
imwrite(A1,[dateFolder,'/I_',datestr(date{i},'yyyymmddHHMMSS'),'.jpg'],'jpg','Quality',100);
imwrite(STD,[dateFolder,'/STD_',datestr(date{i},'yyyymmddHHMMSS'),'.jpg'],'jpg','Quality',100);
else
delete(temp_name)
end
end






