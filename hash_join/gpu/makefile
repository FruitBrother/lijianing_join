libmyshare.so : jointest.cu
	nvcc -o generate/libmyshare.so -shared -Xcompiler -fPIC jointest.cu


clean :
	rm generate/*.so testc testcpp  -f
