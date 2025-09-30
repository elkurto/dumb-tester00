package a.b.dumbtester00.service;


import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;
import a.b.dumbtester00.service.UtilityA;

public class UtilityATest {

    @Test
    public void test() {
        assertEquals(1, 1+0);
    }

    @Test
    public void test2() {
        UtilityA utilityA =new UtilityA(757L);
        utilityA.computeAuthorNameFromId( 111L );
    }

}
