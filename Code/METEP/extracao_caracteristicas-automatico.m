# Extracao de caracteristicas para o artigo de METEP

pkg load image;

function extraiCaracteristicas (iteracao)
  disp(["Lendo imagem " iteracao]);
  imagemOriginal = imread(["../../Dataset/VIS_Onboard/VIS_Onboard_frames/MVI_0790_VIS_OB_frameC" iteracao ".jpg"]);
  imagemGT = imread(["../SMD-Frames-GT-Generation/GTC" iteracao ".jpeg"]);
  
  nomeArquivo = ["dados" iteracao ".csv"];
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

  % Extração das características
  disp("Extraindo características");
  for i = 11:(lin+10)
    disp("Linha ");
    disp(i);
    for j = 11:(col+10)
      % Cria parte 10x10 da imagem
      boxR = listaIntensityR(i-4:i+5, j-4:j+5);
      boxG = listaIntensityG(i-4:i+5, j-4:j+5);
      boxB = listaIntensityB(i-4:i+5, j-4:j+5);
      
      % Calcula mean
      mR = mean2(boxR);
      #listaMeanR(i,j) = mR;
      mG = mean2(boxG);
      #listaMeanG(i,j) = mG;
      mB = mean2(boxB);
      #listaMeanB(i,j) = mB;
      
      % Calcula standard deviation
      sdR = std2(boxR);
      #listaStaDevR(i,j) = sdR;
      sdG = std2(boxG);
      #listaStaDevG(i,j) = sdG;
      sdB = std2(boxB);
      #listaStaDevB(i,j) = sdB;
      
      # Calcula entropy
      enR = entropy(boxR);
      #listaEntropyR(i,j) = enR;
      enG = entropy(boxG);
      #listaEntropyG(i,j) = enG;
      enB = entropy(boxB);
      #listaEntropyB(i,j) = enB;
      
      % Calcula smoothness
      smR = 1 - (1/(1+var(boxR(:))));
      smG = 1 - (1/(1+var(boxG(:))));
      smB = 1 - (1/(1+var(boxB(:))));
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
      
      caracteristicas = [listaIntensityR(i,j), listaIntensityG(i,j), listaIntensityB(i,j), mR, mG, mB, sdR, sdG, sdB, enR, enG, enB, smR, smG, smB, cor];
      csvwrite(nomeArquivo, caracteristicas, "-append");
    endfor
  endfor
  disp("======================");
endfunction

#disp(listaMean);
#for k = 1:23
#  extraiCaracteristicas(num2str(k));
#endfor

extraiCaracteristicas("3");