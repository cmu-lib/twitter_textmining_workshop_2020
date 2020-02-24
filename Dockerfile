FROM mdlincoln/cmu_textmining@9aff03a0558f766169f9f076e47f27087082c50f5f6a259b3324ba82b9ce9292

## Copies your repo files into the Docker Container
USER root
COPY . ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Become normal user again
USER ${NB_USER}
