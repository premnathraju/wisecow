FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        cowsay \
        fortune-mod \
        netcat && \
    rm -rf /var/lib/apt/lists/*

# Copy script
COPY wisecow.sh /app/wisecow.sh

WORKDIR /app

# Fix line endings and make executable
RUN sed -i 's/\r$//' wisecow.sh
RUN chmod +x wisecow.sh

# Expose port
EXPOSE 4499

# Run the script
CMD ["./wisecow.sh"]