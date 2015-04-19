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
    
    def playfair (f, m)
        f_claro = preparaEntrada(f)
        f_claro.rewind
        textocifrado = ''
        cont=0
        pos1=[]
        pos2=[]
        f_cifrado = File.open("texto_cifrado.pf","w+")
        f_claro.each_char do |c|
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
                    charCifrado1 = m[pos1[0]][(pos1[1]+1)%5]
                    charCifrado2 = m[pos2[0]][(pos2[1]+1)%5]
                elsif pos1[1] == pos2[1]
                    charCifrado1 = m[(pos1[0]+1)%5][pos1[1]]
                    # puts "charCifrado1 = m["+((pos1[0]+1)%5).to_s+"]["+pos1[1].to_s+"]"
                    charCifrado2 = m[(pos2[0]+1)%5][pos2[1]]
                    # puts "charCifrado2 = m["+((pos2[0]+1)%5).to_s+"]["+pos2[1].to_s+"]"
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
        return f_cifrado
    end

    def desplayfair (f_cifrado, m)
        f_descifrado = File.open("texto_decifrado.pf","w+")
        f_cifrado.rewind
        textoDecifrado = ""
        cont=0
        pos1=[]
        pos2=[]
        f_cifrado.each_char do |c|
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
                f_descifrado.write(textoDecifrado)
            end
        end
        f_cifrado.close
        return f_descifrado
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
            puts "arquivo = "+f_novo.read
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
    
    def transposicao(f_playfair)
        f_playfair.rewind
        f_cifrado = File.open("f_cifrado.tr","w+")
        cont=0
        texto = []
        f_playfair.each_char do |c| #ler o arquivo
            cont+=1
            texto << c
            if ((cont = 1000*n) || f_cifrado.eof?)
                matriz = criaMatriz(1000,n,texto)
                matrizT = mudaOrdemColuna(matriz, n) #feito
                # escreve matriz no arquivo
                cont =0
            end    
        end
        
        #retorna f_cifrado
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
        imprimeMatriz(matriz)
        puts 'novaMatriz'    
        imprimeMatriz(mAux)
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

    def refazOrdemColuna(matriz, n)
        indiceColAux = 0
        numLinhas = matriz.length
        mAux = Array.new(numLinhas)    #cria matriz auxilia
        indiceComp = 0
        (0..2).each do |contMod|
            indiceComp= contMod
            (0..n-1).each do |indiceCol| #le indice da coluna de matriz de alguma forma
                if(indiceComp == indiceCol && indiceColAux < n)
                    puts indiceComp
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
        puts 'MatrizRefeita'    
        imprimeMatriz(mAux) 
    end

    
# }

# main {
    I18n.enforce_available_locales = false  
    # pega n de colunas e chave da playfair
    if ARGV.length < 2
        abort "escreve os argumentos babaca"
    end
    n=ARGV[0].to_i
    if n%3!=0
        abort "n sabe multiplicar por 3?"
    end
    keyword=ARGV[1]
    f=File.open("newton.ign", "r")
    
    # matriz (array de arrays) gerada a partir da chave
    matchave = criaMatrizChave(criaArrayChave(keyword), 5)
    
    # textoclaro = read_file("newton.txt")
    # textoclaro = "lucas affonso xavier de morais"
    f_playfair = playfair(f, matchave)
    f.close
    f_playfair.rewind
    puts "arquivo = "+f_playfair.read
    # f_decifrado = desplayfair(f_playfair, matchave)
    # f_decifrado.rewind
    # puts "arquivo = "+f_decifrado.read
    # textomaiscifrado = transposicao(textocifrado)
    # f_decifrado.close
# }