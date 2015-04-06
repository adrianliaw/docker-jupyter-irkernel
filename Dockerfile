FROM r-base:latest

MAINTAINER Adrian Liaw (Wei-Han Liaw) <adrianliaw2000@gmail.com>

ADD install.R /

RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install ipython pyzmq jinja2 tornado jsonschema

RUN apt-get install -y libzmq3-dev libcurl4-openssl-dev && \
    Rscript install.R && \
    rm install.R && \
    mkdir workspace workspace/notebooks workspace/data

RUN (echo "require(['base/js/namespace'], function (IPython) {" && \
     echo "  IPython._target = '_self';" && \
     echo "});") \
     > /root/.ipython/profile_default/static/custom/custom.js

RUN (echo "c = get_config()" && \
     echo "from IPython.lib import passwd" && \
     echo "import os" && \
     echo "c.NotebookApp.password = passwd(os.environ.get('PASSWORD', 'jupyter'))") \
     > /root/.ipython/profile_default/ipython_notebook_config.py

ENV PASSWORD jupyter
ENV DIR /workspace

WORKDIR $DIR

EXPOSE 8888

CMD ipython notebook --ip 0.0.0.0 --no-browser
