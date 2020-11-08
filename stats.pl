#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use lib dirname (__FILE__);
use EDetect qw(editor);

sub nf {
  my $n = shift;
  $n =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1 /g;
  return $n;
}

my @gmt = gmtime;
my $date = $ARGV[0] || $gmt[5] + 1900;
shift;

my %changesets;
my %users;
my %edits;
my $sum_changesets = 0;
my %all_users;
my $sum_edits = 0;
my %other;

while(<>) {
  chomp;
  # 0:changeset_id, 1:uid, 2:date, 3:num_changes, 4:num_comments, 5:created_by
  my @data = split /,/;
  next if substr($data[2], 0, length($date)) ne $date;
  my $editor = editor($data[5] || '');
  $other{$data[5]} += 1 if $editor eq 'Other';
  $changesets{$editor}++;
  $sum_changesets++;
  $edits{$editor} += $data[3] || 0;
  $sum_edits += $data[3] || 0;
  $users{$editor} = {} if !exists($users{$editor});
  $users{$editor}->{$data[1]} = ();
  $all_users{$data[1]} = ();
}

print "By Changesets:\n";
printf "%s: %s (%.1f%%)\n", $_, nf($changesets{$_}), 100.0*$changesets{$_}/$sum_changesets for sort { $changesets{$b} <=> $changesets{$a} } keys %changesets;

print "\nBy Users:\n";
printf "%s: %s (%.1f%%)\n", $_, nf(scalar keys %{$users{$_}}), 100.0*scalar(keys %{$users{$_}})/scalar(keys %all_users) for sort { keys %{$users{$b}} <=> keys %{$users{$a}} } keys %users;

print "\nBy Edits:\n";
printf "%s: %s (%.1f%%)\n", $_, nf($edits{$_}), 100.0*$edits{$_}/$sum_edits for sort { $edits{$b} <=> $edits{$a} } keys %edits;

print "\nOther Editors:\n";
printf "%d %s\n", $other{$_}, $_ for sort { $other{$b} <=> $other{$a} } keys %other;
