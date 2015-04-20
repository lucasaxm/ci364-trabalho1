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

    def criaMatrizChave(array, ordem)
        m = Array.new(ordem)
        i=0
        array.each do |c|
            if i<ordem
                if m[i].nil?
                    m[i]=[]
                end
                if m[i].length<ordem
                    m[i] << c.upcase
                else
                    if (i+=1)<ordem
                        if m[i].nil?
                            m[i]=[]
                        end
                        m[i] << c.upcase
                    end
                end
            end
        end
        return m
    end
    
    
    
    def imprimeMatriz(m)
        m.each do |linha|
            linha.each do |elemento|
                print elemento+' '
            end
            puts
        end
    end
    
    def playfair (f, m, f_cifrado)
        f_claro = preparaEntrada(f)
        f_claro.rewind
        puts "f_claro = ("+f_claro.read+")" # debug
        imprimeMatriz(m) # debug
        f_claro.rewind
        textocifrado = ''
        cont=0
        pos1=[]
        pos2=[]
        f_claro.each_char do |c|
            if cont==0
                puts # debug
                pos1 = buscaMatriz(m, c)
                puts "c= "+c.inspect # debug
                puts "pos1= "+pos1.inspect # debug
                puts "pos1[0]= "+pos1[0].inspect # debug
                puts "cont= "+cont.to_s # debug
                cont+=1               
            else
                puts # debug
                pos2 = buscaMatriz(m, c)
                puts "c ="+c.inspect # debug
                puts "pos2= "+pos2.inspect # debug
                puts "pos1[0]= "+pos1[0].inspect # debug
                puts "pos2[0]= "+pos2[0].inspect # debug
                puts "cont= "+cont.to_s # debug
                if pos1[0] == pos2[0]
                    charCifrado1 = m[pos1[0]][(pos1[1]+1)%5]
                    charCifrado2 = m[pos2[0]][(pos2[1]+1)%5]
                elsif pos1[1] == pos2[1]
                    charCifrado1 = m[(pos1[0]+1)%5][pos1[1]]
                    puts "charCifrado1 = m["+((pos1[0]+1)%5).to_s+"]["+pos1[1].to_s+"]" # debug
                    charCifrado2 = m[(pos2[0]+1)%5][pos2[1]]
                    puts "charCifrado2 = m["+((pos2[0]+1)%5).to_s+"]["+pos2[1].to_s+"]" # debug
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
    end

    def desplayfair (f_playfair, m, f_decifrado)
        textoDecifrado = ""
        cont=0
        pos1=[]
        pos2=[]
        f_playfair.each_char do |c|
            if cont==0
                pos1 = buscaMatriz(m, c)
                # puts "c= "+c.inspect
                # puts "pos1= "+pos1.inspect
                # puts "pos1[0]= "+pos1[0].inspect
                # puts "cont= "+cont.to_s
                cont+=1
                
            else
                pos2 = buscaMatriz(m, c)
                # puts "c ="+c.inspect
                # puts "pos2= "+pos2.inspect
                # puts "pos1[0]= "+pos1[0].inspect
                # puts "pos2[0]= "+pos2[0].inspect
                # puts "cont= "+cont.to_s
                if pos1[0] == pos2[0]
                    charDecifrado1 = m[pos1[0]][(pos1[1]-1)%5]
                    charDecifrado2 = m[pos2[0]][(pos2[1]-1)%5]
                elsif pos1[1] == pos2[1]
                    charDecifrado1 = m[(pos1[0]-1)%5][pos1[1]]
                    # puts "charDecifrado1 = m["+((pos1[0]-1)%5).to_s+"]["+pos1[1].to_s+"]"
                    charDecifrado2 = m[(pos2[0]-1)%5][pos2[1]]
                    # puts "charDecifrado2 = m["+((pos2[0]-1)%5).to_s+"]["+pos2[1].to_s+"]"
                else
                    charDecifrado1 = m[pos1[0]][pos2[1]]
                    charDecifrado2 = m[pos2[0]][pos1[1]]
                end
                cont=0
                textoDecifrado = charDecifrado1.to_s+charDecifrado2.to_s    
                # puts textoDecifrado.to_s #debug
                f_decifrado.write(textoDecifrado)
            end
        end
        return f_decifrado
    end
    
    def preparaEntrada (f)
        strdupla=""
        strdupla[0] = f.getc
        f_novo = File.open("texto_claro.pf","w+")
        tam=0

        f.each_char do |c|
            strdupla[1] = c
            # puts "step "+(i+=1).to_s
            # puts "dupla = [\""+strdupla[0]+"\"][\""+strdupla[1]+"\"]"
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
            # puts "tam = "+tam.to_s
            # puts
        end
        f_novo.write(strdupla[0])
        tam+=1
        if (tam%2 != 0)
            f_novo.write(strdupla[0]=='X' ? 'H' : 'X')
        end
            f_novo.rewind
            puts "arquivo = "+f_novo.read # debug
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
        return m
    end
    
    def transposicao(f, n, f_cifrado)
        f.rewind
        cont=0
        texto = []
        f.each_char do |c| #ler o arquivo
            cont+=1
            texto << c
            if ((cont == 1000*n) || f.eof?)
                matriz = criaMatriz(1000,n,texto)
                puts "Antes de mudar as colunas:" # debug
                imprimeMatriz(matriz) # debug
                matrizT = mudaOrdemColuna(matriz) #feito
                puts "Depois de mudar as colunas:" # debug
                imprimeMatriz(matrizT) # debug
                matrizTranspostaToArquivo(matrizT, f_cifrado)
                cont =0
                texto = ""
            end
        end
    end

    def desfazTransposicao(f_cifrado, n, f_playfair)
        f_cifrado.rewind
        cont=0
        texto = []
        f_cifrado.each_char do |c| #ler o arquivo
            cont+=1
            texto << c
            if ((cont == 1000*n) || f_cifrado.eof?)
                puts 'Texto'
                puts texto.to_s
                textoT = transformaArray(texto, cont/n, n)
                puts 'Texto Transformado'
                puts textoT.to_s
                matriz = criaMatriz(1000,n,textoT)
                puts "Matriz Trasposta: "
                imprimeMatriz(matriz)
                matrizT = refazOrdemColuna(matriz)
                puts "refeita coluna MatrizTrasposta"
                imprimeMatriz(matrizT)
                matrizC = tiraComplemento(matrizT)
                matrizToArquivo(matrizC,f_playfair) # escreve matriz no arquivo
                cont =0
                texto = ""
            end
        end
    end

    def transformaArray(texto, numLinhas, numCol)
        textoAux = []
        i=0
        (0..numLinhas-1).each do |indiceColAux|
            compCol = indiceColAux
            # puts compCol # debug
            (0..numCol-1).each do |j|
                # puts ( (indiceCol == compCol) && (compCol<numCol)) # debug
                if( compCol <((numCol)*(numLinhas)))
                    textoAux[i] = texto[compCol]
                    i+=1
                    # puts 'incrementacompCol: ' + compCol.to_s + '  letra: ' + texto[compCol].to_s # debug
                    compCol+=(numLinhas)
                end 
            end
        end
        return textoAux
    end        
    
    def tiraComplemento(m)
        ult = m.length-1
        linha=[]
        i=0
        j=1
        while j<m[ult].length
            if m[ult][i]!=m[ult][j]
                linha << m[ult][i]
                i+=1
                j+=1
            else
                i+=2
                j+=2
            end
        end
        if i<m[ult].length
            linha << m[ult][i]
        end
        m[ult] = linha
        return m
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
        mAux = Array.new(numLinhas)    #cria matriz auxilia
        indiceComp = 0
        (0..2).each do |contMod|
            indiceComp= contMod
            (0..n-1).each do |indiceCol| #le indice da coluna de matriz de alguma forma
                if(indiceComp == indiceCol && indiceColAux < n)
                    (0..numLinhas-1).each do |indiceLin| #enquanto o j < numeroDelinhas 
                        if mAux[indiceLin].nil?
                            mAux[indiceLin]=[]
                        end
                        mAux[indiceLin][indiceColAux] = matriz[indiceLin][indiceComp]
                    end
                # puts indiceColAux
                indiceColAux+=1
                indiceComp+=2
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
    I18n.enforce_available_locales = false  

    if ARGV.length < 5
        puts "escreve os argumentos babaca"
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    elsif ARGV.length > 5
        puts "escreveu coisa de mais, gênio."
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    #------
    if ARGV[0]=="-c"
        opt = 0
    elsif ARGV[0]=="-d"
        opt = 1
    else
        puts "que tal ler o manual antes de escrever os parametros?"
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    #------
    if File.exists? ARGV[1]
        f=File.open(ARGV[1], "r")
    else
        puts "sabe o que seria uma boa? um arquivo que existe."
        puts "arquivoDeEntrada deve ser um arquivo existente."
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    #------ 
    if ARGV[2] =~ /\d/
        puts "nao eh a toa que se chama 'palavraChave'."
        puts "a palavraChave nao pode conter numeros."
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    else
        keyword=ARGV[2]
    end
    #------
    if ARGV[3] =~ /\d/
        n = ARGV[3].to_i
        if n%3!=0
            puts "partiu aula de matematica."
            puts "O parametro numeroChave deve ser multiplo de 3."
            abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
        end
    else
        puts "nao eh a toa que se chama 'numeroChave'."
        puts "o numeroChave tem que ser um numero (duh) E multiplo de 3."
        abort "./crypt.rb [-c|-d] [arquivoDeEntrada] [palavraChave] [numeroChave] [arquivoDeSaida]"
    end
    
    # matriz (array de arrays) gerada a partir da chave
    case opt
    when 0
        matchave = criaMatrizChave(criaArrayChave(keyword), 5)
        f_playfair = File.open("texto_cifrado.pf","w+")
        playfair(f, matchave, f_playfair)
        f.close
        f_playfair.rewind # debug
        puts "playfair = " # debug
        puts f_playfair.read # debug
        puts # debug
        f_cifrado = File.open(ARGV[4],"w+")
        transposicao(f_playfair, n, f_cifrado)
        f_playfair.close
        f_cifrado.rewind # debug
        puts "cifrado = " # debug
        puts f_cifrado.read # debug
        f_cifrado.close
    when 1
        f_playfair = File.open("texto_decifrado.tr","w+")
        desfazTransposicao(f, n, f_playfair)
        f_playfair.rewind # debug
        puts "destransposto = " # debug
        puts f_playfair.read # debug
        f_playfair.rewind
        puts # debug
        f.close

        matchave = criaMatrizChave(criaArrayChave(keyword), 5)
        f_decifrado = File.open(ARGV[4],"w+")
        desplayfair(f_playfair, matchave, f_decifrado)
        f_playfair.close
        puts "decifrado = " # debug
        f_decifrado.rewind # debug
        puts f_decifrado.read # debug
        f_decifrado.close
    end
# }