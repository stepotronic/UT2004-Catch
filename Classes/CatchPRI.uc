//==============================================================================
//  Player replication Info for the won rounds
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchPRI extends xPlayerReplicationInfo;

var int RoundsWon;

replication
{
	reliable if(bNetDirty && (Role == ROLE_Authority))
		RoundsWon;
}

defaultproperties
{
}
