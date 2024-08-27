# Tegon Self-Hosting Docker

If you want to run the Tegon platform yourself, instead of using [our cloud product](https://tegon.ai), you can use this repository to get started.

It's highly recommended you read our [self-hosting guide](https://docs.tegon.ai/oss/self-host-tegon), which contains more detailed instructions and will be more up-to-date.

## Local development

If you want to self-host the Tegon platform, when you're developing your web app locally you'll need to run the Tegon platform locally as well.

### Initial setup

1. Clone this repository and navigate to it:

```sh
git clone https://github.com/tegonhq/docker.git
cd docker
```

2. Populate any missing .env file values. (See the .env.example file for more instructions)

3. Run the start script and follow the prompts

```bash
./start.sh
```

### Stopping the Docker containers

1. Run the stop script

```bash
./stop.sh
```

### Getting started with using Tegon

You should now be able to access the Tegon dashboard at [http://localhost:8000](http://localhost:8000/).

To create an account

```bash
./create-resources.sh
```

Our main docs are at [docs.tegon.ai](https://docs.tegon.ai/).
