#!/usr/bin/env raku

use Data::RandomKeep;

    # Select numbers as a pick for a lottery ticket.
my $nums-keeper = Data::RandomKeep.new: 6;
$nums-keeper.offer: $_ + 1 for ^49;
say "This might win: {$nums-keeper.kept}";

# --------------------------------------------------------------------
=finish

# Try it out with some file.

    # Keep 10 random lines from a file.
my $file = FIXME;
my $lines-keeper = Data::RandomKeep.new: 10;
$lines-keeper.offer($_) for $file.IO.lines;
say $lines-keeper.kept.join: "\n";

