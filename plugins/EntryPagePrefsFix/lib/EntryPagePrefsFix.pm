package EntryPagePrefsFix;

use Data::Dumper;
use JSON;
use MT::Util;

sub post_load {
    my $cb = shift;
    my ($obj, $orig) = @_;
    print STDERR "post_load obj: ".$obj->entry_prefs."\n" if $obj;
    print STDERR "post_load orig: ".$orig->entry_prefs."\n" if $orig;
    print STDERR JSON::from_json('{"body":339,"fields":",title,text,customfield_article_thumbnail_image,customfield_link_to_local_article_archive,customfield_pdf_archive_of_article,excerpt,category,publishing","pos":"Top"}')."\n";
}

sub pre_save {
    my $cb = shift;
    my ($obj, $orig) = @_;

    my ($data, $pos, @custom_fields, %param);
    if ( my $prefs = ($obj->column('entry_prefs') || $orig->column('entry_prefs'))) { 

        print STDERR "pre_save obj: $prefs\n";

        ( $prefs, $data->{pos} ) = split /\|/, $prefs;

        if ( $prefs =~ s{^body:(\d+)}{}g ) {
            $data->{body} = $1;
        }

        MT->instance->_parse_entry_prefs( $prefs, \%param, \@custom_fields );
        
        my %seen = ();
        $data->{fields} = join( ',',    map { $_->{name} }
                                        grep { ! $seen{$_->{name}}++ } @custom_fields);
    }

    print STDERR MT::Util::to_json($data)."\n";

}


1;