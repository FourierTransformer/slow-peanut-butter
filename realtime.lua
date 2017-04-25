realtime = {}
realtime.template = {"filename"}

realtime.download = function(photo)
    os.execute(string.format("wget %s -O %s", photo.url, photo.filename))
end

realtime.process = function(photo)
    print("starting ffmpeg")
    os.execute(string.format("ffmpeg -i %s -c:v h264_omx  -movflags faststart -pix_fmt yuv420p -b:v 15242310 -maxrate 15242310 -bufsize 30484620 -level 41 %s/%s.mp4", photo.filename, photo.foldername, photo.filename))
end

realtime.play = function(photo)
    os.execute(string.format("info-beamer %s &", photo.foldername))
end

realtime.stop = function(photo)
    os.execute("kill $(pgrep info-beamer)")
end

return realtime
