use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Lelf::Phonebook';
use Lelf::Phonebook::Controller::API;

ok( request('/api')->is_success, 'Request should succeed' );
done_testing();
