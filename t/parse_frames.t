use strict;
use warnings;

use Test::More;
use File::chdir;

use_ok ('LaTeX::Beamer::Info::Nav');

my $nav;
{
  local $CWD;
  push @CWD, qw/t docs/;

  $nav = LaTeX::Beamer::Info::Nav->new(
    file => 'parse_frames.nav',
  );
  isa_ok( $nav, 'LaTeX::Beamer::Info::Nav' );

  $nav->parse;
}

is( scalar @{ $nav->frames }, 7, "parsed correct number of frames" );

is( $nav->get_page(3)->number, 3, "found page by number (single page frame)" );
is( $nav->get_page(12)->number, 12, "found page by number (multi page frame)" );

done_testing;


