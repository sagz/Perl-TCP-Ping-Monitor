#!/usr/bin/perl
use strict;
use warnings;
use IO::Socket;

chomp(my $hostname  = `hostname`);
$hostname =~ s/\..*//;
my $server     = $ARGV[0] || 'localhost';
my $port       = $ARGV[1] || 42424;
my $frequency  = $ARGV[2] || 1;
my $me         = $ARGV[3] || $hostname;

while (1) {
    print "TCP pinging\n";
    my $socket = IO::Socket::INET->new(PeerAddr => $server,
                                PeerPort => $port,
                                Proto    => "tcp",
                                Type     => SOCK_STREAM)
        or die "Couldn't connect to $server:$port : $@\n";

    print "$me: Next ping in $frequency seconds\n";
    print $socket "$me: Next ping in $frequency seconds\n";
    close $socket;
    print "sleeping\n";
    sleep $frequency;
}
