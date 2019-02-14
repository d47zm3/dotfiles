FROM alpine:edge
LABEL maintainer="d47zm3@gmail.com"

RUN apk update && \
    apk add curl git neovim neovim-doc python3 gcc python3-dev musl-dev bash ctags the_silver_searcher go nodejs npm
RUN python3 -m ensurepip
RUN rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi
RUN pip3 install --upgrade neovim autopep8 flake8 isort pep8 pydocstyle pylint pytest-cov yapf black jedi
RUN mkdir -p /root/.config/nvim/
ADD init.vim /root/.config/nvim/
ADD coc-settings.json  /root/.config/nvim/
ADD .profile /root/
ADD .bashrc /root/
ENV TERM=xterm-256color
RUN nvim --headless +PlugInstall +qall
RUN nvim --headless +GoUpdateBinaries +qall
WORKDIR /src
