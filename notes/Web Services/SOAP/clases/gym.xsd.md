[[Práctica SOAP Services]]

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified" xmlns:tns="http://com.gym" targetNamespace="http://com.gym">
	<xs:element name="reservation">  <!--Título-->
		<xs:annotation>
			<xs:documentation>Este elemento contiene la estructura de la información relacionada con una reservación</xs:documentation>
		</xs:annotation>
		
		<!--Tipo complejo, conformado de muchos elementos-->
		<xs:complexType>
			<!--Elementos pueden ser simples o complejos-->
			<xs:sequence>
				<!--El identificador del cliente está formado por dos caracteres que indican si se trata de un cliente básico (BC) o
				de un cliente premium (PC), seguido de un guión fy tres dígitos que indican un consecutivo. Por ejemplo, BC-001,
				PC-238-->
				<xs:element name="idClient">
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xs:pattern value="[B|P]-C[0-9](3)"> </xs:pattern>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>
				
				<xs:element name="activity">
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xs:minLength value="5"> </xs:minLength>
							<xs:maxLength value="255"> </xs:maxLength>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>

				<xs:element name="dayOfWeek">
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xs:enumeration value="Lun"></xs:enumeration>
							<xs:enumeration value="Mar"></xs:enumeration>
							<xs:enumeration value="Mie"></xs:enumeration>
							<xs:enumeration value="Jue"></xs:enumeration>
							<xs:enumeration value="Vie"></xs:enumeration>
							<xs:enumeration value="Sab"></xs:enumeration>
							<xs:enumeration value="Dom"></xs:enumeration>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>
				
				<xs:element name="time" type="xs:string"></xs:element>
				
			</xs:sequence>		
		</xs:complexType>
	</xs:element>
	
	<xs:element name="confirmation">
	
		<xs:complexType>
			<xs:sequence>
				<xs:element name="idReservation" type="xs:int"> </xs:element>
				
				<xs:element name="idRoom"> 
					<xs:simpleType>
						<xs:restriction base="xs:int">
							<xs:minInclusive value="1"></xs:minInclusive>
							<xs:maxExclusive value="21"></xs:maxExclusive>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>

				<xs:element name="instructor" minOccurs="0">
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xs:maxLength value="255"></xs:maxLength>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>
				
				<xs:element name="discount" minOccurs="0"> 
					<xs:simpleType>
						<xs:restriction base="xs:decimal">
							<xs:totalDigits value="2"></xs:totalDigits>
							<xs:fractionDigits value="2"></xs:fractionDigits>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>
				
			</xs:sequence>
		</xs:complexType>
	</xs:element>
	
	<xs:element name="SearchCriteria">
	
		<xs:complexType>
			<xs:sequence>
				 <xs:element name="idClient">
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xs:pattern value="[B|P]-C[0-9](3)"> </xs:pattern>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>
				<xs:element name="activity">
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xs:minLength value="5"> </xs:minLength>
							<xs:maxLength value="255"> </xs:maxLength>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>

				<xs:element name="dayOfWeek">
					<xs:simpleType>
						<xs:restriction base="xs:string">
							<xs:enumeration value="Lun"></xs:enumeration>
							<xs:enumeration value="Mar"></xs:enumeration>
							<xs:enumeration value="Mie"></xs:enumeration>
							<xs:enumeration value="Jue"></xs:enumeration>
							<xs:enumeration value="Vie"></xs:enumeration>
							<xs:enumeration value="Sab"></xs:enumeration>
							<xs:enumeration value="Dom"></xs:enumeration>
						</xs:restriction>
					</xs:simpleType>
				</xs:element>
				<xs:element name="time" type="xs:string"></xs:element>
			</xs:sequence>
		</xs:complexType>
	</xs:element>
		
		

	<xs:element name="confirmations">
	
		<xs:complexType>
			<xs:sequence>
				 <xs:element name="confirmation" maxOccurs="unbounded" minOccurs="0">
					
				</xs:element>
				
			</xs:sequence>
		</xs:complexType>
	</xs:element>
	
	<xs:element name="cancelReservation">
    <xs:complexType>
        <xs:sequence>
            <xs:element name="idReservation" type="xs:int"/>
        </xs:sequence>
    </xs:complexType>
</xs:element>

	<xs:element name="cancelConfirmation">
    <xs:complexType>
        <xs:sequence>
            <xs:element name="message" type="xs:string"/>
        </xs:sequence>
    </xs:complexType>
</xs:element>
</xs:schema>
```

[[Práctica SOAP Services]]