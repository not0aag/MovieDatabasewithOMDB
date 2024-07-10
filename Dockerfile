# Use the latest Ubuntu image as the base for the build stage
FROM ubuntu:latest AS build

# Update the package lists and install necessary tools
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk maven

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container
COPY . .

# Build the project using Maven
RUN mvn clean package

# Use a lightweight OpenJDK 17 image for the final stage
FROM openjdk:17-jdk-slim

# Expose the port the application runs on
EXPOSE 8080

# Set the working directory in the final image
WORKDIR /app

# Copy the built JAR file from the build stage to the final image
COPY --from=build /app/target/myGit-0.0.1-SNAPSHOT.jar app.jar

# Set the entry point to run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]
