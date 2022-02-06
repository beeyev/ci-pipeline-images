build:
	docker build -t php --build-arg BUILDKIT_INLINE_CACHE=1 -f ./images/php/Dockerfile-alpine . && docker run -it php
	docker build -t php --build-arg BUILDKIT_INLINE_CACHE=1 -f ./images/php/Dockerfile . && docker run -it php
