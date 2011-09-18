#!/usr/bin/perl
# Truecrypt Password Guesser
# Copyright (C) Vlatko Kosturjak, Kost. Distributed under GPL

use strict;
use Getopt::Long;

print STDERR "Truecrypt Password Guesser by Kost. Distributed under GPL.\n\n";

Getopt::Long::Configure ("bundling");

my $file;
my $verbose=0;
my $tcbin="truecrypt";
my $mntopt="ro";
my $mntdir;
my $dryrun;
my $quiet;

my $defopt="-t --non-interactive";

my $result = GetOptions (
	"f|file=s" => \$file,
	"m|mount=s" => \$mntopt,
	"t|tcbin=s" => \$tcbin,
	"d|dir=s" => \$mntdir,
	"v|verbose+"  => \$verbose,
	"n|dryrun" => \$dryrun,
	"q|quiet" => \$quiet,
	"h|help" => \&help
);

unless ($file) {
	help();
}

while (<>) {
	chomp;
	next if ($_ eq '');

	print STDERR "[v] Guessing: $_\n" if ($verbose);
	my $cmdline="$tcbin $defopt";
	$cmdline=$cmdline.' -p "'.$_.'"';
	$cmdline=$cmdline." -m $mntopt" if ($mntopt);
	$cmdline=$cmdline.' "'. $file.'"';
	$cmdline=$cmdline." $mntdir" if ($mntdir);
	$cmdline=$cmdline." 2> /dev/null" if ($quiet);

	print STDERR "[d] Cmd: $cmdline\n" if ($verbose>1);
	unless ($dryrun) {	
		system($cmdline);
		if ($? == 0) {
			print "[!] Password is $_\n";
			die("FOUND!");
		}
	}

}

sub help {
	print "$0: Truecrypt Password Guesser. \n\n";
	print "Usage:\n";
	print "\tcat wordlist | $0 -f file.tc \n";
	print "\tjohn --incremental --stdout | $0 -f file.tc -v -q -m ro,system\n\n";
	print "	-f <f>	Use this encrypted file container or device\n";
	print "	-q	make truecrypt quiet\n";
	print "	-v	verbose (-vv will be more verbose )\n";
	print "	-h 	this help message\n";
	exit (0);
} 

