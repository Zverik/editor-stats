#!/usr/bin/perl
use strict;
use warnings;

sub editor {
  my $cr = shift;
  return 'Not Specified' if $cr eq '';
  return 'JOSM' if $cr =~ /^JOSM/;
  return 'iD' if $cr =~ /^iD/;
  return 'Potlatch 1' if $cr =~ /^Potlatch 1/;
  return 'Potlatch 2' if $cr =~ /^Potlatch 2/;
  return 'Merkaartor' if $cr =~ /^Merkaartor/;
  return 'Vespucci' if $cr =~ /^Vespucci/;
  return 'Go Map!!' if $cr =~ /^Go Map/;
  return 'Pushpin' if $cr =~ /^Pushpin/;
  return 'OsmAnd' if $cr =~ /^Osm[Aa]nd/;
  return 'MAPS.ME' if $cr =~ /^MAPS\.ME/;
  return 'rosemary' if $cr =~ /^rosemary/;
  return 'rosemary' if $cr =~ /^wheelmap\.org/;
  return 'bulk_upload.py' if $cr =~ /^bulk_upload\.py/;
  return 'PythonOsmApi' if $cr =~ /PythonOsmApi/;
  return 'OSMPOIEditor' if $cr =~ /^POI\+/;
  return 'OSMPOIEditor' if $cr =~ /^OSMPOIEditor/;
  return 'Level0' if $cr =~ /^Level0/;
  return 'Osmose Editor' if $cr =~ /^Osmose Editor/;
  return 'RawEdit' if $cr =~ /^RawEdit/;
  return 'OsmHydrant' if $cr =~ /^OsmHydrant/;
  return 'iLOE' if $cr =~ /^iLOE/;
  return 'YAPIS' if $cr =~ /^YAPIS/;
  return 'Services?' if $cr =~ /^Services_OpenStreetMap/;
  return 'ArcGIS' if $cr =~ /^ArcGIS Editor/;
  return 'osmapis' if $cr =~ /^osmapis/;
  return 'osmapi' if $cr =~ /^osmapi(?:\/.+)?$/;
  return 'FreieTonne' if $cr =~ /^FreieTonne/;
  return 'osmtools' if $cr =~ /^osmtools\//;
  return 'Redaction bot' if $cr =~ /^Redaction bot/;
  return 'upload.py' if $cr =~ /^(?:.*\/)?upload\.py/;
  return 'bulk_upload.py' if $cr =~ /^bulk_upload(?:_sax)\.py/;
  return 'OpenMaps' if $cr =~ /^OpenMaps /;
  return 'Mapzen' if $cr =~ /^Mapzen /;
  return 'WebDRI' if $cr =~ /^WebDRI/;
  return 'KMLManager' if $cr =~ /^KMLManager/;
  return 'osmitter' if $cr =~ /^osmitter/;
  return 'COFFEEDEX 2002' if $cr =~ /^COFFEEDEX 2002/;
  return 'FindvejBot' if $cr =~ /^FindvejBot/;
  return 'Roy' if $cr =~ /^Roy /;
  return 'OSMPhpLib'if $cr =~ /^OSMPhpLib/;
  return 'Fulcrum' if $cr =~ /^Fulcrum /;
  return 'OSMapTuner' if $cr =~ /^OSMapTuner/;
  return 'QGIS' if $cr =~ /^QGIS /;
  return 'OpenSeaMap-Editor' if $cr =~ /^OpenSeaMap-Editor/;
  return 'BigTinCan' if $cr =~ /^BigTinCan /;
  return 'meta' if $cr =~ /^meta$/;
  return 'SviMik' if $cr =~ /^SviMik/;
  return 'My Opening Hours' if $cr =~ /^My Opening Hours/;
  return 'Sputnik.Ru.Adminka' if $cr =~ /^Sputnik\.Ru\.Adminka/;
  return 'OpenBeerMap' if $cr =~ /^OpenBeerMap/;
  return 'Kort' if $cr =~ /^Kort /;
  return 'Nomino' if $cr =~ /Nomino /;
  return 'Route4U' if $cr =~ /^Route4U/;
  return 'Ubiflow' if $cr =~ /^Ubiflow/;
  return 'streetkeysmv' if $cr =~ /^streetkeysmv/;
  return 'Grass and Green' if $cr =~ /^Grass_and_Green/;
  return 'JOSM reverter' if $cr =~ /^reverter;JOSM/;
  return 'fix.loggingroads.org' if $cr =~ /^fix\.loggingroads\.org/;
  return 'Other';
}

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
