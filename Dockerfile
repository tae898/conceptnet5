# Start from the official postgres image
FROM postgres
# Adding the below environment variables allow you to create a database easily within 
# the docker contianer
ENV POSTGRES_USER root
ENV POSTGRES_PASSWORD root
ENV POSTGRES_DB root

# Install the necessary libraries for both postgres and conceptnet
RUN apt update
RUN apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev -y
RUN apt install libreadline-dev libffi-dev curl libbz2-dev libsqlite3-dev git unzip -y
RUN apt install wget libhdf5-dev libmecab-dev mecab-ipadic-utf8 liblzma-dev lzma -y

# Change the default shell to `zsh` since I like it.
RUN apt install watch htop zsh -y
RUN chsh -s $(which zsh)
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install python 3.7.12
# Somehow I couldn't just `apt install python3.7`. Here I manually download and compile it.
RUN wget https://www.python.org/ftp/python/3.7.12/Python-3.7.12.tgz
RUN tar -xf Python-3.7.12.tgz
WORKDIR "/Python-3.7.12"
RUN ./configure --enable-optimizations --enable-loadable-sqlite-extensions
RUN make -j$(nproc)
RUN make install
RUN apt install python3-pip python3-dev  -y

# Install conceptnet
WORKDIR "/"
RUN git clone https://github.com/commonsense/conceptnet5.git
WORKDIR "/conceptnet5"
# modify `build.sh` in place to speed up processing
RUN sed -i -e 's/-j 2/-j$(nproc) /g' build.sh
RUN pip3 install --upgrade pip
RUN pip3 install wheel ipadic
RUN pip3 install -e '.[vectors]'

CMD [ "postgres" ]