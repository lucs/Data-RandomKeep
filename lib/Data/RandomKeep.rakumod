unit class Data::RandomKeep;

=begin pod

=head1 NAME

Data::RandomKeep - Randomly keep a given number of offered items.

=head1 SYNOPSIS

    use Data::RandomKeep;

        # Select numbers as a pick for a lottery ticket.
    my $nums-keeper = Data::RandomKeep.new: 6;
    $nums-keeper.offer: $_ + 1 for ^49;
    say "This might win: {$nums-keeper.kept}";

        # Keep 10 random lines from a file.
    my $file = FIXME;
    my $lines-keeper = Data::RandomKeep.new: 10;
    $lines-keeper.offer($_) for $file.IO.lines;
    say $lines-keeper.kept.join: "\n";

=head1 DESCRIPTION

Suppose you want to keep ten random lines from a file whose number of
lines you don't happen to know. You might read all the lines in an
array, shuffle it, and keep the first ten lines, but that can be quite
wasteful, especially if the file is big. This module implements the
task more efficiently.

To use the module, you first instantiate a Data::RandomKeep object,
telling the constructor how many items you will want to keep. Then you
.offer it items, which the instance will keep or discard, with correct
randomness. At any moment, you can look at the items that have been
kept up to that point, using the .kept method.

.kept returns a list of the items kept so far. The items will be
in the same order in which they were originally offered.

# --------------------------------------------------------------------
=head1 AUTHOR

Luc St-Louis, <lucs@pobox.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2023 by Luc St-Louis

This library is free software; you can redistribute it and/or modify
it under the Artistic License 2.0.

=end pod

# --------------------------------------------------------------------

has $.nb-to-keep = 1;
has $.nb-seen = 0;
has $.nb-kept = 0;
has @!kept;

# --------------------------------------------------------------------
method new ($nb-to-keep = 1) {
    return self.bless: :$nb-to-keep;
}

# --------------------------------------------------------------------
method offer (*@items)  {
    for @items -> $item {
        ++$!nb-seen;
        if rand < ($!nb-to-keep / $!nb-seen) {
            @!kept[
                $!nb-kept < $!nb-to-keep ?? $!nb-kept++ !! $!nb-to-keep.rand;
            ] = [$!nb-seen, $item];
        }
    }
}

# --------------------------------------------------------------------

method kept {
    return @!kept.map({ $_[1] }).sort({$^a[0] <=> $^b[0]});
}

