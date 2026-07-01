# STAGE 1: Builder
# Downloads and extracts the Debian binary for ARMv5
#FROM arm32v5/debian:bookworm-slim AS builder

#ARG DEBIAN_FRONTEND=noninteractive
#WORKDIR /tmp/build

# Install build dependencies
#RUN apt-get update && \
    #apt-get install -y --no-install-recommends \
        #ca-certificates \
        #curl \
        #jq \
        #tar && \
    #rm -rf /var/lib/apt/lists/*

# Download and extract the latest AdGuardHome release
#RUN set -eux; \
    #AGH_VERSION=$(curl -sL https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | jq -r .tag_name | sed 's/v//'); \
    #echo "Downloading AdGuardHome v${AGH_VERSION}..."; \
    #curl -fSL "https://github.com/AdguardTeam/AdGuardHome/releases/download/v${AGH_VERSION}/AdGuardHome_linux_armv5.tar.gz" -o agh.tar.gz; \
    #tar -xzf agh.tar.gz;

# STAGE 2: Final Runtime
FROM arm32v5/debian:bookworm-slim

# Metadata
LABEL maintainer="OMER KOLSAN" \
      description="Debian Docker image optimized for ARMv5 (legacy devices)"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG=en_US.UTF-8 

# Install critical runtime dependencies
RUN apt-get update && \
    apt-get install -y \
				curl \
				nano\
				openssh-server \
        ca-certificates \
        tzdata \
				iproute2
    #rm -rf /var/lib/apt/lists/*

#WORKDIR /opt/adguardhome

# Copy binary from builder stage
#COPY --from=builder /tmp/build/AdGuardHome/AdGuardHome .

# Setup directories and permissions
#RUN mkdir -p work conf && \
    #chmod +x ./AdGuardHome

# Set root password
RUN echo "root:root" | chpasswd

# Expose Ports
# DNS (53), DHCP (67/68), HTTP/S (80/443), DoT/DoQ (853), DoQ-Alt (784/8853), DNSCrypt (5443), Setup (3000)
#EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 853/tcp 853/udp 784/udp 8853/udp 5443/tcp 5443/udp 3000/tcp

# Start AdGuardHome
#CMD ["./AdGuardHome", \
#     "--work-dir", "/opt/adguardhome/work", \
#     "--config", "/opt/adguardhome/conf/AdGuardHome.yaml"]
CMD ["/bin/sh -c 'service ssh start && sleep infinity'"]