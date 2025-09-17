[[Práctica SOAP Services]]

```xml
<?xml version="1.0" encoding="UTF-8"?>
<wsdl:definitions xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:http="http://schemas.xmlsoap.org/wsdl/http/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:mime="http://schemas.xmlsoap.org/wsdl/mime/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://com.gym" targetNamespace="http://com.gym">
	<wsdl:types>
		<xs:schema targetNamespace="http://com.gym" elementFormDefault="qualified">
			<xs:include schemaLocation="gym.xsd"/>
		</xs:schema>
	</wsdl:types>
	<wsdl:message name="CreateReservationMessageRequest">
		<wsdl:part name="parameter" element="tns:reservation"/>
	</wsdl:message>
	<wsdl:message name="CreateReservationMessageResponse">
		<wsdl:part name="parameter" element="tns:ack"/>
	</wsdl:message>
	<wsdl:message name="GetReservationMessageRequest">
		<wsdl:part name="parameter" element="tns:reservationCriteria"/>
	</wsdl:message>
	<wsdl:message name="GetReservationMessageResponse">
		<wsdl:part name="parameter" element="tns:reservation"/>
	</wsdl:message>
	<wsdl:portType name="ReservationPortType">
		<wsdl:operation name="CreateReservationOperation">
			<wsdl:input message="tns:CreateReservationMessageRequest"/>
			<wsdl:output message="tns:CreateReservationMessageResponse"/>
		</wsdl:operation>
		<wsdl:operation name="GetReservationOperation">
			<wsdl:input message="tns:GetReservationMessageRequest"/>
			<wsdl:output message="tns:GetReservationMessageResponse"/>
		</wsdl:operation>
	</wsdl:portType>
	<wsdl:binding name="ReservationBinding" type="tns:ReservationPortType">
		<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
		<wsdl:operation name="CreateReservationOperation">
			<soap:operation soapAction="createReservation"/>
			<wsdl:input>
				<soap:body use="literal"/>
			</wsdl:input>
			<wsdl:output>
				<soap:body use="literal"/>
			</wsdl:output>
		</wsdl:operation>
		<wsdl:operation name="GetReservationOperation">
			<soap:operation soapAction="getReservation"/>
			<wsdl:input>
				<soap:body use="literal"/>
			</wsdl:input>
			<wsdl:output>
				<soap:body use="literal"/>
			</wsdl:output>
		</wsdl:operation>
	</wsdl:binding>
	<wsdl:service name="GymReservationService">
		<wsdl:port name="ReservationPort" binding="tns:ReservationBinding">
			<soap:address location="http://localhost:8080/ws/gym-reservation"/>
		</wsdl:port>
	</wsdl:service>
</wsdl:definitions>
```

[[Práctica SOAP Services]]