#!/usr/bin/perl
use strict;
use warnings;
use EDetect qw(editor editor_wikilink);
use Data::Dumper;

my @gmt = gmtime;
my @years = (2009..$gmt[5]+1900);

sub nf {
  my ($value, $total) = @_;
  my $fmt = $value;
  $fmt =~ s/(\d{1,3}?)(?=(\d{3})+$)/$1 /g;
  return sprintf '<span style="display:none">%011d</span> %11s%s', $value, $value ? $fmt : '-', ($value && $total ? sprintf ' (%.1f%%)', 100.0 * $value / $total : '');
}

sub extract {
  my ($dataref, $year, $editor, $extract_func) = @_;
  my $value = $editor ? $dataref->{$year}->{$editor} : $dataref->{$year};
  return $extract_func ? $extract_func->($value) : $value;
}

sub print_editor {
  my ($name, $dataref, $totalref, $extract_func) = @_;
  print "|-\n";
  print '| style="text-align:left" | '.editor_wikilink($name)."\n";
  for my $year (@years) {
    my $value = 0;
    my $total = 0;
    if (exists $dataref->{$year}->{$name}) {
      $value = extract($dataref, $year, $name, $extract_func);
      $total = extract($totalref, $year, 0, $extract_func);
    }
    print '| '.nf($value, $total)."\n";
  }
}

sub sort_editors {
  my ($dataref, $threshold, $allref, $extract_func) = @_;
  my $year = $years[-1];
  my %values;
  $values{$_} = 0 for keys %{$allref};
  $values{$_} = extract($dataref, $year, $_, $extract_func) for keys %{$dataref->{$year}};
  $values{editor('-')} = -1;
  $values{editor('')} = -2;

  # Filter out editors that didn't match the threshold
  for my $editor (keys %values) {
    next if $values{$editor} < 0;
    my $count = 0;
    $count += extract($dataref, $_, $editor, $extract_func) || 0 for @years;
    if ($count < $threshold) {
      delete $values{$editor} if $count < $threshold;
      # Add its counters to 'Other'
      for my $y (@years) {
        # A hack to deal with users' list
        if ($extract_func) {
          $dataref->{$y}->{'Other'}->{$_} = () for keys %{$dataref->{$y}->{$editor}};
        } else {
          $dataref->{$y}->{'Other'} += $dataref->{$y}->{$editor} || 0;
        }
      }
    }
  }
  return sort { $values{$b} <=> $values{$a} || $a cmp $b } keys %values;
}

sub cnt_uid {
  my $h = shift;
  return scalar keys %{$h};
}

sub table_header {
  my $title = shift;
  print "==== $title ====\n\n";
  print '{| class="wikitable sortable" style="text-align:right"'."\n";
  print "|+ style=\"padding-bottom:.5em\" | <big>$title</big>\n";
  print "|-\n";
  print '! editor ';
  print " !! $_" for @years;
  print "\n";
}

# Nested hashes: year => editor => count / list of uids
my %changesets = map { $_ => {} } @years;
my %users = map { $_ => {} } @years;
my %edits = map { $_ => {} } @years;
my %all_users = map { $_ => {} } @years;
my %sum_changesets = map { $_ => 0 } @years;
my %sum_edits = map { $_ => 0 } @years;
my %all_editors;
my %other_editors;
my %other_editors_u;

while(<>) {
  chomp;
  # 0:changeset_id, 1:uid, 2:date, 3:num_changes, 4:num_comments, 5:created_by
  my @data = split /,/;
  my $year = substr($data[2], 0, 4);
  next if !exists $changesets{$year};
  my $editor = editor($data[5] || '');
  $all_editors{$editor} = ();

  if ($editor eq 'Other') {
    $other_editors{$data[5]} += 1 + $data[3];
    $other_editors_u{$data[5]} = {} if !exists $other_editors_u{$data[5]};
    $other_editors_u{$data[5]}->{$data[1]} = ();
  }

  $changesets{$year}->{$editor}++;
  $sum_changesets{$year}++;
  $edits{$year}->{$editor} += $data[3] || 0;
  $sum_edits{$year} += $data[3] || 0;
  $users{$year}->{$editor} = {} if !exists $users{$year}->{$editor};
  $users{$year}->{$editor}->{$data[1]} = ();
  $all_users{$year}->{$data[1]} = ();
}

table_header('by number of changesets');
print_editor($_, \%changesets, \%sum_changesets) for sort_editors(\%changesets, 10000, \%all_editors);
print "|-\n|}\n\n";

table_header('by number of users (distinct uids)');
print_editor($_, \%users, \%all_users, \&cnt_uid) for sort_editors(\%users, 200, \%all_users, \&cnt_uid);
print "|-\n|}\n\n";

table_header('by number of edits');
print_editor($_, \%edits, \%sum_edits) for sort_editors(\%edits, 100_000, \%all_editors);
print "|-\n|}\n\n";

#print "== Other Editors by users ==\n\n";
#$other_editors_u{$_} = cnt_uid($other_editors_u{$_}) for keys %other_editors_u;
#printf "* %d %s\n", $other_editors_u{$_}, $_ for sort { $other_editors_u{$b} <=> $other_editors_u{$a} } keys %other_editors_u;
#print "== Other Editors by edits ==\n\n";
#printf "* %d %s\n", $other_editors{$_}, $_ for sort { $other_editors{$b} <=> $other_editors{$a} } keys %other_editors;
