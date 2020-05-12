MAKEFLAGS += --silent

image_name = nvim:latest

build:
	if [ ! -z $$(docker images -q $(image_name)) ]; then docker rmi -f $(image_name); fi
	docker build -t $(image_name) .
	docker run -it --rm -v $$(pwd):/src -v $(HOME)/.vim/swp:/root/.vim/swp -v $(HOME)/.vim/undodir:/root/.vim/undodir $(image_name) sh -l

run:
	docker run -it --rm -v $$(pwd):/src -v $(HOME)/.vim/swp:/root/.vim/swp -v $(HOME)/.vim/undodir:/root/.vim/undodir $(image_name) sh -l
