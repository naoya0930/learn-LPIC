
docker build -t lean-linux .   

docker run -it -v "$(pwd)/work":/workspace lean-linux