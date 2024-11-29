%détection de la ligne de rivage par analyse de mouvement

function [u,v] = detect_shoreline_std(STD,zone,angle,mask)
STD(~zone)=NaN;

% calcul du seuil de mouvement
thresh = find_tresh(STD);

% classification zone de mouvement/zone stable
classi=zeros(size(STD));
classi(STD>thresh)=1;

% détection de la ligne de rivage à partir de la classification
%[u,v] = find_border(classi,zone,angle,mask);
[u,v] = find_border_multiangles(classi,zone,angle,mask);
end

