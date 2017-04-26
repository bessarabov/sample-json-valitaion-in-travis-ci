
=encoding UTF-8
=cut

=head1 DESCRIPTION

=cut

use strict;
use warnings FATAL => 'all';
use feature 'say';
use utf8;
use open qw(:std :utf8);

use Test::More;
use Carp;
use JSV::Validator;
use File::Slurp;
use JSON::PP;
use lib::abs;
use Data::Dumper;

sub main_in_test {
    pass 'Loaded ok';

    JSV::Validator->load_environments("draft4");
    my $v = JSV::Validator->new(
        environment => "draft4"
    );

    my $schema = decode_json scalar read_file lib::abs::path '../schemas/person.json';

    my @person_files = glob lib::abs::path('../data/') . '/*';

    foreach my $file_name (@person_files) {
        my $json = read_file $file_name ;

        my $result = $v->validate(
            $schema,
            decode_json $json,
        );

        ok( $result, $file_name );
        if (not $result) {
            warn Dumper $result->get_error();
        }
    }


    done_testing();
}
main_in_test();
