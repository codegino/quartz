# Hosting n8n for Free with Railway

[🖥 INFRASTRUCTURE](https://www.alexhyett.com/cloud-infrastructure/)

by [Alex Hyett](https://www.alexhyett.com/about/) |  6 min read

 Published: 30 January 2023

 Updated: 19 April 2023

- [What is n8n?](https://www.alexhyett.com/hosting-n8n-railway/#what-is-n8n)
- [Running n8n](https://www.alexhyett.com/hosting-n8n-railway/#running-n8n)
- [Hosting with Railway](https://www.alexhyett.com/hosting-n8n-railway/#hosting-with-railway)

I have been using n8n for a couple of months now, and it has allowed me to automate so much of my daily workflow.

These are some of the automations I now have set up with n8n:

- When a new blog post is published with [Strapi](https://strapi.io/),
    - Kick off GitHub Actions to deploy blog
    - Republish Blog post to [Hashnode](https://blog.alexhyett.com/), [Dev.to](https://dev.to/alexhyettdev) and [Medium](https://alexhyett.medium.com/)
    - Update my content calendar with the URL and set to Published
    - Add post to my keyword tracking spreadsheet
- Update my content calendar when I publish a new video on [YouTube](https://youtube.com/@alexhyettdev)
- [Schedule tweets to Twitter](https://www.alexhyett.com/automate-twitter-with-notion-and-n8n/) at the most optimum times
- Sync my want to read books on Goodreads to an Airtable

If I were to code all of these automations myself, it would have taken more than a couple of weeks to set up each one, once you take account of infrastructure and everything else.

## [](https://www.alexhyett.com/hosting-n8n-railway/#what-is-n8n)What is n8n?

If you haven’t heard of n8n, it is [IFTTT](https://ifttt.com/) and [Zapier](https://zapier.com/) on steroids. It has all the same integrations as the main platforms, but also lets you call custom APIs as well write your own code to do more complicated things.

No-code tools are useful, but when you combine that with a little bit of code as well, they become incredibly powerful.

##### 🚀 Are you looking to level up your engineering career?

You might like my free weekly newsletter, **The Curious Engineer**, where I give career advice and tackle complex engineering topics.

[📨 Don't miss out on this week's issue](https://newsletter.alexhyett.com/subscribe?)

They might not be the best solution to do things at scale, that is where custom solutions really shine, but for automating your daily workflow they are incredibly useful.

## [](https://www.alexhyett.com/hosting-n8n-railway/#running-n8n)Running n8n

There are a number of options for running n8n, and they all have their own pros and cons.

![n8n options](https://res.cloudinary.com/dlgglwrvf/image/upload/v1674812145/n8n_options_70a4401d0d.png)

### [](https://www.alexhyett.com/hosting-n8n-railway/#desktop-application)Desktop Application

You can run n8n as a desktop application. This is great if you just want to try out the tool and see what you can build with it.

If you plan to run any workflows that deal with files, then you will probably need to run the desktop application.

The downside is that any workflows that you need to run on a schedule or be triggered by an external action aren’t going to work unless you leave your computer on all the time.

### [](https://www.alexhyett.com/hosting-n8n-railway/#cloud-host)Cloud Host

N8n offer their own cloud option, however unless you have a lot of automations running for your business it is hard to justify the cost.

The starter plan is slightly more expensive than Zapier, but both platforms only allow you 20 workflows at around £20 a month, which seems a bit steep.

### [](https://www.alexhyett.com/hosting-n8n-railway/#self-host-locally)Self-Host Locally

If you have your own home server such as a Raspberry Pi or something similar, you can run n8n using Docker.

I have my own n8n running on my home server which I use for my personal automations such as backing up my Goodreads list.

If you are using [Traefik as a reverse proxy](https://www.alexhyett.com/traefik-vs-nginx-docker-raspberry-pi/) you can use the following Docker compose file to set up your own instance.

```yaml
version: '3.8'

volumes:
  db_storage:
  n8n_storage:

services:
  postgres:
    image: postgres:11
    restart: always
    environment:
      - POSTGRES_USER
      - POSTGRES_PASSWORD
      - POSTGRES_DB
      - POSTGRES_NON_ROOT_USER
      - POSTGRES_NON_ROOT_PASSWORD
    volumes:
      - db_storage:/var/lib/postgresql/data
      - ./init-data.sh:/docker-entrypoint-initdb.d/init-data.sh
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -h localhost -U ${POSTGRES_USER} -d ${POSTGRES_DB}']
      interval: 5s
      timeout: 5s
      retries: 10

  n8n:
    image: n8nio/n8n
    restart: always
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=${POSTGRES_DB}
      - DB_POSTGRESDB_USER=${POSTGRES_NON_ROOT_USER}
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_NON_ROOT_PASSWORD}
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_HOST=${DOMAIN_NAME}
      - WEBHOOK_URL=https://${DOMAIN_NAME}${N8N_PATH}
      - N8N_BASIC_AUTH_USER
      - N8N_BASIC_AUTH_PASSWORD
      - N8N_PATH=${N8N_PATH}
    #ports:
    #  - 5678:5678
    links:
      - postgres
    volumes:
      - n8n_storage:/home/node/.n8n
    command: /bin/sh -c "n8n start --tunnel"
    depends_on:
      postgres:
        condition: service_healthy
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.n8n.rule=Host(`${DOMAIN_NAME}`)'
      - 'traefik.http.routers.n8n.rule=PathPrefix(`/${SUBFOLDER}{regex:$$|/.*}`)'
      - 'traefik.http.services.n8n.loadbalancer.server.port=5678'
      - 'traefik.http.middlewares.n8n-stripprefix.stripprefix.prefixes=/${SUBFOLDER}'
      - 'traefik.http.routers.n8n.middlewares=n8n-stripprefix'
```

You will also need to set up `.env` file to contain all of your environment variables like this one:

```bash
POSTGRES_USER=admin
POSTGRES_PASSWORD=supersafeadmindbpassword
POSTGRES_DB=n8n

POSTGRES_NON_ROOT_USER=n8n
POSTGRES_NON_ROOT_PASSWORD=supersafenonrootpassword

N8N_BASIC_AUTH_USER=youremail@example.com
N8N_BASIC_AUTH_PASSWORD=nicesecurepasswordhere
N8N_PATH=/n8n/
DOMAIN_NAME=servername
SUBFOLDER=n8n
```

Assuming that your home server is called `servername` then this will make n8n available on `http://servername/n8n`.

Self-hosting locally is useful, but if you don’t have your own server or have an unreliable internet connection, then there is a better option.

## [](https://www.alexhyett.com/hosting-n8n-railway/#hosting-with-railway)Hosting with Railway

I recently discovered [Railway](https://geni.us/Tep69f) as hosting platform. For developers and individual use, they give you $5 of credit every month.

This is enough to cover the cost of running n8n in most cases. Obviously, if you have hundreds of workflows running all the time, it is going to use more resources.

With Railway, you are only charged for what you use, so if your instance is just running idle most of the time it isn’t going to use many resources.

Railway make it really easy to set up services using their templates. The template for n8n can be found on [GitHub](https://github.com/railwayapp-templates/n8n), and there is a button to Deploy to Railway in the readme.

If that doesn’t work, you can select New Project in Railway and search for n8n. It should come up with template.

![n8n template](https://res.cloudinary.com/dlgglwrvf/image/upload/v1674811936/n8n_template_6da6312a4d.png)

Enter the details and click deploy. This will kick off the build of the project.

![n8n Github](https://res.cloudinary.com/dlgglwrvf/image/upload/v1674811936/n8n_github_8e3b784160.png)

After a few minutes, n8n will be deployed and Railway will show you the URL for your instance. It will look something like this `https://n8n-production-837d.up.railway.app`.

If you want to add your own domain, you can do that as well by going to the Settings tab and adding your own custom domain.

![Custom Domain](https://res.cloudinary.com/dlgglwrvf/image/upload/v1674811936/n8n_custom_domain_20ebc4b793.png)

Once added, you need to set up the corresponding CNAME record on your domain.

There are a few more environment variables we also need to set up before we are done. This can be done on the variables tab.

- `N8N_ENCRYPTION_KEY` - If you don’t set your own encryption key, then n8n will generate a new one each time it is deployed. Which means it won’t be able to read any of the credentials that have been stored.
- `N8N_HOST` - Set this to your domain. Either the custom one you have set up or the one you have been given, e.g. `n8n-production-837d.up.railway.app`
- `N8N_PROTOCOL` - Set this to `https`
- `WEBHOOK_URL` - If you want to trigger any of your workflows using a webhook, then it is important to set this. For some reason for me, it didn’t set it to the n8n host e.g. `https://n8n-production-837d.up.railway.app`

Once these have been set, Railway will deploy again and then your instance is ready to use.