-- get the external things we need
local cjson = require('cjson')
local lfs = require('lfs')

-- load up the other files
local mode = {}
mode['slowGif'] = require('slowGif')
mode['realtime'] = require('realtime')

-- change to this dir from cron
lfs.chdir('/home/pi/slow-gif/photos')

-- load any generic file
local function loadFile(filename)
    local file = assert(io.open(filename, "r"))
    local contents = file:read("*all")
    file:close()
    return contents
end

-- write file to location
local function writeFile(filename, contents)
    local file = assert(io.open(filename, "w"))
    file:write(contents)
    file:close()
end

-- load up the config
local function readConfig(filename)
    local contents = loadFile(filename)
    return cjson.decode(contents)
end

local function processTemplate(photo)
    local filename = "../" .. photo.mode .. "-template.lua"
    local contents = loadFile(filename)
    for _, token in ipairs(mode[photo.mode]['template']) do
        contents = contents:gsub("{{" .. token .. "}}", photo[token])
    end
    writeFile(photo.foldername .. "/node.lua", contents)
end

local function downloadAndProcessPhotos(photos)
    -- iterate over photos
    for _, photo in ipairs(photos) do
        assert(mode[photo.mode] ~= nil, photo.mode .. " is not a valid mode")
        print(photo.filename)

        -- if it doesn't exist, download it
        if not (lfs.attributes(photo.filename, "mode") == "file") then
            mode[photo.mode].download(photo)
        end

        -- PROCESS IT!
        if not (lfs.attributes(photo.foldername, "mode") == "directory") then
            lfs.mkdir(photo.foldername)

            -- add the template if it exists
            if type(mode[photo.mode]['template']) == "table" then
                processTemplate(photo)
            end

            -- process the actual photo
            mode[photo.mode].process(photo)
        end

    end
end

local function displayPhotos(photos, config)
    for _, photo in ipairs(photos) do
        print(photo.filename)
        mode[photo.mode].play(photo)
        os.execute("sleep " .. config.next_photo)
        mode[photo.mode].stop(photo)
    end
end

config = readConfig('config.json')
--downloadAndProcessPhotos(config.photos)
displayPhotos(config.photos, config.config)
