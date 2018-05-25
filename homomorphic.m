%% 
%Örnek veri okunur ve ekranda gösterilir.
% AT3_1m4_03.tif
% coins.png
% moon.tif

I = imread('moon.tif');
imshow(I);

%% 
%Ýlk adým giriþ görüntüsünü log alanýna dönüþtürmektir. Bundan önce de resmi kayan nokta türüne çevireceðiz.
I = im2double(I);
I = log(1 + I);

%%
%Bir sonraki adým, yüksek geçiþli filtreleme yapmaktýr. Frekans alanýnda filtreleme yapýlýr. 
% Sonuç olarak, filtrenin boyutu da görüntünün boyutuna uyacak þekilde artacaktýr.
M = 2*size(I,1) + 1;
N = 2*size(I,2) + 1;

%%
% Ardýndan, filtrelenecek olan düþük frekans bandýnýn bant geniþliðini belirleyen Gaussian için standart sapmayý seçiyoruz

sigma = 10;

%% 
% Yüksek geçiren filtre oluþturulur.
% Burada dikkat edilmesi gereken birkaç þey var. Ýlk olarak, düþük geçiþli bir filtre formüle ettik ve daha sonra yüksek geçiþli filtreyi elde etmek için 1'den çýkardýk. 
%Ýkincisi, bu sýfýr frekansýn merkezde olduðu ortalanmýþ bir filtredir.

[X, Y] = meshgrid(1:N,1:M);  % Üç boyutlu çizim yapmak için, meshgrid fonksiyonunu kullanmamýz gerekiyor.
centerX = ceil(N/2);  % ceil komutu ise parametre olarak verilen sayýyý kendisinden büyük en küçük tamsayýya yuvarlar
centerY = ceil(M/2); 
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*sigma.^2));
H = 1 - H; 

%%
imshow(H,'InitialMagnification',25)

%% 
% Filtreyi, fftshift kullanarak merkezsiz biçimde yeniden düzenleyebiliriz
% Ekranda bir nokta belirir.

H = fftshift(H);

%% 
%Ardýndan, log-dönüþtürülmüþ görüntüyü frekans alanýnda süzgeçten geçiriyoruz. 
%Ýlk olarak, log-dönüþtürülmüþ görüntünün FFT'sini , dolgulu görüntünün büyüklüðünden geçmemizi saðlayan fft2 sözdizimini kullanarak sýfýr doldurma ile hesaplýyoruz . 
%Sonra yüksek geçiþli filtreyi uygulayýp ters-FFT'yi hesaplýyoruz. Son olarak, resmi orijinal kaplanmamýþ boyutta tekrar kýrpýyoruz.
If = fft2(I, M, N);
Iout = real(ifft2(H.*If));
Iout = Iout(1:size(I,1),1:size(I,2));

%% 
% Son adým, log-dönüþümü tersine çevirmek ve homomorfik filtrelenmiþ görüntüyü elde etmek için üstel fonksiyonun uygulanmasýdýr.
Ihmf = exp(Iout) - 1;

%%
% Orijinal ve homomorfik filtrelenmiþ görüntülere birlikte bakalým. Orijinal görüntü solda ve filtrelenmiþ görüntü saðda. 
%Ýki görüntüyü karþýlaþtýrýrsanýz, soldaki görüntüdeki aydýnlatmadaki kademeli deðiþimin saðdaki görüntüde büyük ölçüde düzeltildiðini görebilirsiniz.

imshowpair(I, Ihmf, 'montage')
