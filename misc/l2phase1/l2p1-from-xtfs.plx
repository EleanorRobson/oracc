#!/usr/bin/perl
use warnings; use strict;
use open 'utf8';
use lib "$ENV{'ORACC'}/lib";
use ORACC::XML;
use ORACC::NS;
use Getopt::Long;
use ORACC::XPD::Util;

binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';

my $base = 'xtf';
my %char = (norm0=>'$',base=>'/',cont=>'+',morph=>'#',morph2=>'##');
my $cbd_mode = ORACC::XPD::Util::option('cbd-mode');
my $dyn_mode = ($cbd_mode && $cbd_mode eq 'dynamic');
my %exos = ();
my $lang = '';
my $new_mode = 0;
my %news = ();
my $output = undef;
my $project = `oraccopt`;
my $proxy_mode = 0;
my %rws_map = (
    EG => '',
    OA => 'x-oldass',
    OB => 'x-oldbab',
    MA => 'x-midass',
    MB => 'x-midbab',
    NA => 'x-neoass',
    NB => 'x-neobab',
    SB => 'x-stdbab',
    );
my %sigs = ();
my %wordrefs = ();
my $textlist = ();
my $xtf_project = '';
my $verbose = 0;

GetOptions (
    'new'=>\$new_mode,
    'output:s'=>\$output,
    'proxy'=>\$proxy_mode,
    'textlist:s'=>\$textlist,
    );

#$output = '01bld/from-xtfs.sig'
#   unless $output;

$base = 'prx' if $proxy_mode;

$textlist = '01bld/lists/have-lem.lst' unless $textlist;

open(T,$textlist) || die "l2p1-from-xtfs.plx: can't open '$textlist'\n";
while (<T>) {
    chomp;
    my $p = '';
    s/\@.*$//; # remove cat element from proxy.lst
    if (/^(.*?):(.*?)$/) {
	my($proj,$text) = ($1,$2);
	$p = sprintf("$ENV{'ORACC'}/bld/$proj/%s/$text/$text.xtf",four($text));
    } else {
	$p = sprintf("01bld/%s/$_/$_.xtf",four($_));
    }
    if (-r $p) {
	loadsigs($p);
	warn("l2p1-from-xtfs.plx: reading $p\n")
	    if $verbose;
    } else {
	warn("l2p1-from-xtfs.plx: can't read $p\n")
	    unless $proxy_mode;
    }
}
close(T);

#if ($output) {
#    open O, ">$output"; select O;
#}

my @glores = ();
my @exores = ();
my @newres = ();

if ($new_mode) {
    foreach my $s (keys %news) {
	push @newres, "$s\t@{$news{$s}}\n";
    }
} else {
    foreach my $s (sort keys %sigs) {
	push @glores, "$s\t@{$sigs{$s}}\n";
    }
}

foreach my $s (keys %exos) {
    push @exores, "$s\t@{$exos{$s}}\n";
}

if ($new_mode) {
    open(O,">01bld/from-$base-glo.sig"); print O sort (@glores); close(O);
    open(O,">01bld/from-$base-new.sig"); print O sort (@newres, @exores); close(O);
} else {
    open(O,">01bld/from-$base-glo.sig"); print O sort (@glores, @exores); close(O);
    open(O,">01bld/from-$base-new.sig"); print O sort @newres; close(O);
}

######################################################################

sub
attr {
    my($node,$attr) = @_;
    $node->getAttribute($attr);
}

sub
four {
    my $tmp = shift;
    $tmp =~ s/^(....).*$/$1/;
    $tmp;
}

sub
lang {
    my $rws = attr($_[0], "rws");
    if ($rws) {
	if ($rws_map{$rws}) {
	    "$lang-$rws_map{$rws}";
	} else {
	    warn "sig-form-harvester.plx: undefined langtag shorthand '$rws'\n"
		unless defined $rws_map{$rws};
	    $lang;
	}
    } else {
	$lang;
    }
}

sub
loadsigs {
    my $x = load_xml($_[0]);
    $lang = $x->getDocumentElement()->getAttribute('xml:lang');
    $xtf_project = $x->getDocumentElement()->getAttribute('project');
    foreach my $l (tags($x,$XCL,'l')) {
	my $bad = $l->getAttribute('bad');
	if (!$bad || $bad ne 'yes') {
	    my $xid = xid($l);
	    my $ref = $l->getAttribute('ref');
	    my $sig = $l->getAttribute('sig');
	    my $exo = $l->getAttribute('exosig');
	    my $new = $l->getAttribute('newsig');
	    $wordrefs{$xid} = $ref;
	    if ($sig && $sig =~ /^.+\[/) {
		push(@{$sigs{$sig}},"$xtf_project\:$ref");
	    } elsif ($exo) {
		push(@{$exos{$exo}},"$xtf_project\:$ref");
	    } elsif ($new) {
		push(@{$news{$new}},"$xtf_project\:$ref");
	    }
	}
    }
    foreach my $l (tags($x,$XCL,'linkset')) {
	next unless $l->getAttributeNS($XLINK,'role') eq 'psu';
	my $ref = $l->getAttribute('ref');
	my $sig = $l->getAttribute('sig');
	if (!$ref) {
	    $ref = psuref($l);
	}
	if ($ref && $sig && $sig =~ /^.+\[/) {
	    push(@{$sigs{$sig}},"$xtf_project\:$ref");
	}
    }
    undef $x;
}

sub
psuref {
    my @refs = ();
    my %seen = ();
    foreach my $c ($_[0]->childNodes()) {
	next unless $c->isa('XML::LibXML::Element');
	my $href = $c->getAttributeNS($XLINK,'href');
	if ($href) {
	    $href =~ s/^\#//;
	    my $wref = $wordrefs{$href};
	    if ($wref) {
		push(@refs,$wref) unless $seen{$wref}++;
	    } else {
		return '';
	    }
	}
    }
    join('+',@refs);
}

1;
