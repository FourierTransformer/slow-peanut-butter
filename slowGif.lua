slowGif = {}
slowGif.template = {"totalTime", "fade"}

slowGif.download = function(photo)
    os.execute(string.format("wget %s -O %s", photo.url, photo.filename))
end

slowGif.process = function(photo)
    os.execute(string.format("ffmpeg -r 1 -i %s -r 1 %s/out%%05d.png", photo.filename, photo.foldername))
end

slowGif.play = function(photo)
    os.execute(string.format("info-beamer %s &", photo.foldername))
end

slowGif.stop = function(photo)
    os.execute("kill $(pgrep info-beamer)")
end

return slowGif
