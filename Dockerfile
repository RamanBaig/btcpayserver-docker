# Use the official .NET SDK image as a base
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y git

# Clone the BTCPayServer repo
RUN git clone --depth=1 https://github.com/btcpayserver/btcpayserver.git /app/btcpayserver

# Move into the correct directory where the solution file is located
WORKDIR /app/btcpayserver

# Restore and build BTCPayServer
RUN dotnet restore BTCPayServer.sln
RUN dotnet build BTCPayServer.sln -c Release
RUN dotnet publish BTCPayServer.sln -c Release -o out

# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy the compiled app from the build stage
COPY --from=build-env /app/btcpayserver/out .

# Expose BTCPayServer port
EXPOSE 23000

# Run the server
ENTRYPOINT ["dotnet", "BTCPayServer.dll"]
