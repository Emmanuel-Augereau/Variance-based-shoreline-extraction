% cette fonction permet de trouver la ligne de rivage (u,v) à partir d'une
% classification "classi" en prenant des masques "zone et mask" et
% l'"angle" sur lequel se situe la plage

function [u,v] = find_border_multiangles(classi,zone,angle,mask)

% calcul l'ensemble des zones connexes et isole la deuxième plus importante,
% la première plus importante est le tour de la zone d'intérêt
zones_connexes=bwlabel(classi,4);
zone_connexe=zeros(size(zones_connexes));

[uniqueValues, ~, indices] = unique(zones_connexes(:));
occurrences = accumarray(indices, 1);
[~, indices_sort] = sort(occurrences,'descend');

if max(zones_connexes(:))>=1
    Nb_zone_max=uniqueValues(indices_sort(2));
    zone_connexe(zones_connexes==Nb_zone_max)=1;
end


[v]=[];
[u]=[];
for a=angle-20:5:angle+20

% permet d'identifier la limite inférieure de la zone connexe selon l'angle
% choisi (grâce à une rotation de l'image on va sélectionner la limite basse 
% et ensuite remettre l'image dans sa position d'origne)
angle=-a-90;

dim_img=size(classi);
img_rotated = imrotate(zone_connexe, angle);
dim_rotated=size(img_rotated);

border_rotated=zeros(dim_rotated);
mask_rotated=imrotate(mask, angle);


% érosion dans le but de ne pas isoler une frontière de la zone connexe
% causée par la limite du masque
% Créer un élément structurant 
se = strel('disk', 2); % Vous pouvez ajuster la taille du disque pour ajuster l'érosion
% Appliquer l'érosion
zone = imerode(zone, se);
zone_rotated=imrotate(zone, angle);


% calcul de l'indice de la frontière basse
for j=1:dim_rotated(2)
 index = find(img_rotated(:,j), 1, 'last');
 if ~isempty(index)
     if mask_rotated(index,j)==1 && zone_rotated(index,j)==1
         border_rotated(index,j)=1;
     end
 end
end

% rotation de l'image dans sa position d'origne + il faut rogner le zones
% noires qui se sont ajoutées
border = imrotate(border_rotated, -angle);
dim_border=size(border);
crop=uint64((dim_border-dim_img)./2);
border_croped=border(crop(1)+1:crop(1)+dim_img(1),crop(2)+1:crop(2)+dim_img(2));

% calcul des coordonnées de la ligne de rivage
[v0, u0] = find(border_croped);
v=[v;v0];
u=[u;u0];

end
end

