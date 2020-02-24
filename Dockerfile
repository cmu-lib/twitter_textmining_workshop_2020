FROM mdlincoln/cmu_textmining@9aff03a0558f

## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}
