#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'MusicBrainz::Server::Edit::Recording::AddISRCs' };

use MusicBrainz::Server::Constants qw( $EDIT_RECORDING_ADD_ISRCS );
use MusicBrainz::Server::Test qw( accept_edit reject_edit );

my $c = MusicBrainz::Server::Test->create_test_context();
MusicBrainz::Server::Test->prepare_test_database($c, '+edit_recording');
MusicBrainz::Server::Test->prepare_raw_test_database($c);

my $edit = create_edit();
isa_ok($edit, 'MusicBrainz::Server::Edit::Recording::AddISRCs');

my ($edits) = $c->model('Edit')->find({ recording => 1 }, 10, 0);
is($edits->[0]->id, $edit->id);

my $recording = $c->model('Recording')->get_by_id(1);
is($recording->edits_pending, 0);

my @isrcs = $c->model('ISRC')->find_by_recording(1);
is(scalar @isrcs, 1);
is($isrcs[0]->isrc, 'DEE250800232');

done_testing;

sub create_edit {
    return $c->model('Edit')->create(
        edit_type => $EDIT_RECORDING_ADD_ISRCS,
        editor_id => 1,
        isrcs => [
            { recording_id => 1, isrc => 'DEE250800232' }
        ]
    );
}