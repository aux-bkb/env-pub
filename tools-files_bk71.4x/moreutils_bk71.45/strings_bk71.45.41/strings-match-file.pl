#!/usr/bin/env perl
#
$HELP = 'return all the strings that also acour in the ctrl file. Per default all words come out lowercase. Exceptions: -c or -u';

$USAGE = '[-prefix x] [-c|--case-sensitive ] [-u|--uppercase-first] <file> <string>';

use warnings;

$prefix = '';
($uppercase, $casey) = () ; @ARGS = ();
while(@ARGV){
   local $_ = shift @ARGV;
   if (/^-case/ or /^--case-sensitive/){
      $casey = 1;
   }elsif (/^-ucfirst/ or /^--uppercase-first/){
      $uppercase = 1;
   }elsif (/^-prefix/) {
      $prefix = shift @ARGV;
   }elsif (/^-/){
     die "Unknown option: $_\n"; 
   }else{
      push @ARGS,$_;
   }
}
$file=$ARGS[0];
$string=$ARGS[1];

die "usage: $USAGE" unless $string;

open($fh,'<', $file) || die "Err: could not open file in $file";

@words = ($casey)
  ? (split /[^a-zA-Z0-9]/, $string)
  : (map lc , split /[^a-zA-Z0-9]/, $string);

@res=();
foreach $ln (<$fh>) {
  $ln =~ s/^\s+|\s+$//g;
  if ($ln) {
   $str = ($casey) ? $ln : lc($ln) ;
   push @res, (($uppercase) 
     ? ($prefix . ucfirst($str)) 
     : ($prefix . $str))  if 
      grep { $str eq $_ } @words;
  }
}

print(join ' ', @res) if @res;



