#!/usr/bin/perl
use strict;
use warnings;
use EDetect qw(editor);
use IO::Uncompress::Gunzip;
use XML::LibXML::Reader qw( XML_READER_TYPE_ELEMENT XML_READER_TYPE_END_ELEMENT );

my $year = 2016;
my @editors = ('JOSM', 'iD', 'Potlatch 2', 'MAPS.ME', 'Other');
my %heditors = map { $_ => undef } @editors;
my %poi_keys = map { $_ => undef } qw(amenity tourism historic shop craft emergency office);
my $curl = 'curl';
my $replication_base = 'https://planet.openstreetmap.org/replication/day';

# Read last replication state index

my $state;
{
  local $/ = undef;
  open FH, "$curl -s $replication_base/state.txt|" or die "Failed to open state.txt: $!";
  my $state_str = <FH>;
  close FH;
  die "I don't see a state in state.txt" if $state_str !~ /sequenceNumber=(\d+)/;
  $state = $1;
}
$state -= 20; # Go back in time 20 days, since the list of changesets is obsolete

# Build a hash for changeset editors

print STDERR "Reading editors for changesets\n";
my %changesets;
while(<>) {
  chomp;
  # 0:changeset_id, 1:uid, 2:date, 3:num_changes, 4:num_comments, 5:created_by
  my @data = split /,/;
  next if substr($data[2], 0, 4) < $year;
  my $editor = editor($data[5] || '');
  $changesets{$data[0]} = exists $heditors{$editor} ? $editor : 'Other';
}

# Download day replication diffs until we're out of year

my %results;
my $found_year = 1;
sub process_osc;
while($found_year) {
  my $osc_url = $replication_base.sprintf("/%03d/%03d/%03d.osc.gz", int($state/1000000), int($state/1000)%1000, $state%1000);
  print STDERR "Downloading $osc_url\n";
  open FH, "$curl -s $osc_url|" or die "Failed to open: $!";
  $found_year = process_osc(new IO::Uncompress::Gunzip(*FH));
  close FH;
  $state--;
}

# Print results

print 'Date,'.(join ',', map { "$_ new,$_ mod" } @editors)."\n";
for my $date (sort keys %results) {
  my @row = ('what', $date);
  for my $ed (@editors) {
    my $count = exists $results{$date}->{$ed} ? $results{$date}->{$ed} : [0, 0];
    push @row, @$count;
  }
  print join(',', @row)."\n";
}

sub register_poi {
  my ($time, $changeset, $isnew) = @_;
  return if length($time) < 10;
  return if !exists $changesets{$changeset};
  my $k = substr($time, 0, 10);
  my $editor = $changesets{$changeset};
  $results{$k} = {} if !exists $results{$k};
  $results{$k}->{$editor} = [0, 0] if !exists $results{$k}->{$editor};
  $results{$k}->{$editor}->[$isnew ? 0 : 1]++;
}

sub process_osc {
  my $handle = shift;
  my $r = XML::LibXML::Reader->new(IO => $handle);
  my $state = 0; # 0 = root, 1 = create, 2 = modify
  my $found_year = 0;
  my $poic = 0;
  while ($r->read) {
    if ($r->nodeType == XML_READER_TYPE_ELEMENT) {
      if ($r->name eq 'create') {
        $state = 1;
      } elsif ($r->name eq 'modify') {
        $state = 2;
      } elsif ($state && ($r->name eq 'node' || $r->name eq 'way')) {
        my $type = $r->name;
        my $changeset = $r->getAttribute('changeset');
        my $time = $r->getAttribute('timestamp');
        my $timeok = substr($time, 0, 4) >= $year;
        $found_year = 1 if $timeok;
        my $ispoi = 0;
        while ($r->read) {
          last if $r->nodeType == XML_READER_TYPE_END_ELEMENT && $r->name eq $type;
          if ($r->nodeType == XML_READER_TYPE_ELEMENT && $r->name eq 'tag') {
            my $k = $r->getAttribute('k');
            $ispoi = 1 if exists $poi_keys{$k};
          }
        }
        register_poi($time, $changeset, $state == 1) if $ispoi && $timeok;
      }
    } elsif( $r->nodeType == XML_READER_TYPE_END_ELEMENT ) {
      $state = 0;
    }
  }
  return $found_year;
}
