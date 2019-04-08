# Base for runtime
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 as base
VOLUME /logs

RUN apt-get update && \
    apt-get install -y curl gnupg apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list' && \
    apt-get update && \
    apt-get install -y powershell

EXPOSE 5000/tcp
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "WebhookToPowerShell.dll"]
WORKDIR /app

# Build from source
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 as builder
COPY . /source
WORKDIR /source

RUN ["dotnet", "publish", "-c", "Release", "-o", "/app"]

# Copy only application binaries from build state container
FROM base as final
COPY --from=builder /app .
