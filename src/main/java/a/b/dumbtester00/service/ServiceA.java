package a.b.dumbtester00.service;

import org.springframework.stereotype.Service;

@Service
public class ServiceA {

    UtilityA utilityA;
    ClientA clientA;
    public ServiceA() {

        utilityA = new UtilityA(0L);
        clientA =new ClientA(utilityA);
    }

    public Author createAuthorById(long authorId) {
        return this.clientA.createAuthorById( authorId );
    }

    public ClientA getClientA() {
        return this.clientA;
    }
    public void setClientA(ClientA clientA) {
        this.clientA = clientA;
    }

}
