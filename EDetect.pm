package EDetect;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(editor editor_wikilink);

sub editor {
  my $cr = shift;
  return 'Not Specified' if $cr eq '';
  return 'JOSM Reverter' if $cr =~ /reverter_plugin\/\d{5}/;
  return 'JOSM' if $cr =~ /^(?:.+;)?JOSM/;
  return 'iD' if $cr =~ /^iD/;
  return 'Potlatch 0.x/1.x' if $cr =~ /^Potlatch [01]/;
  return 'Potlatch 2' if $cr =~ /^Potlatch 2/;
  return 'Potlatch 3' if $cr =~ /^Potlatch$/;
  return 'Merkaartor' if $cr =~ /^Merkaartor/;
  return 'Vespucci' if $cr =~ /^Vespucci/;
  return 'Go Map!!' if $cr =~ /^Go (?:Map|Kaart)/;
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
  return 'RawEdit' if $cr =~ /^Osmose Raw Editor/;
  return 'OsmHydrant' if $cr =~ /^OsmHydrant/;
  return 'iLOE' if $cr =~ /^iLOE/;
  return 'YAPIS' if $cr =~ /^YAPIS/;
  return 'Services_OSM' if $cr =~ /^Services_OpenStreetMap/;
  return 'ArcGIS' if $cr =~ /^ArcGIS Editor/;
  return 'osmapis' if $cr =~ /^osmapis/;
  return 'osmapi' if $cr =~ /^osmapi(?:\/.+)?$/;
  return 'FreieTonne' if $cr =~ /^FreieTonne/;
  return 'osmtools' if $cr =~ /^osmtools\//;
  return 'Redaction bot' if $cr =~ /^Redaction bot/;
  return 'upload.py' if $cr =~ /^(?:.*\/)?upload\.py/;
  return 'bulk_upload.py' if $cr =~ /^bulk_upload\.py/;
  return 'bulk_upload_sax.py' if $cr =~ /^bulk_upload_sax\.py/;
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
  return 'fix.loggingroads.org' if $cr =~ /^fix\.loggingroads\.org/;
  return 'MapStalt Mini' if $cr =~ /^MapStalt Mini/;
  return 'osmupload.py' if $cr =~ /^osmupload\.py/;
  return "Jeff's Uploader" if $cr =~ /^Jeff's Uploader/;
  return 'AND node cleaner/retagger' if $cr =~ /^AND /;
  return 'MyUploader' if $cr =~ /^MyUploader/;
  return 'Tayberry' if $cr =~ /^Tayberry/;
  return 'GNOME Maps' if $cr =~ /^gnome-maps/;
  return 'StreetComplete' if $cr =~ /^StreetComplete /;
  return 'StreetComplete EE' if $cr =~ /^StreetComplete_ee /;
  return 'FireYak' if $cr =~ /^FireYak/;
  return 'MapContrib' if $cr =~ /^MapContrib/;
  return 'Geocropping' if $cr =~ /^Geocropping/;
  return 'RevertUI' if $cr =~ /^RevertUI/;
  return 'OSM ↔ Wikidata' if $cr =~ /osm\.wikidata\.link/;
  return 'OSM Contributor' if $cr =~ /^OSM Contributor/;
  return 'Jungle Bus' if $cr =~ /^Jungle Bus/;
  return 'IsraelHiking' if $cr =~ /^IsraelHiking\.osm/;
  return 'RocketData' if $cr =~ /^rocketdata\.io/;
  return 'Pic4Review' if $cr =~ /^Pic4Review/;
  return 'Tracks Editor' if $cr =~ /^Tracks Editor/;
  return 'Data4All' if $cr =~ /^Data4All/;
  return 'CityZen' if $cr =~ /^CityZen/;
  return 'Osm2go' if $cr =~ /^osm2go /;
  return 'AutoAWS' if $cr =~ /^autoAWS/;
  return 'DEVK Versicherung' if $cr =~ /^DEVK Versicherung/;
  return 'osm for ruby' if $cr =~ /^osm for ruby/;
  return 'osmlinzaddr.py' if $cr =~ /osmlinzaddr\.py/;
  return 'FixKarlsruheSchema' if $cr =~ /^FixKarlsruheSchema/;
  return 'GpsMid' if $cr =~ /^GpsMid_/;
  return 'AndNav2' if $cr =~ /^andnav\.org/;
  return 'Deriviste' if $cr =~ /^Deriviste/;
  return 'Brick' if $cr =~ /^Brick/;
  return 'SketchOSM' if $cr =~ /^SketchOSM/;
  return 'OSMyBiz' if $cr =~ /^OSMyBiz/;
  return 'Osm Go!' if $cr =~ /^Osm Go!/;
  return 'Parking Lanes' if $cr =~ /^PLanes/;
  return 'Rapid' if $cr =~ /^Rapi[dD] /;
  return 'TrashApp' if $cr =~ /^TrashApp/;
  return 'OsmInEdit' if $cr =~ /^OsmInEdit/;
  return 'MapComplete' if $cr =~ /^MapComplete/;
  return 'MapRoulette' if $cr =~ /^MapRoulette/;
  return 'Healthsites.io' if $cr =~ /^Healthsites\.io/;
  return 'OsmPipeline' if $cr =~ /^OsmPipeline/;
  return 'HTTPS All The Things' if $cr =~ /^https_all_the_things/;
  return 'addr2osm' if $cr =~ /^addr2osm/;
  return 'peundemerg.ro' if $cr =~ /^peundemerg.ro/;
  return 'Organic Maps' if $cr =~ /^O(rganic )?Maps /;
  return 'ProjetDuMois.fr' if $cr =~ /^ProjetDuMois/;
  return 'posiki_python_script' if $cr =~ /^posiki_python_script/;
  return 'Centaur Mapper' if $cr =~ /^Centaur Mapper/;
  return 'simple_revert' if $cr =~ /^(?:simple_revert|restore-version)\.py/;
  return 'POI Collector' if $cr =~ /^POI Collector v/;
  return 'Locus Map POI' if $cr =~ /^LoPoi /;
  return 'Mundi App' if $cr =~ /^Mundi App/;
  return 'OpenRecycleMap' if $cr =~ /^OpenRecycleMap/;
  return 'LINZ Import' if $cr =~ /^LINZ \w+ Import/;
  return 'Every Door' if $cr =~ /^Every Door /;
  return 'Mapa AED' if $cr =~ /aed\.openstreetmap\.org\.pl/;
  return 'Map builder' if $cr =~ /^Map builder /;
  return 'refill.bz.it' if $cr =~ /^Refill Südtirol \/ Alto Adige$/;
  return 'OpenAEDMap' if $cr =~ /openaedmap\.org/;
  return 'osm-revert' if $cr =~ /^osm-revert /;
  return 'OpenStop' if $cr =~ /^OpenStop/;
  return 'Other';
}

my %wikinames = (
  'Potlatch 0.x/1.x' => 'Potlatch 1',
  'Pushpin' => 'Pushpin OSM',
  'PythonOsmApi' => 'Osmapi',
  'OSMPOIEditor' => 'POI+',
  'rosemary' => 'Rosemary',
  'ArcGIS' => 'ArcGIS Editor for OSM',
  'upload.py' => 'Upload.py',
  'bulk_upload.py' => 'Bulk_upload.py',
  'bulk_upload_sax.py' => 'Bulk_upload_sax.py',
  'OpenMaps' => 'OpenMaps (IZE)',
  'Kort' => 'Kort Game',
  'Mapzen' => 'Mapzen POI Collector',
  'iLOE' => 'ILOE',
  'osmitter' => 'Osmitter',
  'QGIS' => 'QGIS OSM Plugin',
  'Services_OSM' => 'PHP',
  'Osmose Editor' => 'Osmose#Osmose_integrated_tags_editor',
  'Redaction bot' => 'OSMF Redaction Bot',
  'OpenSeaMap-Editor' => 'OpenSeaMap#Editor',
  'AND node cleaner/retagger' => 'AND Data',
  'FixKarlsruheSchema' => 'Xybot#So_what_does_the_FixKarlsruheSchema_ruleset_do_exactly',
  'Jungle Bus' => 'Jungle Bus mobile app',
  'HTTPS All The Things' => 'Automated Edits/b-jazz-bot',
  'OsmPipeline' => 'Import/Maine E911 Addresses',
  'LINZ Import' => 'Import/New Zealand Street Addresses (2021)',
  'OSM ↔ Wikidata' => 'OSM ↔ Wikidata matcher',
  'JOSM Reverter' => 'JOSM/Plugins/Reverter',
  'OpenStop' => 'DE:OpenStop',
  'StreetComplete EE' => 'SCEE'
);

my @wiki_self = (
  'JOSM', 'iD', 'Potlatch 2', 'Merkaartor', 'Vespucci', 'Go Map!!', 'MAPS.ME',
  'OsmAnd', 'Level0', 'OsmHydrant', 'RawEdit', 'Nomino', 'My Opening Hours',
  'FreieTonne', 'MapStalt Mini', 'OSMapTuner', 'MapContrib', 'StreetComplete',
  'OSM Contributor', 'Tracks Editor', 'Data4All', 'CityZen', 'Potlatch 3',
  'Osm2go', 'AutoAWS', 'GpsMid', 'Deriviste', 'AndNav2', 'OSMyBiz', 'Osm Go!',
  'Rapid', 'OsmInEdit', 'GNOME Maps', 'MapRoulette', 'MapComplete', 'Organic Maps',
  'Every Door', 'Pic4Review', 'posiki_python_script', 'RevertUI', 'osm-revert'
);
$wikinames{$_} = '' for @wiki_self;

my %websites = (
  'Geocropping' => 'https://geocropping.xsalto.com/guide.html',
  'IsraelHiking' => 'https://israelhiking.osm.org.il/',
  'RocketData' => 'https://rocketdata.io/',
  'DEVK Versicherung' => 'https://www.devk.de/',
  'osmlinzaddr.py' => 'https://git.nzoss.org.nz/ewblen/osmlinzaddr',
  'Brick' => 'https://edit.osmbuildings.org/',
  'SketchOSM' => 'https://mindsightstudios.com/sketchosm/',
  'Parking Lanes' => 'https://zlant.github.io/parking-lanes/',
  'TrashApp' => 'https://trashapp.cc/',
  'Healthsites.io' => 'https://healthsites.io/',
  'addr2osm' => 'https://github.com/NKAmapper/addr2osm',
  'peundemerg.ro' => 'https://forum.peundemerg.ro/index.php?topic=836.0',
  'ProjetDuMois.fr' => 'https://projetdumois.fr/projects/2021-05_laboratory',
  'OpenRecycleMap' => 'https://openrecyclemap.org/',
  'Locus Map POI' => 'https://www.vastuf.com/projects/lopoi/',
  'Mapa AED' => 'https://aed.openstreetmap.org.pl/',
  'osmtools' => 'https://github.com/woodpeck/osm-revert-scripts',
  'Map builder' => 'https://www.bing.com/mapbuilder/',
  'refill.bz.it' => 'https://www.refill.bz.it/',
  'OpenAEDMap' => 'https://openaedmap.org/'
);

sub editor_wikilink {
  my $e = shift;
  if (exists $wikinames{$e}) {
    return "[[".($wikinames{$e} ? $wikinames{$e}.'|' : '')."$e]]";
  } elsif (exists $websites{$e}) {
    return "[$websites{$e} $e]";
  }
  return $e;
}

1;
