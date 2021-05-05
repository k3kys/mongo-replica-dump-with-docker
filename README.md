# MONGODB REPLICASET & DUMP 구현해보기 with Docker
우리는 흔히 DB를 사용하지만, DB의 가용성에는 크게 신경쓰지 않고 있습니다.

사실 이런 것을 딱히 구현하지 않아도 **mongo Atlas**에서는 레플리카셋은 물론이고

클러스터링, 모니터링, 재해 복구 등 더 뛰어난 기능들을 제공해주고 있습니다.

하지만 소규모 프로젝트 아닌 대형 프로젝트에서 Atlas를 사용해야 한다면, 가장 큰 문제가 생깁니다.

바로 :moneybag:비용 입니다.

따라서, 이번 프로젝트에서는 Atlas를 이용하지 않고도 DB의 가용성을 높여보고자 합니다.

## MONGO REPLICASET with Docker

### 준비사항
- NODE JS와 DOCKER가 깔려있어야 합니다.

### 단계
- mongo replication 옵션을 설정한 mongo.conf를 이용해 Dockerfile 작성하기

- Replica Set을 설정하기위한 replicaSet.js와 setup.sh 만들기

- 3개의 mongo-rs 컨테이너와 setup-rs 컨테이너를 실행하는 Docker compose 작성

### 1.mongo replication 옵션을 설정한 mongo.conf를 이용해 Dockerfile 작성하기

[mongo.conf로 이동하기](./mongo-rs0-1/mongo.conf)

## MONGO DUMP with Docker
