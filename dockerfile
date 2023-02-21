FROM gradle:jdk8 AS build
COPY --chown=gradle:gradle . /app
WORKDIR /app
RUN gradle build --no-daemon 
#added lines
jdeps --list-deps /app/build/libs/*.jar > deps.txt

#end


FROM tomcat:jre8-alpine

EXPOSE 8080

RUN mkdir /app
COPY --from=build /app/build/libs/*.jar /app/caesar-cipher.jar
#added lines
COPY --from=build /home/gradle/src/deps.txt .

RUN MODULES=$(sed 's/,//g' deps.txt | tr '\n' ',' | sed 's/.$//'); \
    jlink --module-path $JAVA_HOME/jmods --add-modules $MODULES --output caesar-cipher
#end

ENTRYPOINT ["java","-jar","/app/caesar-cipher.jar"]



# # Build stage
# FROM gradle:7.1.0-jdk11-hotspot AS build

# # Copy Gradle project files
# COPY --chown=gradle:gradle . /home/gradle/src

# # Build project and generate list of required modules
# WORKDIR /home/gradle/src
# RUN gradle build
# RUN jdeps --list-deps build/libs/myapp.jar > deps.txt

# # Create custom runtime image
# FROM adoptopenjdk:11-jre-hotspot AS runtime
# WORKDIR /app
# COPY --from=build /home/gradle/src/deps.txt .
# RUN MODULES=$(sed 's/,//g' deps.txt | tr '\n' ',' | sed 's/.$//'); \
#     jlink --module-path $JAVA_HOME/jmods --add-modules $MODULES --output myapp-image

# # Final image
# FROM adoptopenjdk:11-jre-hotspot
# WORKDIR /app
# COPY --from=runtime /app/myapp-image .

# # Run application
# CMD ["java", "--module", "myapp/com.example.Main"]
