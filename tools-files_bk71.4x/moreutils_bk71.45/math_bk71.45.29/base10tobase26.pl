#!/usr/bin/env perl
use warnings;
use strict;

sub excel_colname {
  my ($idx) = @_;       # one-based column number
  --$idx;               # zero-based column index
  my $name = "";
  while ($idx >= 0) {
    $name .= chr(ord("A") + ($idx % 26));
    $idx   = int($idx / 26) - 1;
  }
  return scalar reverse $name;
}


print(lc(excel_colname($ARGV[0])));
