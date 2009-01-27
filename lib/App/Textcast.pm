
package App::Textcast ;

use strict;
use warnings ;
use Carp ;

BEGIN 
{

use Sub::Exporter -setup => 
	{
	exports => [ qw() ],
	groups  => 
		{
		all  => [ qw() ],
		}
	};
	
use vars qw ($VERSION);
$VERSION     = '0.01_01';
}

#-------------------------------------------------------------------------------

use English qw( -no_match_vars ) ;

use Readonly ;
Readonly my $EMPTY_STRING => q{} ;

use Carp qw(carp croak confess) ;

#-------------------------------------------------------------------------------

=head1 NAME

App::Textcast - Light weight text casting

=head1 SYNOPSIS

None yet

=head1 DESCRIPTION

As of version 0.01, this module is only a place holder.

=head1 DOCUMENTATION

What's a textcast? it's a screencast of a terminal.

why textcasts? 
	- size, I did a screen cast of completion script, the size was 1.5 MB and
	it didn't look as good as the terminal. The same textcast was 10 KB (yes,
	10 Kilo Bytes) and it looked good. 
	
	The player is 20 lines of perl (on a linux box).

	- it is not possibile to make a screencast of a real terminal, maybe via
	vnc but that's already too complicated

	- documentation. I believe it is sometimes better to show things "live" 
	than static text so I am planning to write a module that plays a textcast
	embeded in ones terminal. the text cast being controlled by the application
	that displays help. I also believe that it could be used as a complement
	to showing static logs or screenshots; an example is when someone describe
	a problem on IRC. seeing what is being done is sometimes very helpful.

Your input is very welcome, this is the right time to do it.

=head1 SUBROUTINES/METHODS

=cut


#-------------------------------------------------------------------------------

Readonly my $NEW_ARGUMENTS => [qw(NAME INTERACTION)] ;

sub new
{

=head2 new( xxx )

Create a App::Textcast .  

  my $object = new App::Textcast() ;

I<Arguments>

=over 2 

=item * $xxx - 

=back

I<Returns> - Nothing

I<Exceptions>

See C<xxx>.

=cut

my ($invocant, @setup_data) = @_ ;

my $class = ref($invocant) || $invocant ;
confess 'Invalid constructor call!' unless defined $class ;

my $object = {} ;

my ($package, $file_name, $line) = caller() ;
bless $object, $class ;

$object->Setup($package, $file_name, $line, @setup_data) ;

return($object) ;
}

#-------------------------------------------------------------------------------

sub Setup
{

=head2 Setup

Helper sub called by new. This is a private sub.

=cut

my ($self, $package, $file_name, $line, @setup_data) = @_ ;

if (@setup_data % 2)
	{
	croak "Invalid number of argument '$file_name, $line'!" ;
	}

$self->CheckOptionNames($NEW_ARGUMENTS, @setup_data) ;

%{$self} = 
	(
	NAME                   => 'Anonymous',
	FILE                   => $file_name,
	LINE                   => $line,
	
	@setup_data,
	) ;

my $location = "$self->{FILE}:$self->{LINE}" ;

$self->{INTERACTION}{INFO} ||= sub {print @_} ;
$self->{INTERACTION}{WARN} ||= \&Carp::carp ;
$self->{INTERACTION}{DIE}  ||= \&Carp::confess ;


if($self->{VERBOSE})
	{
	$self->{INTERACTION}{INFO}('Creating ' . ref($self) . " '$self->{NAME}' at $location.\n") ;
	}

return(1) ;
}

#-------------------------------------------------------------------------------

sub CheckOptionNames
{

=head2 CheckOptionNames

Verifies the named options passed to the members of this class. Calls B<{INTERACTION}{DIE}> in case
of error. This shall not be used directly.

=cut

my ($self, $valid_options, @options) = @_ ;

if (@options % 2)
	{
	$self->{INTERACTION}{DIE}->('Invalid number of argument!') ;
	}

if('HASH' eq ref $valid_options)
	{
	# OK
	}
elsif('ARRAY' eq ref $valid_options)
	{
	$valid_options = map{$_ => 1} @{$valid_options} ;
	}
else
	{
	$self->{INTERACTION}{DIE}->("Invalid argument '$valid_options'!") ;
	}

my %options = @options ;

for my $option_name (keys %options)
	{
	unless(exists $valid_options->{$option_name})
		{
		$self->{INTERACTION}{DIE}->("$self->{NAME}: Invalid Option '$option_name' at '$self->{FILE}:$self->{LINE}'!")  ;
		}
	}

if
	(
	   (defined $options{FILE} && ! defined $options{LINE})
	|| (!defined $options{FILE} && defined $options{LINE})
	)
	{
	$self->{INTERACTION}{DIE}->("$self->{NAME}: Incomplete option FILE::LINE!") ;
	}

return(1) ;
}

#-------------------------------------------------------------------------------

sub A
{

=head2 A( xxx )

xxx description

  xxx some code

I<Arguments>

=over 2 

=item * $xxx - 

=back

I<Returns> - Nothing

I<Exceptions>

See C<xxx>.

=cut

my ($self) = @_ ;

if(defined $self && __PACKAGE__ eq ref $self)
	{
	# object sub
	my ($var, $var2) = @_ ;
	
	}
else	
	{
	# class sub
	unshift @_, $self ;
	}

return(0) ;
}

#-------------------------------------------------------------------------------

1 ;

=head1 BUGS AND LIMITATIONS

None so far.

=head1 AUTHOR

	Nadim ibn hamouda el Khemir
	CPAN ID: NH
	mailto: nadim@cpan.org

=head1 LICENSE AND COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Textcast

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Textcast>

=item * RT: CPAN's request tracker

Please report any bugs or feature requests to  L <bug-app-textcast@rt.cpan.org>.

We will be notified, and then you'll automatically be notified of progress on
your bug as we make changes.

=item * Search CPAN

L<http://search.cpan.org/dist/App-Textcast>

=back

=head1 SEE ALSO


=cut
