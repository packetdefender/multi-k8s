#Build Docker images
docker build -t mlossmann/multi-client:latest -t mlossmann/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t mlossmann/multi-server:latest -t mlossmann/multi-server:$SHA -f ./server/Dockerfile ./server
docker built -t mlossmann/multi-worker:latest -t mlossmann/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#Push images to docker
docker push mlossmann/multi-client:latest 
docker push mlossmann/multi-server:latest
docker push mlossmann/multi-worker:latest
docker push mlossmann/multi-client:$SHA
docker push mlossmann/multi-server:$SHA
docker push mlossmann/multi-worker:$SHA

# Take k8s configs and apply them
kubectl apply -f k8s

#Set imperative for image upgrade
kubectl set image deployments/server-deployment server=mlossmann/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=mlossmann/multi-worker:$SHA
kubectl set image deployments/client-deployment client=mlossmann/multi-client:$SHA