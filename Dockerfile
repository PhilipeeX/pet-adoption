# Use a imagem base do Ubuntu
FROM ubuntu:latest

# Atualize o sistema e instale dependências básicas
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        gnupg \
        build-essential \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        libffi-dev \
        libreadline-dev \
        libncurses5-dev \
        libgdbm-dev \
        libssl-dev \
        libyaml-dev \
        git \
        postgresql-client \
        libpq-dev \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common

# Instale o asdf e as dependências necessárias
RUN apt install curl git && \
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0 && \
    echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc && \
    echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# Configure o PATH e carregue o asdf
ENV PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"

# Instale Ruby 2.1.0 com saída detalhada usando o caminho completo para o asdf
SHELL ["/bin/bash", "-c"]
RUN ~/.asdf/bin/asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git && \
    RUBY_BUILD_VERBOSE=1 ~/.asdf/bin/asdf install ruby 2.1.0 && \
    ~/.asdf/bin/asdf global ruby 2.1.0

# Instale Bundler e Rails
RUN ~/.asdf/shims/gem install bundler -v 1.17.3 && \
    ~/.asdf/shims/gem install concurrent-ruby -v 1.1.9 && \
    ~/.asdf/shims/gem install rails -v 4.0.0

# Configure o diretório de trabalho
WORKDIR /app

# Copie o código da aplicação para o diretório de trabalho
COPY app/ /app

# Instale as gems do Rails
RUN ~/.asdf/shims/bundle install

# Exponha a porta padrão do Rails
EXPOSE 3000

# Comando padrão para iniciar o Rails server
CMD ["~/.asdf/shims/rails", "server", "-b", "0.0.0.0"]
