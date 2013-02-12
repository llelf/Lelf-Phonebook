use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Lelf::Phonebook';
use Lelf::Phonebook::Controller::Lelf::Phonebook::API;

ok( request('/lelf/phonebook/api')->is_success, 'Request should succeed' );
done_testing();
