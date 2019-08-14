#!/usr/bin/env perl
#
#
my @title_lines;

my $file = $ARGV[0];

open (my $fh, '<', $file) || die "err cannot open file $file";

my $title;
foreach(<$fh>){
  chomp;
  if (/\<title\>(.*)\<\/title\>/){
    $title = $1;
    break;
  }
}

print $title if ($title);


