#!/usr/bin/env ruby
# encoding: utf-8
require 'i18n'
I18n.enforce_available_locales=false
def is_numeric?(obj) 
   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
end

f=File.open("t", "r")
strdupla=""
strdupla[0] = f.getc
f_novo = File.open("texto_preparado.pf","w+")
tam=0
tam_buffer=0
buffer=""
i=0
f.each_char do |c|
    strdupla[1] = c
    puts "step "+(i+=1).to_s
    puts "dupla = [\""+strdupla[0]+"\"][\""+strdupla[1]+"\"]"
    strdupla = I18n.transliterate(strdupla).gsub(/\n/,'').gsub(/[^0-9A-Za-z]/, '').upcase
    if(strdupla.length==2)
        strdupla = strdupla.gsub(/J/,'I')
        if is_numeric?(strdupla[1])
            buffer << strdupla[1]
            tam_buffer+=1
        else
            f_novo.write(strdupla[0])
            tam+=1
            if strdupla[0]==strdupla[1]
                if strdupla[0]=="X"
                    f_novo.write("H")
                else
                    f_novo.write("X")
                end
                tam+=1
            end
            f_novo.write(buffer)
            buffer=""
            strdupla[0]=strdupla[1]
        end
    elsif(strdupla.size==0)
    	strdupla[0] = f.getc
    	while is_numeric?(strdupla[0])
    	    buffer << strdupla[0]
    	    tam_buffer+=1
    	    strdupla[0] = f.getc
    	end
        f_novo.write(buffer)
        buffer=""
    end
    f_novo.rewind
    puts "buffer = "+buffer
    puts "tam_buffer = "+tam_buffer.to_s
    puts "arquivo = "+f_novo.read
    puts "tam = "+tam.to_s
    puts
    
end
f_novo.write(strdupla[0])
tam+=1
f_novo.write(buffer)
buffer=""
if (tam%2 != 0)
    if strdupla[0]=='X'
        f_novo.write("H")
    else
        f_novo.write("X")
    end
end

f_novo.rewind
puts "arquivo = "+f_novo.read
puts
f_novo.close
f.close