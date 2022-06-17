=head1 PURPOSE

Check Sub::NonRole works when a Moo role is consumed by a Moose class.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


use strict;
use warnings;
use Test::More;

{
	package Local::Role;
	use Moo::Role;
	use Sub::NonRole;
	sub a :NonRole { 42 };
	sub b          { 99 };
}

{
	package Local::Class;
	use Moose;
	with 'Local::Role';
}

can_ok 'Local::Role', 'a';
can_ok 'Local::Role', 'b';
ok(!'Local::Class'->can('a'), 'method hidden correctly');
can_ok 'Local::Class', 'b';

is_deeply(
	[ sort @{ 'Local::Role'->meta->non_role_methods } ],
	[ sort 'a', 'FETCH_CODE_ATTRIBUTES' ],
	'meta',
);

done_testing;
