use strict;
use warnings;

use Lelf::Phonebook;

my $app = Lelf::Phonebook->apply_default_middlewares(Lelf::Phonebook->psgi_app);
$app;

