sub column2base26 {

    my $column = shift;
    die "Column $column must be positive" unless $column > 0;

    my $string = 'A';
    $string++ for 2..$column;
    return $string;
}



sub b26_to_b10 { 
    my $base_10 = 0; 
    for (split //, lc shift) { 
        $base_10 *= 26;
        $base_10 += ord() - 96; 
    }
    return $base_10;
}

print lc(b26_to_b10($ARGV[0]));
