FROM python:3

ENV SERVER_PORT 5000
ENV SERVER_HOST 0.0.0.0

RUN pip install \
    mlflow \
    pymysql \
    boto3 && \
    mkdir /mlflow/

EXPOSE ${SERVER_PORT}

CMD mlflow server \
    --host ${SERVER_HOST} \
    --port ${SERVER_PORT} \
    --default-artifact-root ${BUCKET} \
    --backend-store-uri mysql+pymysql://${USERNAME}:${PASSWORD}@${HOST}:${PORT}/${DATABASE}