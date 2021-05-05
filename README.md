# MONGODB REPLICASET & DUMP 구현해보기 with Docker
우리는 흔히 DB를 사용하지만, DB의 가용성에는 크게 신경쓰지 않고 있습니다.

사실 이런 것을 딱히 구현하지 않아도 **mongo Atlas**에서는 레플리카셋은 물론이고

클러스터링, 모니터링, 재해 복구 등 더 뛰어난 기능들을 제공해주고 있습니다.

하지만 소규모 프로젝트 아닌 대형 프로젝트에서 Atlas를 사용해야 한다면, 가장 큰 문제가 생깁니다.

바로 :moneybag:비용 입니다.

따라서, 이번 프로젝트에서는 Atlas를 이용하지 않고도 DB의 가용성을 높여보고자 합니다.

## MONGO REPLICASET with Docker
![image](https://user-images.githubusercontent.com/56282663/117100263-447eaf80-adae-11eb-9ef3-8ddf3d44e26b.png)

만약, 사용자들이 담긴 DB가 사용이 중지 된다면 어떤 일이 발생할까요?

서비스 자체가 무너질 수 있습니다.

따라서 3개의 DB를 만들고, 사용자의 정보를 동시에 3개의 DB에 저장합니다.

메인 DB가 무너져도, 2번 3번 DB가 살아있다면 서비스는 계속해서 유지될 수 있습니다.

### 준비사항
- NODE JS와 DOCKER가 깔려있어야 합니다.
- docker-compose up --build시 에러가 발생합니다. docker-compose up을 사용해주세요.

### 단계
- mongo replication 옵션을 설정한 mongo.conf를 이용해 Dockerfile 작성하기

- Replica Set을 설정하기위한 replicaSet.js와 setup.sh 만들기

- 3개의 mongo-rs 컨테이너와 setup-rs 컨테이너를 실행하는 Docker compose 작성

### 1.mongo replication 옵션을 설정한 mongo.conf를 이용해 Dockerfile 작성하기

*[mongo.conf](./mongo-rs0-1/mongo.conf)*

oplogSizeMB 는 Replication 을 위해사용되는 로그파일의 용량을 지정하는 것입니다.

메뉴얼에 따르면 파일시스템의 활용가능한 5% 를 지정하라고 되어 있습니다.


### 2.Replica Set을 설정하기위한 replicaSet.js와 setup.sh 만들기
*[replicaSet.js](./setup/replicaSet.js)*

*[setup.sh](./setup/setup.sh)*

mongodb에는 replica set을 위한 명령어가 따로 존재하고 있습니다.

rs.initiate()을 통해 클러스터 혹은 레플리카셋을 만들 수 있고

정상적으로 레플리카 설정이 되었는지 확인하려면

rs.conf() 또는 rs.status()를 통해 확인할 수 있습니다.

우리는 이것을 컨테이너 내에서 실행시켜야 하기 때문에 우선 js 파일을 만들고

js파일 내의 설정들을 setup.sh의 쉘 스크립트를 통해 실행시키도록 합니다.

### 3.3개의 mongo-rs 컨테이너와 setup-rs 컨테이너를 실행하는 Docker compose 작성
*[docker-compose.sh](./docker-compose.yaml)*

지금까지 레플리카셋을 하기 위해 많은 단계를 거쳐왔습니다.

이제 docker-compose를 통해 3 개의 mongo-rs 컨테이너와 setup-rs 컨테이너를 실행해봅시다.

## MONGO DUMP with Docker
만약, 사용자들의 DB가 소실되는 사고가 발생하면 어떡할까요?

그동안의 서비스 내역이 모두 사라지는 참사가 발생할 수 있습니다.

하지만 백업을 마련해둔다면 그러한 사고에 대비할 수 있습니다.

### 단계
- 자동 백업을 위해 backup.sh를 작성합니다.
- 리눅스의 crontab을 통해 지정된 시간에 자동으로 백업될 수 있도록 합니다.

### 1.자동 백업을 위해 backup.sh를 작성합니다.
*[backup.sh](./setup/backup.sh)*

mongodump 명령어를 통해 원하는 위치에 gzip형태로 저장합니다.

### 2.리눅스의 crontab을 통해 지정된 시간에 자동으로 백업될 수 있도록 합니다.

0 4 * * * sh ./mongo-docker-backup.sh

### 참고
1.백업 명령어

docker exec mongo sh -c 'mongodump --archive --gzip -v' > backup-`date +%F_%R`.tar.gz

2.복구 명령어
docker exec -i mongo sh -c 'mongorestore --archive --gzip -v' < backup.tar.gz
