# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Bit-Vector-Array.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('Bit::Vector::Array') };

#########################

# Insert your test code below, the Test::More module is 
# use()ed here so read its man page ( perldoc Test::More ) 
# for help writing this test script.

Bit::Vector::Array::bva(my @arr1);
@arr1=8;
my $val1 = @arr1;
is($val1,8, "Assign using at-sign");

Bit::Vector::Array::bva(my @arr2);
$#arr2=7;
my $val2=@arr2;
is($val2,7, "assign using dollar-pound");

Bit::Vector::Array::bva(my @arr3);
@arr3=8;
$arr3[3]=1;
my $val3=@arr3;
is($val3,12, "set an individual bit");

$arr3[4]=0;
$val3=@arr3;
is($val3,4, "clear an individual bit");