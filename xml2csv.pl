#!/usr/bin/perl
use strict;
use warnings;

my @data; # 0:changeset_id, 1:uid, 2:date, 3:num_changes, 4:num_comments, 5:created_by
while(<>) {
  if (/<changeset id="(\d+)"/) {
    @data = ('') x 6;
    $data[0] = $1;
    $data[1] = $1 if /uid="(\d+)"/;
    $data[2] = $1 if /created_at="(\d{4}-\d\d-\d\d)/;
    $data[3] = $1 if /num_changes="(\d+)"/;
    $data[4] = $1 if /comments_count="(\d+)"/;
  } elsif (@data && /<tag k="creat[^"]+by" v="([^"]+)"/) {
    $data[5] = $1;
    $data[5] =~ s/&lt;/</g;
    $data[5] =~ s/&gt;/>/g;
    $data[5] =~ s/&amp;/&/g;
    $data[5] =~ s/&quot;/'/g;
    $data[5] =~ s/,/;/;
  }
  if (/<\/changeset>/ || /<changeset.+\/>/) {
    print join(',', @data)."\n";
    undef @data;
  }
}
