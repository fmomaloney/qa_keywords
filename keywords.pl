#!/usr/bin/perl
use strict; 
use Getopt::Long;

########## Keyword Grabber ###########
=head1 NAME
keywords.pl REV 1

=head1 AUTHOR
FM
=head1 SYNOPSIS
keywords.pl [Options]

  <NO ARGS>          Show Help if run w/o arguments
  --help or -?       Show Help
  --file             File name for input (required)
  --sep              Term separator ("and", "or", or default=comma)
  --min              Min number of characters per term (5 is default)

=head1 DESCRIPTION

This script takes a text file as input and extracts unique words/terms from it. The terms are then written with 
the separator specified. Words < minimum length are not included. The purpose is in search and pattern match test.

Usage: perl keywords.pl --file=input.txt --sep=and --min=4  > unique_terms.txt

=cut
########## End POD ###########

# globals for command line options
my ($g_help, $g_filename, $g_sep, $g_min); 

# How many command line arguments passed? Show help if none...
my $n_args = scalar(@ARGV);
exec('perldoc', $0) if $n_args < 2;

# take command line arguments
GetOptions("help|?=s"        => \$g_help,
           "file=s"          => \$g_filename,
           "sep=s"           => \$g_sep,
           "min=i"           => \$g_min,
           )
    or pod2usage(-verbose => 2);

#~~~~~~~~~~~~~~~~~~~~
main();
exit(1);
#~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~
sub main {
my ($count, $chars, $match, $input, $term);
my @terms = (); 
my %dupe = ();

# default separator is a comma 
if ($g_sep eq "and") {
      $g_sep = " and ";
    } elsif ($g_sep eq "or") {
      $g_sep = " or ";
    } else {$g_sep = ",";
  }

# default min chars is 5 
unless ($g_min =~ m/\d/ && length($g_min) > 0) { 
      $g_min = 5;
    }

# If the filename is valid, slurp file into variable $input
if (-e $g_filename) {
{
    local( $/, *FH ) ;
    open( FH, $g_filename ) or die "could not open data file $g_filename!\n";
    $input = <FH>;
}

      # Split words on whitespace (default) into terms array
      @terms = split(/\s/,$input);
 
      foreach $term(@terms) {
        # if "key" not already there...
        unless ($dupe{$term}) {
          # match words/numbers >= min
          my $match = $term =~ /([a-zA-Z0-9-]{$g_min,})/;
          # if there is a match, push it into hash
          if ($1) {
            # this creates hash values = 1 for all. I don't need the word count.
            $dupe{$1} = 1;
            } # end if
          } # end unless
        } # end foreach

    # print out the list of terms here, sorted alpha
    print join($g_sep,sort keys %dupe); 
    print "\n\n----------------------------------------------\n";
    # I need a count of the hash keys here
    $count = scalar keys %dupe;
    print "the unique word count of length $g_min in $g_filename is $count.\n";

  } else { 
    # filename does not exist
    print "could not locate file $g_filename!\n"; 
  } # end else

} # end main
#~~~~~~~~~~~~~~~~~~~
