package VM::EC2::Instance::Metadata::V2;
use strict;
use warnings;
use VM::EC2::Instance::Metadata;
use Carp;
use URI::Escape;
our $VERSION = '0.01';
use constant TIMEOUT => 5;

my $global_cache = {};

sub import {
    no warnings 'redefine';
    *VM::EC2::Instance::Metadata::fetch = sub {
        my $self = shift;
        my $attribute = shift or croak "Usage: VM::EC2::Instance::Metadata->get('attribute')";
        my $cache = $self->{cache} || $global_cache;  # protect against class invocation
        return $cache->{$attribute} if exists $cache->{$attribute};
        my $ua = $self->{ua} ||= LWP::UserAgent->new();
        $ua->timeout(TIMEOUT);
        my $res_token = $ua->put('http://169.254.169.254/latest/api/token', 'x-aws-ec2-metadata-token-ttl-seconds' => 60);
        if ($res_token->is_success) {
            my $token = $res_token->content;
            my $response = $ua->get("http://169.254.169.254/latest/meta-data/$attribute", 'x-aws-ec2-metadata-token' => $token);
            if ($response->is_success) {
                return $cache->{$attribute} = uri_unescape($response->decoded_content);  # don't know why, but URI escapes used here.
            } else {
                print STDERR $response->status_line,"\n" unless $response->code == 404;
                return;
            }
        } else {
            return;
        }
    }
}

1;
