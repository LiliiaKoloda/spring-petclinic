FROM maven:3.5-jdk-8

WORKDIR /code

ADD pom.xml /code/pom.xml
ADD src /code/src
RUN ["mvn", "package", "-DskipTests=true"]

FROM java:8-jre

COPY --from=0 /code/target/spring-petclinic-2.0.0.BUILD-SNAPSHOT.jar /

# expose http and debug ports
EXPOSE 8080 8000

CMD ["java", "-agentlib:jdwp=transport=dt_socket,server=y,address=8000,suspend=n", "-jar", "spring-petclinic-2.0.0.BUILD-SNAPSHOT.jar"]
