use strict;
use warnings;
use Test::More;
use VM::EC2::Instance::Metadata;
use VM::EC2::Instance::Metadata::V2;

ok my $ip = VM::EC2::Instance::Metadata->new->localIpv4;

done_testing;
