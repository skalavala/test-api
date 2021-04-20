FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["test-webapi.csproj", "./"]
RUN dotnet restore "test-webapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "test-webapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "test-webapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "test-webapi.dll"]

######################################################################
# 1. Run the following command to create the image
# docker run -it --rm -p 8080:80 skalavala/test-webapi:v1
# 2. Run the following command to run the container
# docker build -t skalavala/test-webapi:v1 .
######################################################################