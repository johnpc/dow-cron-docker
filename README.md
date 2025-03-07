# dow-cron

A dockerized version of [sonarr-dow](https://gitlab.com/ddb_db/sonarr-dow) that runs on a schedule.

## What is sonarr-dow?

sonarr-dow is a CLI tool that untracks Sonarr shows with the `dow` and `dow-<n>` tag. This allows you to:

- Track shows only on specific days of the week
- Automatically manage your Sonarr shows based on day-of-week tagging

For example, if The Daily Show airs every day, but you only want to watch episodes hosted by Jon Stewart on Mondays, you can tag the show with `dow-1` in Sonarr. This container will ensure only Monday episodes are tracked.

## How It Works

- The container downloads and runs the latest version of sonarr-dow
- A cron job executes the tool every hour
- Shows with `dow` or `dow-<n>` tags are processed automatically

## Usage

1. Create a `docker-compose.yaml` file:

```yaml
version: '3'

services:
  dow-cron:
    image: mrorbitman/dow-cron:latest
    container_name: dow-cron
    restart: unless-stopped
    environment:
      - SONARR_URL=http://sonarr:8989  # Replace with your Sonarr URL
      - SONARR_API_KEY=your_api_key    # Replace with your Sonarr API key
      - TZ=UTC                         # Set your timezone
    volumes:
      - ./logs:/var/log                # Optional: Map logs directory to host
```

2. Start the container:

```bash
docker-compose up -d
```

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| SONARR_URL | URL to your Sonarr instance | http://sonarr:8989 |
| SONARR_API_KEY | Your Sonarr API key | abc123def456 |
| TZ | Timezone | UTC, America/New_York |

## Tag Format

In Sonarr, add tags to your shows in the following format:

- `dow`: Indicates that `dow` should consider this series
- `dow-0`: Indicates episodes on Sunday are wanted
- `dow-1`: Indicates episodes on Monday are wanted
- `dow-2`: Indicates episodes on Tuesday are wanted
- `dow-3`: Indicates episodes on Wednesday are wanted
- `dow-4`: Indicates episodes on Thursday are wanted
- `dow-5`: Indicates episodes on Friday are wanted
- `dow-6`: Indicates episodes on Saturday are wanted
