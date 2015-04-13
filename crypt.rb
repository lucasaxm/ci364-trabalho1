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
    
    def playfair (textoclaro, m)
        textocifrado = ""
        textoclaro = preparaEntrada(textoclaro)
        puts textoclaro
        cont=0
        pos1=[]
        pos2=[]
        textoclaro.each_char do |c|
            if is_numeric?(c)
                textocifrado = textocifrado+c
            else
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
                end
                textocifrado = textocifrado.to_s+charCifrado1.to_s+charCifrado2.to_s
            end
        end
        return textocifrado
    end

    def desplayfair (textocifrado, m)
        textoclaro = ""
        cont=0
        pos1=[]
        pos2=[]
        textocifrado.each_char do |c|
            if is_numeric?(c)
                textoclaro = textoclaro+c
            else
                
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
                end
                textoclaro = textoclaro.to_s+charDecifrado1.to_s+charDecifrado2.to_s
            end
        end
        return textoclaro
    end
    
    def preparaEntrada (string)
        texto = I18n.transliterate(string).gsub(/\n/,'').gsub(/[^0-9A-Za-z]/, '').upcase
        texto = texto.gsub(/J/,'I')
        ant=texto[0]
        textoNovo=texto[0]
        texto[1..-1].each_char do |c|
            if is_numeric?(c)
                textoNovo = textoNovo+c
            else
                if c==ant
                    textoNovo << (c!='X' ? 'X' : 'H')
                end
                textoNovo << c
                ant = c
            end    
        end
        if textoNovo.size % 2 != 0
            textoNovo << (textoNovo[-1]=="X" ? "H" : "X")
        end
        return textoNovo
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
    
    def read_file(file_name)
      file = File.open(file_name, "r")
      data = file.read
      file.close
      return data
    end
    
    def is_numeric?(obj) 
       obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
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
    
    # matriz (array de arrays) gerada a partir da chave
    matchave = criaMatrizChave(criaArrayChave(keyword), 5)
    
    # textoclaro = read_file("newton.txt")
    textoclaro = "lucas affonso xavier de morais"
    textocifrado = playfair(textoclaro, matchave)
    puts textocifrado
    textodecifrado = desplayfair(textocifrado, matchave)
    puts textodecifrado
    # textomaiscifrado = transposicao(textocifrado)
    
# }