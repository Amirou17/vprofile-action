# Stage 1: Build
FROM eclipse-temurin:11-jdk AS BUILD_IMAGE

RUN apt-get update && apt-get install -y maven

WORKDIR /app
COPY . .

RUN mvn clean install -DskipTests

# Stage 2: Run
FROM tomcat:9.0-jdk11-temurin

LABEL project="Vprofile"
LABEL author="Imran"

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=BUILD_IMAGE /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]