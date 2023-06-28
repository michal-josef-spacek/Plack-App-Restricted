package Plack::App::Restricted;

use base qw(Plack::Component::Tags::HTML);
use strict;
use warnings;

use Tags::HTML::Container;

our $VERSION = 0.10;

sub _css {
	my ($self, $env) = @_;

	$self->{'_tags_html_container'}->process_css;

	$self->{'css'}->put(
		['s', '.restricted'],
		['d', 'color', 'red'],
		['d', 'font-family', 'sans-serif'],
		['d', 'font-size', '3em'],
		['e'],
	);

	return;
}

sub _prepare_app {
	my $self = shift;

	# Inherite defaults.
	$self->SUPER::_prepare_app;

	$self->{'_tags_html_container'} = Tags::HTML::Container->new(
		'css' => $self->css,
		'tags' => $self->tags,
	);

	return;
}

sub _tags_middle {
	my ($self, $env) = @_;

	$self->{'_tags_html_container'}->process(
		sub {
			my $self = shift;

			$self->{'tags'}->put(
				['b', 'div'],
				['a', 'class', 'restricted'],
				['d', 'Restricted access'],
				['e', 'div'],
			);

			return;
		},
	);

	return;
}


1;

__END__

=pod

=encoding utf8

=head1 NAME

Plack::App::Restricted - Plack application for restricted state.

=head1 SYNOPSIS

 use Plack::App::Restricted;

 my $obj = Plack::App::Restricted->new(%parameters);
 my $psgi_ar = $obj->call($env);
 my $app = $obj->to_app;

=head1 METHODS

=head2 C<new>

 my $obj = Plack::App::Restricted->new(%parameters);

Constructor.

Returns instance of object.

=head2 C<call>

 my $psgi_ar = $obj->call($env);

Implementation of env dump.

Returns reference to array (PSGI structure).

=head2 C<to_app>

 my $app = $obj->to_app;

Creates Plack application.

Returns Plack::Component object.

=head1 EXAMPLE

=for comment filename=plack_app_restricted.pl

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Plack::App::Restricted;
 use Plack::Runner;
 use Tags::Output::Indent;

 # Run application.
 my $app = Plack::App::Restricted->new(
         'css' => CSS::Struct::Output::Indent->new,
         'tags' => Tags::Output::Indent->new(
                 'preserved' => ['style'],
         ),
 )->to_app;
 Plack::Runner->new->run($app);

 # Output:
 # HTTP::Server::PSGI: Accepting connections at http://0:5000/

 # > curl http://localhost:5000/
 # <!DOCTYPE html>
 # <html lang="en">
 #   <head>
 #     <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 #     </meta>
 #     <meta name="viewport" content="width=device-width, initial-scale=1.0">
 #     </meta>
 #     <style type="text/css">
 # .container {
 # 	position: fixed;
 # 	top: 50%;
 # 	left: 50%;
 # 	transform: translate(-50%, -50%);
 # }
 # .inner {
 # 	text-align: center;
 # }
 # .restricted {
 # 	color: red;
 # 	font-family: sans-serif;
 # 	font-size: 3em;
 # }
 # </style>
 #   </head>
 #   <body>
 #     <div class="container">
 #       <div class="inner">
 #         <div class="restricted">
 #           Restricted access
 #         </div>
 #       </div>
 #     </div>
 #   </body>
 # </html>

=head1 DEPENDENCIES

L<Plack::Component::Tags::HTML>,
L<Tags::HTML::Container>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Plack-App-Restricted>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2022 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
