#!/usr/bin/perl -w

use strict;
use LWP::UserAgent;
use HTTP::Request::Common;

my $ua = LWP::UserAgent->new();
#$ua->agent('LWP');
my $req = GET('http://www.just4fun.biz/');
my $res = $ua->request($req);

if ($res->is_success) {
#  print $res->as_string;
  print $res->content;
}
else {
  print $res->status_line . "\n";
}
