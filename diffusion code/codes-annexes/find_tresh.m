% calcul du seuil offrant un maximum de séparabilité des deux classes 
% ref : N. Otsu. : " a threshold selection method from grey scale histogram". IEEE
% Trans. Syst. Man Cyber., page 62–66, 1979

% Val : image binaire à seuiller
function thresh = find_tresh(Val)
n=1000;
[occurrences, nombres] = histcounts(Val,n);
seuils=(nombres(1:end-1)+nombres(2:end))./2;
pi=occurrences./sum(occurrences(:));
mut=sum(seuils.*pi);
Sb=[];

for k=1:n
    wk=sum(pi(1:k));
    muk=sum(seuils(1:k).*pi(1:k));
    sk=((mut*wk-muk)^2)/(wk*(1-wk));
    Sb=[Sb sk];
end


[~, indice_max] = max(Sb);
thresh=seuils(indice_max);
end

