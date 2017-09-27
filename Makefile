%_avg.ppm: %.ppm
	lua subpixel-shrink.lua $<

%_spr.ppm: %.ppm
	lua subpixel-shrink.lua $<

%_avg.png: %_avg.ppm
	convert $< $@

%_spr.png: %_spr.ppm
	convert $< $@

%.ppm: %.jpg
	convert $< -compress none $@

%.ppm: %.jpeg
	convert $< -compress none $@

%.ppm: %.webp
	convert $< -compress none $@
