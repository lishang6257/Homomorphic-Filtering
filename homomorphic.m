%% 
%�rnek veri okunur ve ekranda g�sterilir.
% AT3_1m4_03.tif
% coins.png
% moon.tif

I = imread('moon.tif');
imshow(I);

%% 
%�lk ad�m giri� g�r�nt�s�n� log alan�na d�n��t�rmektir. Bundan �nce de resmi kayan nokta t�r�ne �evirece�iz.
I = im2double(I);
I = log(1 + I);

%%
%Bir sonraki ad�m, y�ksek ge�i�li filtreleme yapmakt�r. Frekans alan�nda filtreleme yap�l�r. 
% Sonu� olarak, filtrenin boyutu da g�r�nt�n�n boyutuna uyacak �ekilde artacakt�r.
M = 2*size(I,1) + 1;
N = 2*size(I,2) + 1;

%%
% Ard�ndan, filtrelenecek olan d���k frekans band�n�n bant geni�li�ini belirleyen Gaussian i�in standart sapmay� se�iyoruz

sigma = 10;

%% 
% Y�ksek ge�iren filtre olu�turulur.
% Burada dikkat edilmesi gereken birka� �ey var. �lk olarak, d���k ge�i�li bir filtre form�le ettik ve daha sonra y�ksek ge�i�li filtreyi elde etmek i�in 1'den ��kard�k. 
%�kincisi, bu s�f�r frekans�n merkezde oldu�u ortalanm�� bir filtredir.

[X, Y] = meshgrid(1:N,1:M);  % �� boyutlu �izim yapmak i�in, meshgrid fonksiyonunu kullanmam�z gerekiyor.
centerX = ceil(N/2);  % ceil komutu ise parametre olarak verilen say�y� kendisinden b�y�k en k���k tamsay�ya yuvarlar
centerY = ceil(M/2); 
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*sigma.^2));
H = 1 - H; 

%%
imshow(H,'InitialMagnification',25)

%% 
% Filtreyi, fftshift kullanarak merkezsiz bi�imde yeniden d�zenleyebiliriz
% Ekranda bir nokta belirir.

H = fftshift(H);

%% 
%Ard�ndan, log-d�n��t�r�lm�� g�r�nt�y� frekans alan�nda s�zge�ten ge�iriyoruz. 
%�lk olarak, log-d�n��t�r�lm�� g�r�nt�n�n FFT'sini , dolgulu g�r�nt�n�n b�y�kl���nden ge�memizi sa�layan fft2 s�zdizimini kullanarak s�f�r doldurma ile hesapl�yoruz . 
%Sonra y�ksek ge�i�li filtreyi uygulay�p ters-FFT'yi hesapl�yoruz. Son olarak, resmi orijinal kaplanmam�� boyutta tekrar k�rp�yoruz.
If = fft2(I, M, N);
Iout = real(ifft2(H.*If));
Iout = Iout(1:size(I,1),1:size(I,2));

%% 
% Son ad�m, log-d�n���m� tersine �evirmek ve homomorfik filtrelenmi� g�r�nt�y� elde etmek i�in �stel fonksiyonun uygulanmas�d�r.
Ihmf = exp(Iout) - 1;

%%
% Orijinal ve homomorfik filtrelenmi� g�r�nt�lere birlikte bakal�m. Orijinal g�r�nt� solda ve filtrelenmi� g�r�nt� sa�da. 
%�ki g�r�nt�y� kar��la�t�r�rsan�z, soldaki g�r�nt�deki ayd�nlatmadaki kademeli de�i�imin sa�daki g�r�nt�de b�y�k �l��de d�zeltildi�ini g�rebilirsiniz.

imshowpair(I, Ihmf, 'montage')
