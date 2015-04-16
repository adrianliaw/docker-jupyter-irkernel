FROM r-base:latest

MAINTAINER Adrian Liaw (Wei-Han Liaw) <adrianliaw2000@gmail.com>

RUN apt-get update && \
    apt-get install -y python-dev curl gcc g++ && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    pip install ipython[notebook]

RUN apt-get install -y libzmq3-dev libcurl4-openssl-dev && \
    (echo "install.packages('devtools')" && \
     echo "install.packages('RCurl')" && \
     echo "library(devtools)" && \
     echo "install_github('armstrtw/rzmq')" && \
     echo "install_github('IRkernel/repr')" && \
     echo "install_github('IRkernel/IRdisplay', ref='multi-image')" && \
     echo "install_github('IRkernel/IRkernel')" && \
     echo "IRkernel::installspec()" ) \
    | Rscript -e "source(file('stdin'))" && \
    mkdir workspace workspace/notebooks workspace/data

RUN (echo "require(['base/js/namespace'], function (IPython) {" && \
     echo "  IPython._target = '_self';" && \
     echo "});") \
     > /root/.ipython/profile_default/static/custom/custom.js

RUN (echo "c = get_config()" && \
     echo "headers = {'Content-Security-Policy': 'frame-ancestors *'}" && \
     echo "c.NotebookApp.allow_origin = '*'" && \
     echo "c.NotebookApp.allow_credentials = True" && \
     echo "c.NotebookApp.tornado_settings = {'headers': headers}" && \
     echo "c.NotebookApp.ip = '0.0.0.0'" && \
     echo "c.NotebookApp.open_browser = False" && \
     echo "from IPython.lib import passwd" && \
     echo "import os" && \
     echo "c.NotebookApp.password = passwd(os.environ.get('PASSWORD', 'jupyter'))") \
     > /root/.ipython/profile_default/ipython_notebook_config.py

ENV PASSWORD jupyter
ENV DIR /workspace

WORKDIR $DIR

EXPOSE 8888

CMD ipython notebook
