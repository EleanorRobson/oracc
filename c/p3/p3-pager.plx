#!/usr/bin/perl
use warnings; use strict; use open ':utf8';
binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
use lib '/usr/local/oracc/lib';
use ORACC::P3::Slicer;
use File::Temp qw/tempdir tempfile/;

my $verbose = 1;

my @pg_args = ();

my %p = decode_args(@ARGV);
my %rt = ();

# set the command to send the list to stdout

my $lister = '';
my $list_type = '';

my $tmpdir = tempdir(CLEANUP => 0);

warn "$tmpdir\n";

if ($p{'list'}) {

    if ($p{'list'} eq '_all') {
	$p{'#list'} = "/usr/local/oracc/pub/$p{'project'}/cat/pqids.lst";
    } else {
	$p{'#list'} = "/usr/local/oracc/www/$p{'project'}/lists/$p{'list'}";
    }
    $list_type = 'cat';

} elsif ($p{'adhoc'}) {

} elsif ($p{'srch'}) {
    
} else {
    # can't happen because we default $p{'list'}
}

my $kwic = $p{'cetype'} eq 'kwic';

# set up the Slicer inputs
setup_pg_args();
my($pg_order,$input) = ORACC::P3::Slicer::setup($tmpdir, $p{'#list'}, $kwic);

# set up the input for the content maker
my $pageinfo = ORACC::P3::Slicer::pageinfo($tmpdir, $pg_order, $input, $kwic, $p{'project'}, $p{'state'}, @pg_args);

# generate the outline
ORACC::P3::Slicer::outline($pg_order, @pg_args);

set_runtime_vars();

# generate the content
## in page mode emit the pth page
## in item-mode emit the ith item of the pth page

if ($p{'item'} == 0) {
    run_page_maker($pageinfo);
} else {
    run_item_maker($pageinfo);
}

# echo the template including outline/content as we go
run_form_maker();

# emit the trailer close and exit
print '</body></html>';
close(STDOUT);
exit 0;

####################################################################

sub
decode_args {
    my %tmp = ();
    foreach my $a (@_) {
       	my($k,$v) = ($a =~ /^(.*?)=(.*)$/);
	$tmp{$k} = $v;
    }
    # set up some defaults if not all values are given
    $tmp{'cetype'} = 'line' unless $tmp{'cetype'};
    $tmp{'item'} = 0 unless defined $tmp{'item'};
    $tmp{'list'} = '_all' unless $tmp{'list'} || $tmp{'adhoc'} || $tmp{'srch'};
    $tmp{'pagesize'} = 25 unless $tmp{'pagesize'};
    $tmp{'state'} = 'default' unless $tmp{'default'};
    %tmp;
}

sub
run_form_maker {
    my $t = "/usr/local/oracc/pub/$p{'project'}/p3.html";
    open(T,$t);
    while (<T>) {
	if (/^\@$/) {
	    print '<div id="left" name="left">';
	    system 'cat', "$tmpdir/outline.html";
	    print '</div><div id="right" name="right">';
	    system 'cat', "$tmpdir/results.html";
	    print '</div>';
	} elsif (/\@\@(.*?)\@\@/) {
	    my $atat = $1;
	    my($class,$var) = ($atat =~ /^(.*?):(.*?)$/);
	    if ($class eq 'cgivar') {
		my $default = '0';
		if ($var =~ s#/(.*?)##) {
		    $default = $1;
		}
		my $rep = ($p{'var'} || $default);
		s/\@\@.*?\@\@/$rep/;
		print;
	    } elsif ($class eq 'runtime') {
		s/\@\@.*?\@\@/$rt{$var}/;
		print;
	    } else {
		die "bad class '$class'\n";
	    }
	} else {
	    print;
	}
    }
    close(T);
}

sub
run_item_maker {
    
}

sub
run_page_maker {
    my $vminus = $p{'page'} || 0;
    $vminus -= 1 if $vminus;
    my $ce_arg = '';
    if ($p{'cetype'}) {
	$ce_arg = $p{'cetype'};
	$ce_arg =~ s/^(.).*$/-$1/;
    } elsif ($list_type eq 'xtf') {
	$ce_arg = '-l';
    }
    my $item_offset = ($vminus) * $p{'pagesize'};
    my @offset_arg = ('-o', $item_offset);
    my @offset_param = ('-stringparam', 'item-offset', $item_offset);
    if ($list_type eq 'xtf') { ## sigfixer may need adding to end of pipe here some day
	xsystem("cat $tmpdir/pgwrap.out | /usr/local/oracc/bin/ce_xtf $ce_arg -p $p{'project'} | /usr/local/oracc/bin/s2-ce_trim.plx >$tmpdir/content.xml");
	xsystem('xsltproc', '-stringparam', 'fragment', 'yes', '-stringparam', 'project', $p{'project'}, @offset_param, '-o', "$tmpdir/results.html", '/usr/local/oracc/lib/scripts/p3-ce-HTML.xsl', "$tmpdir/content.xml");
    } elsif ($list_type eq 'cat' || $list_type eq 'tra') {
	my $link_fields = `oraccopt $p{'project'} catalog-link-fields`;
	my $lfopt = ($link_fields ? "-a$link_fields" : '');
	warn "lfopt=$lfopt\n";
	xsystem("cat $tmpdir/pgwrap.out | /usr/local/oracc/bin/ce2 $lfopt -S$p{'state'} @offset_arg -i$list_type -p $p{'project'} >$tmpdir/content.xml");
	xsystem('xsltproc', '-stringparam', 'fragment', 'yes', '-stringparam', 'project', $p{'project'}, @offset_param, '-o', "$tmpdir/results.html", '/usr/local/oracc/lib/scripts/p3-ce-HTML.xsl', "$tmpdir/content.xml");
    } elsif ($list_type eq 'cbd') {
	xsystem("cat $tmpdir/pgwrap.out | /usr/local/oracc/bin/ce2 -S$p{'state'} -icbd/$p{'glossary'} -p $p{'project'} >$tmpdir/content.xml");
	xsystem('xsltproc', '-stringparam', 'fragment', 'yes', '-stringparam', 'project', $p{'project'}, @offset_param, '-o', "$tmpdir/results.html", '/usr/local/oracc/lib/scripts/p3-ce-HTML.xsl', "$tmpdir/content.xml");    
    }
}

sub
set_runtime_vars {
    open(P, "$tmpdir/pg.info");
    while (<P>) {
	next if /^\#/;
	chomp;
	my($k,$v) = (/^(\S+)\s+(\S+)$/);
	$rt{$k} = $v;
    }
    close(P);
}

sub
setup_pg_args {
    $p{'page'} = 1 unless $p{'page'};
    my $tmpstate = ($p{'state'} =~ /^default|special$/ ? $p{'state'} : $p{'pushed-state'});
    $tmpstate = 'default' unless $tmpstate;
    @pg_args = ('-fm', "-p$p{'project'}", "-P$p{'pagesize'}", 
		"-n$p{'page'}", "-S$tmpstate");

    push @pg_args, '-q', if $list_type eq 'cbd';
    if ($tmpstate && $p{"$tmpstate-sort"}) {
	my $tmp = $p{"$tmpstate-sort"};
	$tmp =~ tr/_/^/; # escape field names like ch_no
	push(@pg_args, "-s$tmp") if $tmp;
    }
    push @pg_args, "-z$p{'zoom'}" if $p{'zoom'};
}

sub
xsystem {
    warn "system @_\n"
	if $verbose;
    system @_;
}

1;
