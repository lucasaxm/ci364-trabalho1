#!/usr/bin/env ruby
# encoding: utf-8
require 'i18n'
# methods{
    def criaArrayChave(keyword)
        m = []
        keyword = keyword.upcase
        keyword.each_char do |c|
            if c=='J'   # => troca o 'j' pelo 'i'
                c='I'
            end
            if ! m.include? c
                m << c
            end
        end
        ("A".."Z").each do |c|
            if c=='J'   # => troca o 'j' pelo 'i'
                c='I'
            end
            if ! m.include? c
                m << c
            end
        end
        return m
    end
    
    def imprimeMatriz(m)
        i=0
        print "+ | "
        m.first.each do |b|
            print (i%10).to_s+" "
            i+=1
        end
        puts
        m.first.each do |b|
            print "- "
            i+=1
        end
        puts "- -"
        l=0
        m.each do |linha|
            print (l%10).to_s+" | "
            l+=1
            linha.each do |elemento|
                print elemento+' '
            end
            puts
        end
    end
    
    def playfair (f, m, f_cifrado)
        # puts # debug
        # puts "--- INICIO playfair ---" # debug
        f_claro = preparaEntrada(f)
        f_claro.rewind
        textocifrado = ''
        cont=0
        pos1=[]
        pos2=[]
        f_claro.each_char do |c|
            if cont==0
                # puts # debug
                pos1 = buscaMatriz(m, c)
                # puts "c= "+c.inspect # debug
                # puts "pos1= "+pos1.inspect # debug
                # puts "pos1[0]= "+pos1[0].inspect # debug
                # puts "cont= "+cont.to_s # debug
                cont+=1               
            else
                # puts # debug
                pos2 = buscaMatriz(m, c)
                # puts "c ="+c.inspect # debug
                # puts "pos2= "+pos2.inspect # debug
                # puts "pos1[0]= "+pos1[0].inspect # debug
                # puts "pos2[0]= "+pos2[0].inspect # debug
                # puts "cont= "+cont.to_s # debug
                if pos1[0] == pos2[0]
                    charCifrado1 = m[pos1[0]][(pos1[1]+1)%5]
                    charCifrado2 = m[pos2[0]][(pos2[1]+1)%5]
                elsif pos1[1] == pos2[1]
                    charCifrado1 = m[(pos1[0]+1)%5][pos1[1]]
                    # puts "charCifrado1 = m["+((pos1[0]+1)%5).to_s+"]["+pos1[1].to_s+"]" # debug
                    charCifrado2 = m[(pos2[0]+1)%5][pos2[1]]
                    # puts "charCifrado2 = m["+((pos2[0]+1)%5).to_s+"]["+pos2[1].to_s+"]" # debug
                else
                    charCifrado1 = m[pos1[0]][pos2[1]]
                    charCifrado2 = m[pos2[0]][pos1[1]]
                end
                cont=0
                textocifrado = charCifrado1+charCifrado2
                f_cifrado.write(textocifrado)
            end
        end
        f_claro.close
        # puts "--- FIM playfair ---" # debug
        # puts # debug
    end

    def desplayfair (f_playfair, m, f_decifrado)
        # puts # debug
        # puts "--- INICIO desplayfair ---" # debug
        textoDecifrado = ""
        cont=0
        pos1=[]
        pos2=[]
        f_playfair.each_char do |c|
            if cont==0
                pos1 = buscaMatriz(m, c)
                # puts "c= "+c.inspect # debug
                # puts "pos1= "+pos1.inspect # debug
                # puts "pos1[0]= "+pos1[0].inspect # debug
                # puts "cont= "+cont.to_s # debug
                cont+=1
                
            else
                pos2 = buscaMatriz(m, c)
                # puts "c ="+c.inspect # debug
                # puts "pos2= "+pos2.inspect # debug
                # puts "pos1[0]= "+pos1[0].inspect # debug
                # puts "pos2[0]= "+pos2[0].inspect # debug
                # puts "cont= "+cont.to_s # debug
                if (pos1[0] != pos2[0]) || (pos1[1] != pos2[1]) # se os caracteres n forem iguais, faz tudo.
                    if (pos1[0] == pos2[0])
                        charDecifrado1 = m[pos1[0]][(pos1[1]-1)%5]
                        charDecifrado2 = m[pos2[0]][(pos2[1]-1)%5]
                    elsif pos1[1] == pos2[1]
                        charDecifrado1 = m[(pos1[0]-1)%5][pos1[1]]
                        # puts "charDecifrado1 = m["+((pos1[0]-1)%5).to_s+"]["+pos1[1].to_s+"]" # debug
                        charDecifrado2 = m[(pos2[0]-1)%5][pos2[1]]
                        # puts "charDecifrado2 = m["+((pos2[0]-1)%5).to_s+"]["+pos2[1].to_s+"]" # debug
                    else
                        charDecifrado1 = m[pos1[0]][pos2[1]]
                        charDecifrado2 = m[pos2[0]][pos1[1]]
                    end
                    textoDecifrado = charDecifrado1.to_s+charDecifrado2.to_s    
                    # puts textoDecifrado.to_s # debug
                    f_decifrado.write(textoDecifrado)
                end
                cont=0
            end
        end
        # puts "--- FIM desplayfair ---" # debug
        # puts # debug
        return f_decifrado
    end
    
    def preparaEntrada (f)
        # puts # debug
        # puts "--- INICIO preparaEntrada ---" # debug
        strdupla=""
        strdupla[0] = f.getc
        f_novo = File.open("texto_claro.pf","w+")
        tam=0

        f.each_char do |c|
            strdupla[1] = c
            strdupla = I18n.transliterate(strdupla).gsub(/\n/,'').gsub(/[^A-Za-z]/, '').upcase
            if(strdupla.length==2)
                strdupla = strdupla.gsub(/J/,'I')
                f_novo.write(strdupla[0])
                tam+=1
                if strdupla[0]==strdupla[1]
                    f_novo.write(strdupla[0]=='X' ? 'H' : 'X')
                    tam+=1
                end
                strdupla[0]=strdupla[1]
            elsif(strdupla.size==0)
                strdupla[0] = f.getc
            end
        end
        f_novo.write(strdupla[0])
        tam+=1
        if (tam%2 != 0)
            f_novo.write(strdupla[0]=='X' ? 'H' : 'X')
        end
        f_novo.rewind
        # puts f_novo.read # debug
        # puts "--- FIM preparaEntrada ---" # debug
        # puts # debug
        return f_novo
    end

    def buscaMatriz (matriz, c)
        ret =[]
        (0..(matriz.length-1)).each do |i|
            if ! ((j=matriz[i].index(c)).nil?)
                ret = [i,j]
                break
            end
        end
        if ret.empty?
            abort "busca matriz deu pau buscando o c = "+c.inspect
        end
        return ret
    end
    
    def criaMatriz(maxlinhas, tamlinha, input)
        # puts # debug
        # puts "--- INICIO criaMatriz ---" # debug
        # puts "input: "+input.to_s # debug
        m = [] # => cria vetor base para a matriz (arg=numero de linhas)
        i=0 # => controle de linhas
        input.each do |c|   # => percorre vetor de entrada (c = elemento)
            if i<maxlinhas  # => se a matriz ainda nao esta cheia
                if m[i].nil? # => inicializa linha se precisar
                    m[i]=[]
                end
                if m[i].length<tamlinha # => se linha NAO estiver cheia, recebe mais um elemento
                    m[i] << c.upcase
                else                        # => se linha estiver cheia
                    if (i+=1)<maxlinhas
                        if m[i].nil?        # => inicializa a proxima linha (se houver)
                            m[i]=[]
                        end
                        m[i] << c.upcase    # => e insere o elemento lá
                    end
                end
            else
                break # => sai se a matriz ta cheia (mesmo que ainda tenha coisa no input)
            end
        end
        if i<maxlinhas
            if m[i].length < tamlinha
                if m[i].last=="X"
                    while m[i].length<tamlinha
                        m[i] << "H"
                    end
                else
                    while m[i].length<tamlinha
                        m[i] << "X"
                    end
                end
            end
        end
        # puts "matriz gerada:" # debug
        # imprimeMatriz(m) # debug
        # puts "--- FIM criaMatriz ---" # debug
        # puts # debug
        return m
    end
    
    def transposicao(f, n, f_cifrado)
        # puts # debug
        # puts "--- INICIO transposicao ---" # debug
        f.rewind
        cont=0
        texto = []
        f.each_char do |c| #ler o arquivo
            cont+=1
            texto << c
            if ((cont == 1000*n) || f.eof?)
                # puts "Antes de mudar as colunas:" # debug
                matriz = criaMatriz(1000,n,texto)
                matrizT = mudaOrdemColuna(matriz) #feito
                # puts "Depois de mudar as colunas:" # debug
                # puts # debug
                # imprimeMatriz(matrizT) # debug
                matrizTranspostaToArquivo(matrizT, f_cifrado)
                cont =0
                texto = []
            end
        end
        # puts "--- FIM transposicao ---" # debug
        # puts # debug
    end

    def desfazTransposicao(f_cifrado, n, f_playfair)
        # puts # debug
        # puts "--- INICIO desfazTransposicao ---" # debug
        f_cifrado.rewind
        cont=0
        texto = []
        f_cifrado.each_char do |c| #ler o arquivo
            cont+=1
            texto << c
            if ((cont == 1000*n) || f_cifrado.eof?)
                # puts 'Texto' # debug
                # puts texto.to_s # debug
                textoT = LinhaToColuna(texto, cont/n, n)
                # puts "Matriz Transposta: " # debug
                matriz = criaMatriz(1000,n,textoT)
                matrizT = refazOrdemColuna(matriz)
                # puts "refeita coluna MatrizTransposta" # debug
                # imprimeMatriz(matrizT) # debug
                matrizToArquivo(matrizT,f_playfair) # escreve matriz no arquivo
                cont =0
                texto = []
            end
        end
        # puts "--- FIM desfazTransposicao ---" # debug
        # puts # debug
    end

    def LinhaToColuna(texto, numLinhas, numCol)
        # puts # debug
        # puts "--- INICIO LinhaToColuna ---" # debug
        textoAux = []
        i=0
        (0..numLinhas-1).each do |indiceColAux|
            compCol = indiceColAux
            # puts compCol # debug
            (0..numCol-1).each do |indiceCol|
                if( compCol <((numCol)*(numLinhas)))
                    textoAux[i] = texto[compCol]
                    i+=1
                    # puts 'incrementacompCol: ' + compCol.to_s + '  letra: ' + texto[compCol].to_s # debug
                    compCol+=(numLinhas)
                end 
            end
        end
        # puts "textoAux = "+textoAux.to_s # debug
        # puts "--- FIM LinhaToColuna ---" # debug
        # puts # debug
        return textoAux
    end        

    def mudaOrdemColuna(matriz)
        indiceColAux = 0
        n = matriz.first.length
        numLinhas = matriz.length
        mAux = Array.new(numLinhas)    #cria matriz auxilia
        (0..2).each do |modCol| #mod da coluna - > enquanto modColuna < n
            (0..n-1).each do |indiceCol| #le indice da coluna de matriz de alguma forma
                if( (indiceCol%3) == modCol) # se indice mod == modcoluna
                    (0..numLinhas-1).each do |indiceLin| #enquanto o j < numeroDelinhas 
                        if mAux[indiceLin].nil?
                            mAux[indiceLin]=[]
                        end
                        mAux[indiceLin][indiceColAux] = matriz[indiceLin][indiceCol]
                    end
                    indiceColAux+=1
                end        
            end        
        end
        return mAux
    end

    def refazOrdemColuna(matriz)
        indiceColAux = 0
        numLinhas = matriz.length
        n = matriz.first.length
        mAux = Array.new(numLinhas)    #cria matriz auxiliar
        indiceComp = 0
        cont = n/3
        (0..cont-1).each do |contMod|
            indiceComp = contMod
            (0..n-1).each do |indiceCol| #le indice da coluna de matriz de alguma forma
                if(indiceComp == indiceCol)
                    (0..numLinhas-1).each do |indiceLin| #enquanto o j < numeroDelinhas 
                        if mAux[indiceLin].nil?
                            mAux[indiceLin]=[]
                        end
                        mAux[indiceLin][indiceColAux] = matriz[indiceLin][indiceComp]
                    end
                indiceColAux+=1
                indiceComp+=(cont)
                end
            end
        end
        return mAux
    end

    def matrizTranspostaToArquivo(m,f)
        coluna=0
        nlinhas=m.length
        ncolunas=m.first.length
        while coluna<ncolunas
            linha=0
            while linha<nlinhas
                f.write(m[linha][coluna])
                linha+=1
            end
            coluna+=1
        end
    end
    
    def matrizToArquivo(m,f)
        m.each do |linha|
            linha.each do |elemento|
                f.write(elemento)
            end
        end  
    end
# }

# main {
    # puts # debug
    # puts "--- INICIO main ---" # debug
    I18n.enforce_available_locales = false  

    if ARGV.length < 5
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    elsif ARGV.length > 5
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    #------
    if ARGV[0]=="-c"
        opt = 0
    elsif ARGV[0]=="-d"
        opt = 1
    else
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    #------
    if File.exists? ARGV[1]
        f=File.open(ARGV[1], "r")
    else
        puts "arquivoDeEntrada deve ser um arquivo existente."
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    #------ 
    if ARGV[2] =~ /\d/
        puts "a palavraChave nao pode conter numeros."
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    else
        keyword=ARGV[2]
    end
    #------
    if ARGV[3] =~ /\d/
        n = ARGV[3].to_i
        if n%3!=0
            puts "O parametro numeroChave deve ser multiplo de 3."
            abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
        end
    else
        puts "o numeroChave tem que ser um numero E multiplo de 3."
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    
    # matriz (array de arrays) gerada a partir da chave
    case opt
    when 0
        matchave = criaMatriz(5,5,criaArrayChave(keyword))
        f_playfair = File.open("texto_cifrado.pf","w+")
        playfair(f, matchave, f_playfair)
        f.close
        # f_playfair.rewind # debug
        # puts "playfair = " # debug
        # puts f_playfair.read # debug
        # puts # debug
        f_cifrado = File.open(ARGV[4],"w+")
        transposicao(f_playfair, n, f_cifrado)
        f_playfair.close
        # f_cifrado.rewind # debug
        # puts "cifrado = " # debug
        # puts f_cifrado.read # debug
        f_cifrado.close
    when 1
        f_playfair = File.open("texto_decifrado.tr","w+")
        desfazTransposicao(f, n, f_playfair)
        # f_playfair.rewind # debug
        # puts "destransposto = " # debug
        # puts f_playfair.read # debug
        f_playfair.rewind
        # puts # debug
        f.close

        matchave = criaMatriz(5,5,criaArrayChave(keyword))
        f_decifrado = File.open(ARGV[4],"w+")
        desplayfair(f_playfair, matchave, f_decifrado)
        f_playfair.close
        # puts "decifrado = " # debug
        # f_decifrado.rewind # debug
        # puts f_decifrado.read # debug
        f_decifrado.close
    end
    # puts # debug
    # puts "--- FIM main ---" # debug
# }