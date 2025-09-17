# POM

- Dependency

```bash
		<dependency>
			<groupId>wsdl4j</groupId>
			<artifactId>wsdl4j</artifactId>
		</dependency>

		<dependency>
		    <groupId>jakarta.xml.bind</groupId>
		    <artifactId>jakarta.xml.bind-api</artifactId>
		    <version>3.0.1</version>
		</dependency>

		<dependency>
		    <groupId>org.glassfish.jaxb</groupId>
		    <artifactId>jaxb-runtime</artifactId>
		    <version>3.0.1</version>
		</dependency>
```

- Plugin

```bash
			<plugin>
               <groupId>org.codehaus.mojo</groupId>
               <artifactId>jaxb2-maven-plugin</artifactId>
               <version>3.1.0</version>
               <executions>
                   <execution>
                       <goals>
                           <goal>xjc</goal>
                       </goals>
                       <configuration>
                           <sources>
                               <source>${project.basedir}/src/main/resources/xsd</source>
                           </sources>
                           <outputDirectory>${project.build.directory}/generated-sources/jaxb</outputDirectory>
                           <packageName>com.gym.reservation.dto</packageName>
                           <clearOutputDir>true</clearOutputDir>
                       </configuration>
                   </execution>
               </executions>
           </plugin>
```
