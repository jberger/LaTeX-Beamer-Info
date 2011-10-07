use strict;
use warnings;

use Test::More;

use_ok ('LaTeX::Beamer::Info::Frame');

my $start = 1;
my $end = 5;

my $frame = LaTeX::Beamer::Info::Frame->new(
  start_page => $start,
  end_page   => $end,
);

isa_ok( $frame, 'LaTeX::Beamer::Info::Frame' );

is( $frame->pages->{$start}->is_start_page, 1, "First page marked start_page" );
is( $frame->pages->{$end}->is_end_page,     1, "Last page marked last_page" );

foreach my $num ($start .. $end) {
  is( $frame->pages->{$num}->number, $num, "Number correctly $num");
}

done_testing;
