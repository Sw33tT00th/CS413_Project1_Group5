all:
	mkdir -p bin
	haxe -cp src \
	-swf-header 1280:720:120:000000 \
	-swf-version 11.3 \
	-swf bin/Sandbox.swf \
	-swf-lib starling.swc \
	--macro "patchTypes('starling.patch')" \
	-main com.cykon.haxe.Sandbox

run:
	make
	cygstart bin/Sandbox.swf

clean:
	rm bin/Sandbox.swf
	mkdir -p bin