package Bit::Vector::Array::Tie;

use strict;
use warnings;
use Data::Dumper;

use Tie::Array;
use base 'Tie::Array';

sub TIEARRAY
{
	return bless {}, $_[0];
}

sub CLEAR
{
	$_[0]->{Value}=0;
}

sub STORESIZE
{
	my ($obj,$value)=@_;
	$value=int($value);

	# if assigned using @arr=42; (last caller is STORE)
	# then do NOT need to subtract one.
	# but if assigned using $#arr=42, 
	# then need to subtract 1.
	my @caller= caller(1);
	my $callingsub = $caller[3];
	if(scalar(@caller) and ($callingsub=~m{STORE}))
		{}
	else
		{
		$value--;
		}
	$obj->{Value}=$value;
}

sub FETCHSIZE
{
	my ($obj)=@_;
	my $value = $obj->{Value};
	return $value;
}

sub STORE
{
	my($obj,$bit_index,$bit_value)=@_;
	# warn "STORE, $bit_index,$bit_value";
	#################################################
	# if the user says
	# 	@arr = 42;
	# then this will attempt to store to index zero.
	# if a store to index zero occurs, treat it as 
	# setting the value of the entire array.
	#################################################
	if($bit_index==0)
		{
		$obj->STORESIZE($bit_value);
		}
	else
	#################################################
	# else if user says
	#	$arr[1]=1;
	# then set bit 1 (lsb) to a '1'
	# if user says
	#	$arr[4]=0;
	# then set bit 4 to a '0'
	#################################################
		{
		$bit_index--;
		$bit_value = $bit_value ? '1' : '0';
		my $bin_str = sprintf("%lb",$obj->{Value});
		my $padding='0'x($bit_index-length($bin_str));
		$bin_str = '00'.$padding.$bin_str;
		my $substr_offset = -1 * ($bit_index+1);
		substr($bin_str,$substr_offset,1)=$bit_value;
		my $dec_val = oct('0b'.$bin_str);
		$obj->{Value}=$dec_val;
		}
}


sub FETCH
{
	my($obj,$bit_index)=@_;

	#################################################
	# if user says
	#	my $bit = $arr[1];
	# then return the bit at index 1 (lsb)
	#################################################
		{
		my $bin_str = sprintf("%lb",$obj->{Value});
		my $padding='0'x($bit_index-length($bin_str));
		$bin_str = '00'.$padding.$bin_str;
		my $substr_offset = -1 * ($bit_index+1);
		my $bit_val=substr($bin_str,$substr_offset,1);
		return $bit_val;
		}
}


##############################################################
package Bit::Vector::Array;

use 5.008002;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. 
# Note: do not export names by default without a very 
# good reason. Use EXPORT_OK instead.
# Do not simply export all your public 
# functions/methods/constants.

# This allows declaration	
# 	use Bit::Vector::Array ':all';
# If you do not need this, moving things directly 
# into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	bva
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub bva(\@)
{
	tie @{$_[0]},'Bit::Vector::Array::Tie';
}


1;
__END__

=head1 NAME

Bit::Vector::Array - Perl extension for manipulating bit vectors as an array

=head1 SYNOPSIS

	use Bit::Vector::Array;
	bva(my @my_array);

	@my_array=8;	# 1000 binary. index 4 .. 1
	$my_array[2]=1;	# 1010 binary. bit index 2

	print "vector is ".@my_array."\n";	# vector is 10

=head1 DESCRIPTION

Bit::Vector::Array is used to store an integer, but access
bits of that integer as a bit vector. The integer is stored
by assigning to the scalar value of an array. Individual bits
are accessed by indexing into the array. The bit indexes
start at 1 and increase from there.

To set the least significant bit in @arr, use this:
	$arr[1]=1;

=head2 EXPORT

The bva routine is exported. This is used to create a new bit vector array.

	bva(my @arr_name);

=head1 SEE ALSO


=head1 AUTHOR

email@greglondon.com

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2004 by Greg London

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
