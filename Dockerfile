FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["TestAspNetCoreWebApi.csproj", "./"]
RUN dotnet restore "TestAspNetCoreWebApi.csproj"
COPY . .
# WORKDIR "/src/."
RUN dotnet build "TestAspNetCoreWebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestAspNetCoreWebApi.csproj" -c Release -o /app/publish

ENV ASPNETCORE_URLS=http://*:8080

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestAspNetCoreWebApi.dll"]

######################################################################
# 1. Run the following command to create the image
# docker run -it --rm -p 8080:80 skalavala/test-aspnet-core-webapi:v1
# 2. Run the following command to run the container
# docker build -t skalavala/test-aspnet-core-webapi:v1 .
######################################################################
