# Extracao de caracteristicas para tCC

pkg load image;

iteracao = "0";
imagemOriginal = imread(["../SMD-Frames-GT-Generation/GTC" iteracao ".jpeg"]);
lin = 225; % num de linhas das imagens
col = 400; % num de colunas das imagens

#disp(imagemOriginal(104,:));

nomeArquivo = ["gt" iteracao ".csv"];
cabecalho = ["classe"];
csvwrite(nomeArquivo, cabecalho, "-append");

# disp(size(imagemOriginal));

for i = 1:lin
  disp("Linha ");
  disp(i);
  for j = 1:(col)
    cor = "1";
    if(imagemOriginal(i, j) < 5)
      cor = "0";
    endif
   csvwrite(nomeArquivo, cor, "-append");
  endfor
endfor

#for j = 1:(col)
#  cor = 1;
#  if(imagemOriginal(104, j) < 5)
#    cor = 0;
#    disp("=======");
#    disp(j);
#    disp(cor);
#    disp(imagemOriginal(104, j));
#  endif
#endfor