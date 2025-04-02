# Use the official .NET SDK image as a base
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Clone the BTCPayServer repo
RUN git clone --depth=1 https://github.com/btcpayserver/btcpayserver.git .
RUN dotnet publish -c Release -o out

# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy the compiled app from the build stage
COPY --from=build-env /app/out .

# Expose BTCPayServer port
EXPOSE 23000

# Run the server
ENTRYPOINT ["dotnet", "BTCPayServer.dll"]
