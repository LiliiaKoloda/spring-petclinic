FROM maven:3.5-jdk-8

WORKDIR /workspace

ADD pom.xml /workspace/CI_CD-spring-petlinic/pom.xml
ADD src /workspace/CI_CD-spring-petlinic/src

FROM java:8-jre

COPY --from=0 /target/spring-petclinic-2.7.0-SNAPSHOT.jar /

# expose http and debug ports
EXPOSE 8080 8000

CMD ["java", "-agentlib:jdwp=transport=dt_socket,server=y,address=8000,suspend=n", "-jar", "spring-petclinic-2.7.0-SNAPSHOT.jar"]
