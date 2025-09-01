# syntax=docker/dockerfile:1.6
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

# Copy sources
COPY MareAPI /server/MareAPI
COPY MareSynchronosServer /server/MareSynchronosServer

WORKDIR /server

# Publish all relevant projects using a simple loop.
# Format per line: <OutputFolder>|<AbsolutePathToCsprojFromWORKDIR>
RUN set -eux; \
    while IFS='|' read -r out proj; do \
        [ -z "$out" ] && continue; \
        echo "Publishing $proj -> /build/$out"; \
        dotnet publish \
            --configuration Debug \
            --os linux \
            --output "/build/${out}" \
            "$proj"; \
    done <<'EOF'
MareSynchronosAuthService|/server/MareSynchronosServer/MareSynchronosAuthService/MareSynchronosAuthService.csproj
MareSynchronosServer|/server/MareSynchronosServer/MareSynchronosServer/MareSynchronosServer.csproj
MareSynchronosServices|/server/MareSynchronosServer/MareSynchronosServices/MareSynchronosServices.csproj
MareSynchronosStaticFilesServer|/server/MareSynchronosServer/MareSynchronosStaticFilesServer/MareSynchronosStaticFilesServer.csproj
MareSynchronosShared|/server/MareSynchronosServer/MareSynchronosShared/MareSynchronosShared.csproj
EOF

FROM mcr.microsoft.com/dotnet/aspnet:9.0
RUN adduser --disabled-password --group --no-create-home --quiet --system mare \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
USER mare:mare
COPY --from=build /build/* /opt/
# CMD ["./MareSynchronosAuthService"]
