#!/usr/bin/env ruby
# encoding: utf-8
require 'i18n'
I18n.enforce_available_locales=false
def is_numeric?(obj) 
   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
end

f=File.open("t", "r")
dupla=[]
aux=''
f_novo = File.open("texto_preparado.pf","w+")
dupla[0] = f.getc
i=0
f.each_char do |c|
    puts "step "+(i+=1).to_s
    dupla[1] = c
    puts "dupla = [\""+dupla[0]+"\"][\""+dupla[1]+"\"]"
    cont = 0
    strtemp = I18n.transliterate(dupla.to_s).gsub(/\n/,'').gsub(/[^0-9A-Za-z]/, '').upcase
    if(strtemp.length==1)
        cont=1
        dupla[0] = strtemp
    end
    if(cont == 0)
        strtemp = strtemp.gsub(/J/,'I')  
        if is_numeric?(strtemp[0])
                f_novo.write(strtemp[0])                    
        else         
            if strtemp[1]==strtemp[0]   # se dois iguais
                f_novo.write(strtemp[0])    # escreve primeiro
                aux = (strtemp[0]!='X' ? 'X' : 'H')
                f_novo.write(aux)   # escreve X
                # f_novo.write(strtemp[1])    # escreve segundo
            end
        end
        dupla[0] = strtemp[1]
    end
    f_novo.rewind
    puts "arquivo = "+f_novo.read
    puts
end
puts "deveria ser 0AXA00BCXXH"
f_novo.close
f.close