function A = hough2( imgName, umbralMod, minVotosRecta )

%Calcula el gradiente, los bordes y los angulos del gradiente
img=imread(imgName);
mask=fspecial('sobel');
gradh = imfilter(img,mask,'replicate');
gradv = imfilter(img,mask','replicate');
grad = abs(gradh)+abs(gradv);
bordes=(umbralMod<=grad);
%bordes = im2bw(grad,umbralMod/255);
%bordes=edge(img,'sobel',umbralMod/255);
angulos=atan2(-double(gradh),double(gradv));
[alto,ancho]=size(img);

%Convierte angulos de (-pi,pi) a (0,360)
negativos=(angulos<0);
angulos=angulos+(negativos.*2.*pi);
angulos=round(angulos.*180./pi);


%Calcula el Tao maximo, que para implementarse se dobla, Theta maximo a la
%que se le suma 1 

maxTao = floor(norm([ancho alto]));
maxTheta = 360;
maxTao2=maxTao*2+1;
maxTheta2=maxTheta+1;

%Crea Acumulador
A=zeros(maxTao2,maxTheta2);

%Rellena el acumulador resolviendo la ecuación del enunciado añadiendo la
%diagonal por los índices

for x=1:ancho,
    for y = 1:alto,
        if bordes(x,y)==1
            theta=angulos(x,y);
            tao=floor(x*cosd(theta)+y*sind(theta));
            A(maxTao+tao,theta+1)=A(maxTao+ tao,theta+1)+1;
        end
    end
end

%Crea la matriz para las rectas
%rectas=zeros(ancho,alto);

%Busco máximo con el valor y coordenadas
[votos, location]=max(A(:));
[tao theta]= ind2sub(size(A),location);

if tao>maxTao
    rtao=tao-maxTao;
else
    rtao=tao;
end
rtheta=theta-1;

subplot(2,2,4),axis([1 ancho 1 alto]),title('Rectas detectadas'),hold on;

%Hasta que alcance el límite de votos busca recta
while votos>minVotosRecta,
    %Pinta recta en el caso de que sea alfa =0 y en el resto de casos
    if (rtheta==0 || rtheta==180)
        %y=zeros(alto,alto);
        x=rtao;
        %for qq =1:alto
        %    y(qq,tao-maxTao)=x;
        %end
        %hold on;
        %subplot(2,2,4),imshow(y) ,title('Rectas detectadas');
        
        % el valor de x=25 puede variar a gusto, pero que sean enteros
        x1=[x x];
        y=[1, alto];
        %hold on;
        %subplot(2,2,4)
        %plot(x1,y)
        %title('Recta // Eje Y')
        %xlabel(['x= ',int2str(x1(1))])
        %ylabel('EJE Y')
        line(x1,y,'Color','r','Marker','.','LineStyle','-');

    else
        m=-cos(rtheta)/sind(rtheta);
        b=rtao/sind(rtheta);
        x=1:1:ancho;
        y=m*x+b;
        %for i=1:alto
        %    if(y(i)<1)||(y(i)>ancho)
        %        y(i)=0;
        %    end
        %end
        
        line(x,y,'Color','b','Marker','.','LineStyle','-');
        
    end
   
    
    %Calcula límites del punto para una mascara de 5x5, luego la usa para
    %borrar las celdas contiguas
    
    lizq=tao-1;
    if lizq>2
        lizq=2;
    end
    labajo=theta-1;
    if labajo>2
        labajo=2;
    end
    lder=maxTao2-tao;
    if lder>2
        lder=2;
    end
    larriba=maxTheta2-theta;
    if larriba>2
        larriba=2;
    end
    
    z=zeros(5);
    A(tao-lizq:tao+lder,theta-labajo:theta+larriba)=z(1:1+lizq+lder,1:1+larriba+labajo);
    
    %Recalcula el siguiente maximo
    [votos, location]=max(A(:));
    [tao theta]= ind2sub(size(A),location)
    if tao>maxTao
    rtao=tao-maxTao;
    else
    rtao=tao;
    end
    rtheta=theta-1;
end
   
%rpts = linspace(10,240,1000);   %# A set of row points for the line
%cpts = linspace(10,240,1000);   %# A set of column points for the line
%index = sub2ind([alto ancho],round(rpts),round(cpts));  %# Compute a linear index
%img(index) = 255;               %# Set the line points to white
%imshow(img);                    %# Display the image

subplot(2,2,1),imshow(img),title('Imagen original');
subplot(2,2,2),imshow(grad),title('Imagen gradiente');
subplot(2,2,3),imshow(bordes),title('Imagen umbralizada');
%subplot(2,2,4),imshow(),title('Rectas detectadas');

end


