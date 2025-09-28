package a.b.dumbtester00.service;

import java.text.MessageFormat;

public class ClientA {
    Long id;
    UtilityA utilityA;

    ClientA() {
        this.utilityA =new UtilityA(1L );
        this.id =utilityA.getId();
    }
    ClientA( UtilityA utilityA) {

        this.utilityA =utilityA;
        this.id = utilityA.getId();
    }

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public UtilityA getUtilityA() {
        return utilityA;
    }

    public void setUtilityA(UtilityA utilityA) {
        this.utilityA = utilityA;
    }

    public Author createAuthorById(Long id ) {
        return this.utilityA.createAuthor(id);
    }




}
