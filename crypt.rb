#!/usr/bin/env ruby
# encoding: utf-8

# methods{
    def criaArrayChave(keyword)
        m = []
        keyword.each_char do |c|
            if c=='j'   # => troca o 'j' pelo 'i'
                c='i'
            end
            if ! m.include? c
                m << c
            end
        end
        ("a".."z").each do |c|
            if c=='j'   # => troca o 'j' pelo 'i'
                c='i'
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
                    m[i] << c
                else
                    if (i+=1)<ordem
                        if m[i].nil?
                            m[i]=[]
                        end
                        m[i] << c
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
    
# }

# main {
    if ARGV.length < 2
        abort "escreve os argumentos babaca"
    end
    n=ARGV[0].to_i
    keyword=ARGV[1]
    
    matchave = criaMatrizChave(criaArrayChave(keyword), 5)
# }