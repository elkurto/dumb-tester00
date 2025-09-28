package a.b.dumbtester00.service;

import java.text.MessageFormat;

public class UtilityA {
    Long id;
    UtilityA(long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public Author createAuthor( Long id ) {
        String name =computeAuthorNameFromId( id );
        Author author = new Author(id, name);

        return author;
    }

    public String computeAuthorNameFromId( Long id ) {
        return MessageFormat.format( "name_{0}", id);
    }

    public void computeAndSetEmail( Author author ) {
        String email = computeEmailFromAuthor( author );
        author.setEmail( email );
    }

    public String computeEmailFromAuthor( Author author ) {
        return MessageFormat.format( "email_{0}", author.getEmail());
    }


}
