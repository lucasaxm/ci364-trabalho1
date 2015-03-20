n=ARGV[0].to_i
matriz= Array.new
i=0
j=0
input = File.open("./input", "r") do |file|
    file.each_char do |c|
        if i<n
            matriz[n*j+(i+=1)]=c
        else
            i=0
            j+=1
            # matriz[n*j+i]=c
        end
    end
end
matriz.each do |c|
    print c
end