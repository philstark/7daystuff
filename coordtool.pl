#!/usr/bin/perl

use strict;
use warnings;
use Math::Geometry::Planar;

my $filename = 'coords.xml';
open( my $fh, '<:encoding(UTF-8)', $filename )
  or die "Could not open file '$filename' $!";

my @places;
my $starting_point = [ -2357, 745 ];

while ( my $row = <$fh> ) {
    chomp $row;
    if ( $row =~ /<decoration/ ) {
        my %data;
        my ( $name, $position ) = $row =~ /name="(.*?)"\sposition="(.*?)"/;
        my ( $x, $z, $y ) = $position =~ /([-]?\d*),([-]?\d*),([-]?\d*)/;
        $data{"name"}     = $name;
        $data{"point"}    = [ $x, $y ];
        $data{"distance"} = SegmentLength [ $starting_point, $data{"point"} ];

        push @places, \%data;
    }
}

@places = sort { $a->{distance} <=> $b->{distance} } @places;

print "name,x,y,distance\n";
print "ORIGIN,$starting_point->[0],$starting_point->[1],0\n";
foreach my $place (@places) {
    print "$place->{name},$place->{point}[0],$place->{point}[1],$place->{distance}\n";
}
