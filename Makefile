all:
	mkdir -p bin
	haxe -cp src \
	-swf-header 400:300:60:ffffff \
	-swf-version 11.3 \
	-swf bin/Sandbox.swf \
	-swf-lib starling.swf \
	--macro "patchTypes('starling.patch')" \
	-main Sandbox

clean:
	rm -r bin
	mkdir -p bin