Sub-pixel downscale
===================

Will downscale an image to 1/3 of original height and width, and outputs
standard average-based result, and horizontal RGB-order sub-pixel averaged
result. If someone cares to make an issue I'll write other sub-pixel types.

If you need a different scale, use another program to scale to 3 times the
desired height and width, and then scale it in this program from there.

Takes textual `.ppm` files only. Use ImageMagick `convert example.jpg -compress
none example.ppm` or similar to get the PPM file, and then e.g.
`convert example_spr.ppm example_spr.png` to get the result (avoid storing the
result in a lossy format - the tradeoffs of lossy formats are not necessarily
designed to handle sub-pixel concerns, YMMV).

A makefile has been provided to do this kind of conversion, try e.g.
`make example_spr.png` to output the SP-downscale of
`example.jpg`, etc...

A comparison image, e.g. `example_avg.ppm` is also output by the program, for
your convenience. The results are generally very good for photos of natural
environments or people.

3 times the horizontal resolution compared to the standard equivalent. This is a
well-known technique for increasing horizontal resolution, I wrote this because
I couldn't find an implementation and it was easy enough to write.

Limitations
-----------

Some colorblind people have complained about reading SPR text. I think I
understand the problem, and the algorithm can probably be slightly modified to
allow better reading for people with this issue.

Obviously the technique depends on the sub-pixel layout of the display device,
and won't work unless the image is being displayed at 1:1 scale.

A form of rainbow moiré patterns happen with some imagery, especially fences.

Hard pixel edges and pixel-art becomes pretty and colorful (but not in a useful
way).

For giggles
-----------

I've noticed when people write about sub-pixel rendering they're always trying
to defend their choice. They will say they're working on a cheaper device, or
portable device, or something. Similar things happen when you see research on
dithering etc. Please stop doing this, increasing the horizontal resolution of
your device by 3 times shouldn't need justification, I'd do it on a 4K phone
screen or a 800x600 CRT. Likewise with dithering, we have reasonable
parallelizable dithering algorithms, can we just use those on 24-bit downsampled
color, instead of building expensive custom 10-bit monitors?

Also why do we say 10-bit color? We don't call 24-bit color 8-bit color.

Seriously, this would be like Intel developing a technique that halved processor
lithography, and then writing in their patent "so yeah I guess this is useful...
if you're on a Pentium III! **hort hort hort**".
