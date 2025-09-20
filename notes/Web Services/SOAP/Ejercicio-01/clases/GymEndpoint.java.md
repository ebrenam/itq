[[Práctica SOAP Services]]

```java
package com.gym.reservation.service;

import org.springframework.ws.server.endpoint.annotation.Endpoint;
import org.springframework.ws.server.endpoint.annotation.PayloadRoot;
import org.springframework.ws.server.endpoint.annotation.RequestPayload;
import org.springframework.ws.server.endpoint.annotation.ResponsePayload;

import com.gym.reservation.dto.Confirmation;
import com.gym.reservation.dto.Reservation;

@Endpoint
public class GymEndpoint {

	private static final String NAMESPACE_URI = "http://com.gym";

	@PayloadRoot(namespace = NAMESPACE_URI, localPart = "reservation")
	@ResponsePayload
	public Confirmation createReservation(@RequestPayload Reservation request) {
		Confirmation response = new Confirmation ();
		
		response.setIdReservation(123);
		response.setIdRoom(20);
		response.setInstructor("Paquito");
		
		return response;		
	}
}
```

[[Práctica SOAP Services]]