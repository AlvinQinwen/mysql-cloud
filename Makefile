delete:
	rm -rf ./docker/mysql/master/data/* \
	&& rm -rf ./docker/mysql/slave1/data/* \
	&& rm -rf ./docker/mysql/slave2/data/* \
	&& rm -rf ./docker/mysql/slave3/data/* \
	&& rm -rf ./docker/mysql/slave4/data/* \
	&& rm -rf ./docker/mysql/slave5/data/*