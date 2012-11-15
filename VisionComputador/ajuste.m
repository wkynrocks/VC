% Ajuste de rectas
clear all, close all
figure, axis([0 10 0 10]), hold on;
xy = []; n = 0; % Lista de puntos
% Bucle de captura de puntos.
disp('Boton IZQUIERDO raton para coger puntos')
disp('Boton DERECHO para terminar')
but = 1; % botton izdo del rato: 2: medio: 3: dcho
while but == 1
    [xi,yi,but] = ginput(1);
    plot(xi,yi,'ro')
    n = n+1;
    xy(:,n) = [xi;yi];
end
% Ajustamos la recta (distancias perpendiculares)
xmean=mean(xy(1,:)); ymean=mean(xy(2,:));
dx=xy(1,:)-xmean; dy=xy(2,:)-ymean;
U=[dx',dy']
mU=U'*U % matriz 2x2 momentos orden 2
[A,S,V]=svd(mU); % S matriz autovalores, A autovect.
A
%Dibujamos la recta
e=3; % longitud recta
plot(xmean,ymean,'bo') % punto del centro
line([xmean-e*A(1,1) xmean+e*A(1,1)],...
[ymean-e*A(2,1) ymean+e*A(2,1)],... % eje del menor autovalor
'Marker','.','LineStyle','-')
% (escalado por 2)
m=A(2,1)./A(1,1);
m2=-1/m;
for i=1:size(xy,1)
    %Calcula distancia a la recta
    e=longitudSegmento;
    x=[xy(1,1) xy(1,1)+e;
    %Imprime Segmento a partir del punto, dirección y longitud
    

