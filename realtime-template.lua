gl.setup(NATIVE_WIDTH,NATIVE_HEIGHT)

local vid = resource.load_video{
    file = "{{filename}}.mp4";
    raw = true; -- load as raw video object
    audio = false;
    looped = true;
    -- other options as usual
}

-- try to get the widht and height.
local state, width, height
while true do
    state, width, height = vid:state()
    if state == "loaded" then
        break
    end
end

-- DO SOME MATH!
--
-- if the height is larger than the width, we need to scale the height of the
-- video to the height of the screen and the width proportionally and vice-
-- versa for the width.

local x, y, newheight, newwidth = 0, 0, NATIVE_HEIGHT, NATIVE_WIDTH
if width > height then
    newwidth = NATIVE_WIDTH
    newheight = height * (NATIVE_WIDTH / width)
    x = 0
    y = (NATIVE_HEIGHT - newheight) / 2
else
    newwidth = width * (NATIVE_HEIGHT/height)
    newheight = NATIVE_HEIGHT
    x = (NATIVE_WIDTH - newwidth) / 2
    y = 0
end
print("original")
print(width)
print(height)
print("new")
print(newwidth)
print(newheight)

--vid:target(0, 0, NATIVE_WIDTH, NATIVE_HEIGHT)
vid:target(x, y, x+newwidth, y+newheight)
vid:layer(1)

function node.render()
    vid:state()
    --gl.clear(0,0,0,0) -- alpha set to 0 -> transparent
    --if vid:state() ~= "loaded" then print(vid:state()) end
    -- rest of node.render now draws on top of the video
end
