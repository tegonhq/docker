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
docker compose up
```

### Stopping the Docker containers

1. Run the stop script

```bash
docker compose down
```

### Deploying Tasks

To deploy and run tasks (powered by Trigger.dev), follow these steps:

1. Create a Docker Hub account at [hub.docker.com](https://hub.docker.com/) and login locally:

```bash
docker login
```

2. Clone the main Tegon repository and set up environment variables:

```bash
git clone https://github.com/tegonhq/tegon.git
cd tegon
```

3. Configure your environment variables in `.env`. The following variables are essential for tasks:

   - `BASE_HOST`: Your instance URL
   - `DATABASE_URL`: Your database connection string
   - `TRIGGER_API_KEY`: Your Trigger.dev API key
   - `TRIGGER_API_URL`: Your Trigger.dev API URL

   You can find the complete list of required variables in `trigger.config.ts`.

4. After successful deployment, navigate to your Tegon instance's Settings -> Actions to install and configure the necessary actions for your workflows.
