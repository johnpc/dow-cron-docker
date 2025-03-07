FROM golang:1.21

RUN apt-get update && apt-get install -y \
    libstdc++6 \
    ca-certificates \
    bash \
    tzdata \
    curl \
    jq \
    cron

# Set up working directory
WORKDIR /app

# Copy dow binaries from bin directory
COPY bin/dow-amd64 /app/dow-amd64
COPY bin/dow-arm64 /app/dow-arm64
COPY dow-runner.sh /app/dow-runner.sh

# Make the script executable
RUN chmod +x /app/dow-runner.sh /app/dow-amd64 /app/dow-arm64

# Create log directory
RUN mkdir -p /var/log

# Set up cron job
RUN echo "0 * * * * root /app/dow-runner.sh >> /var/log/dow-cron.log 2>&1" > /etc/cron.d/dow-cron && \
    chmod 0644 /etc/cron.d/dow-cron

# Create entrypoint script
RUN echo '#!/bin/bash\n\
# Write environment variables to /etc/environment\n\
env | grep -E "^(SONARR_URL|SONARR_API_KEY|TZ)" > /etc/environment\n\
\n\
# Start cron in foreground\n\
cron -f' > /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]