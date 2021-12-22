delete-mysql:
	rm -rf ./docker/mysql/master/data/* \
	&& rm -rf ./docker/mysql/slave1/data/* \
	&& rm -rf ./docker/mysql/slave2/data/* \
	&& rm -rf ./docker/mysql/slave3/data/* \
	&& rm -rf ./docker/mysql/slave4/data/* \
	&& rm -rf ./docker/mysql/slave5/data/*

delete-redis:
	rm -rf ./docker/redis/master1/data/* \
	&& rm -rf ./docker/redis/master2/data/* \
	&& rm -rf ./docker/redis/master3/data/* \
	&& rm -rf ./docker/redis/slave1/data/* \
	&& rm -rf ./docker/redis/slave2/data/* \
	&& rm -rf ./docker/redis/slave3/data/*