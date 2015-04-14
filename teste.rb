#!/usr/bin/env ruby
# encoding: utf-8
require 'i18n'
I18n.enforce_available_locales=false

f=File.open("t", "r")
strdupla=""
strdupla[0] = f.getc
f_novo = File.open("texto_preparado.pf","w+")
tam=0
i=0

f.each_char do |c|
    strdupla[1] = c
    puts "step "+(i+=1).to_s
    puts "dupla = [\""+strdupla[0]+"\"][\""+strdupla[1]+"\"]"
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
    f_novo.rewind
    puts "arquivo = "+f_novo.read
    puts "tam = "+tam.to_s
    puts
end
f_novo.write(strdupla[0])
tam+=1
if (tam%2 != 0)
    f_novo.write(strdupla[0]=='X' ? 'H' : 'X')
end

f_novo.rewind
puts "arquivo = "+f_novo.read
puts
f_novo.close
f.close