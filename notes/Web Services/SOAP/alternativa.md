- Creación de proyecto desde línea de comando.

```bash
mvn io.quarkus.platform:quarkus-maven-plugin:3.5.3:create \
-DprojectGroupId=com.tac \
-DprojectArtifactId=service-facility \
-Dextensions="quarkus-resteasy-reactive, \
quarkus-resteasy-reactive-jackson, \
quarkus-smallrye-health, \
quarkus-smallrye-openapi, \
quarkus-config-yaml, \
quarkus-openapi-generator, \
quarkus-rest-client-reactive-jackson"
```

```bash
# Crear un proyecto Spring Boot desde la línea de comando usando Maven

mvn archetype:generate \
  -DgroupId=com.ejemplo \
  -DartifactId=mi-proyecto-spring \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DinteractiveMode=false
```

```bash
# Utilizando Spring Boot CLI

spring init --dependencies=web,data-jpa,h2 \
  --groupId=com.ejemplo \
  --artifactId=mi-proyecto-spring
```
