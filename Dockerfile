FROM openjdk:17-jdk
EXPOSE 8080
ADD target/spring-project-2-0.0.1-SNAPSHOT.war spring-project-0.0.1-SNAPSHOT.war
ENTRYPOINT ["java", "-war", "/spring-project-2-0.0.1-SNAPSHOT.war"]
