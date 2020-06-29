# Extracao de caracteristicas para o artigo de METEP

pkg load image;

function extraiCaracteristicas (iteracao)
  disp(["Lendo imagem " iteracao]);
  imagemOriginal = imread(["../../Dataset/VIS_Onboard/VIS_Onboard_frames/MVI_0788_VIS_OBR_frame" iteracao ".jpg"]);
  imagemGT = imread(["../../Dataset/VIS_Onboard/HorizonGT/GTImages/MVI_0788_VIS_OB_GT" iteracao ".jpg"]);
  
  nomeArquivo = ["MVI_0788_VIS_OBR_frame" iteracao ".csv"];
  imagem = padarray(imagemOriginal, [10, 10], "replicate"); % Colocando borda replicando valores
  lin = 225; % num de linhas das imagens
  col = 400; % num de colunas das imagens

  cabecalho = [["intensityR"], ["intensityG"], ["intensityB"], ["meanR"], ["meanG"], ["meanB"], ["sdR"], ["sdG"], ["sdB"], ["entropyR"], ["entropyG"], ["entropyB"], ["smoothnessR"], ["smoothnessG"], ["smoothnessB"], ["classe"]];
  #cabecalho = [["intensityR"], ["intensityG"], ["intensityB"], ["meanR"], ["meanG"], ["meanB"], ["sdR"], ["sdG"], ["sdB"], ["entropyR"], ["entropyG"], ["entropyB"], ["smoothnessR"], ["smoothnessG"], ["smoothnessB"], ["thirdmomentR"], ["thirdmomentG"], ["thirdmomentB"], ["classe"]];
  csvwrite( nomeArquivo, cabecalho, "-append");

  % Estruturas de armazenamentos das características
  disp("Criando estruturas de armazenamentos das características");
  listaIntensityR = imagem(:,:,1);
  listaIntensityG = imagem(:,:,2);
  listaIntensityB = imagem(:,:,3);
  
  dados = zeros((lin * col), 16);

  % Extração das características
  disp("Extraindo características");
  for i = 11:(lin+10)
    disp("Linha ");
    disp(i);
    for j = 11:(col+10)
      % Posicao (linha) na matriz
      posicao = ((i - 11) * col) + (j - 10);
      
      % Cria parte 10x10 da imagem
      boxR = listaIntensityR(i-4:i+5, j-4:j+5);
      boxG = listaIntensityG(i-4:i+5, j-4:j+5);
      boxB = listaIntensityB(i-4:i+5, j-4:j+5);
      
      dados(posicao,1) = listaIntensityR(i,j);
      dados(posicao,2) = listaIntensityG(i,j);
      dados(posicao,3) = listaIntensityB(i,j);
      
      % Calcula mean
      dados(posicao,4) = mean2(boxR);
      #listaMeanR(i,j) = mR;
      dados(posicao,5) = mean2(boxG);
      #listaMeanG(i,j) = mG;
      dados(posicao,6) = mean2(boxB);
      #listaMeanB(i,j) = mB;
      
      % Calcula standard deviation
      dados(posicao,7) = std2(boxR);
      #listaStaDevR(i,j) = sdR;
      dados(posicao,8) = std2(boxG);
      #listaStaDevG(i,j) = sdG;
      dados(posicao,9) = std2(boxB);
      #listaStaDevB(i,j) = sdB;
      
      # Calcula entropy
      dados(posicao,10) = entropy(boxR);
      #listaEntropyR(i,j) = enR;
      dados(posicao,11) = entropy(boxG);
      #listaEntropyG(i,j) = enG;
      dados(posicao,12) = entropy(boxB);
      #listaEntropyB(i,j) = enB;
      
      % Calcula smoothness
      dados(posicao,13) = 1 - (1/(1+var(boxR(:))));
      dados(posicao,14) = 1 - (1/(1+var(boxG(:))));
      dados(posicao,15) = 1 - (1/(1+var(boxB(:))));
      #disp(smR);
      
      % Calcula Third moment (assimetria)
      #tmR = skewness(boxR);
      #tmG = skewness(boxG);
      #tmB = skewness(boxB);
      #disp(tmR);
      
      % Classe do ixel
      cor = 1; #branco
      if(imagemGT(i-10, j-10) < 5)
        cor = 0; #reo
      endif
      dados(posicao,16) = cor;
    endfor
  endfor
  csvwrite(nomeArquivo, dados, "-append");
  disp("======================");
endfunction

controler = 20;
for k = 1:14
  extraiCaracteristicas(num2str(controler));
  controler = controler + 20;
endfor

#extraiCaracteristicas("219");