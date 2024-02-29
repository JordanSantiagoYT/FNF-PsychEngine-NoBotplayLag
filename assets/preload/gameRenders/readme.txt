Frames captured by the ingame Renderer will go here. You'll need FFmpeg to convert them into MP4s! Don't worry about organizing the folders by song name too, the engine will do it automatically :)

For converting, here's the command I use:

ffmpeg -r 60 -i ./phobiaphobia/%07d.jpg  LOL.mp4

Replace phobiaphobia with the name of the song you rendered, and you can name the file whatever you want instead of "LOL"