namespace :crush do
  task :png do
    sh 'pngcrush -q -e .crushed -rem time -rem alla -rem allb -l 9 -w 32 -plte_len 0 -reduce -rem gAMA -rem cHRM -rem iCCP -rem sRGB -brute output/**/*.png'
    sh 'find output -name "*.crushed" -print | sed "s/\\(.*\\)\\.crushed/ & \\1.png/" | xargs -L1 mv'
  end

  task :jpg do
    FileList['output/**/*.jpg'].each do |input_file|
      sh "jpegtran -copy none -optimize -progressive -outfile #{input_file.sub(/jpg$/, 'crushed')} #{input_file}"
      sh 'find output -name "*.crushed" -print | sed "s/\\(.*\\)\\.crushed/ & \\1.jpg/" | xargs -L1 mv'
    end
  end
end

desc 'Optimize images in output directory'
task :crush => [:'crush:png', :'crush:jpg']
