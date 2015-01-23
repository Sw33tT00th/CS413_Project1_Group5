all:
	mkdir -p bin
	haxe -cp src \
	-swf-header 600:500:60:aeaeae \
	-swf-version 11.3 \
	-swf bin/Sandbox.swf \
	-swf-lib starling.swc \
	--macro "patchTypes('starling.patch')" \
	-main com.cykon.haxe.Sandbox

clean:
	rm -r bin
	mkdir -p bin