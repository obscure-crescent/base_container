FROM mcr.microsoft.com/dotnet/sdk:9.0 as BUILD

COPY MareAPI /server/MareAPI
COPY MareSynchronosServer /server/MareSynchronosServer

WORKDIR /server/MareSynchronosServer

RUN dotnet publish \
        --configuration=Debug \
        --os=linux \
        --output=/build \
        /server/MareSynchronosServer/MareSynchronosAuthService/MareSynchronosAuthService.csproj

RUN dotnet publish \
        --configuration=Debug \
        --os=linux \
        --output=/build \
        /server/MareSynchronosServer/MareSynchronosServer/MareSynchronosServer.csproj

RUN dotnet publish \
        --configuration=Debug \
        --os=linux \
        --output=/build \
        /server/MareSynchronosServer/MareSynchronosServices/MareSynchronosServices.csproj

RUN dotnet publish \
        --configuration=Debug \
        --os=linux \
        --output=/build \
        /server/MareSynchronosServer/MareSynchronosStaticFilesServer/MareSynchronosStaticFilesServer.csproj

RUN dotnet publish \
        --configuration=Debug \
        --os=linux \
        --output=/build \
        /server/MareSynchronosServer/MareSynchronosShared/MareSynchronosShared.csproj
            
# FROM mcr.microsoft.com/dotnet/aspnet:9.0

# RUN adduser \
#         --disabled-password \
#         --group \
#         --no-create-home \
#         --quiet \
#         --system \
#         mare

# COPY --from=BUILD /build /opt/MareSynchronosAuthService
# RUN chown -R mare:mare /opt/MareSynchronosAuthService
# RUN apt-get update; apt-get install curl -y

# USER mare:mare
# WORKDIR /opt/MareSynchronosAuthService

# CMD ["./MareSynchronosAuthService"]
