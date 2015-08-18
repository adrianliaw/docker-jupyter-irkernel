FROM r-base:latest

MAINTAINER Adrian Liaw (Wei-Han Liaw) <adrianliaw2000@gmail.com>

RUN apt-get update && \
    apt-get install -y python-dev curl gcc g++ && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    pip install ipython[notebook]

RUN apt-get install -y libzmq3-dev libcurl4-openssl-dev && \
    (echo "install.packages(c('rzmq','repr','IRkernel','IRdisplay')," && \
     echo "    repos = c('http://irkernel.github.io/', getOption('repos')))" && \
     echo "IRkernel::installspec()") \
    | Rscript -e "source(file('stdin'))" && \
    mkdir -p workspace/notebooks workspace/data /root/.ipython/profile_default

RUN (echo "c = get_config()" && \
     echo "c.NotebookApp.ip = '0.0.0.0'" && \
     echo "c.NotebookApp.open_browser = False") \
    > /root/.ipython/profile_default/ipython_notebook_config.py

ENV DIR /workspace

WORKDIR $DIR

EXPOSE 8888

CMD ipython notebook
