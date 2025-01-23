## to build the docker container:
docker-compose up --build


## to run in detached mode:
docker-compose up -d


## to check logs:
docker-compose logs -f


## to stop the containr:
docker-compose down




## Using the API:


- run a model:
```c
curl -X POST "http://localhost:8080/run" -H "Content-Type: application/json" -d '{"prompt": "Hello!", "model": "llama3.1:latest"}'
```

- switch to another model:
```c
curl -X POST "http://localhost:8080/switch" -H "Content-Type: application/json" -d '{"model": "llama3.2:latest"}'

```

## to access a model:
```c
curl --location 'http://localhost:11434/api/generate' \
--header 'Content-Type: application/json' \
--data '{
  "model": "llama3.1",
  "prompt":"Write a C code to find the longest common substring in two strings.",
  "stream": false
 }'
 ```