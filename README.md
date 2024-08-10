Build the project

### Grupo docker no linux

Crie um grupo para o docker
```shell
sudo groupadd docker
```

Adicione seu usuário para o grupo
```shell
sudo usermod -aG docker $USER
```

### Docker Compose v2
```shell
sudo docker compose up --build 
```
```shell
docker compose run web rake db:drop db:create db:migrate db:seed
```
```shell
docker compose up
```

**Depois disso a aplicação já pode ser acessada em http://localhost:3000/**
## Rodar testes

```shell
docker compose run --rm web rspec
```
