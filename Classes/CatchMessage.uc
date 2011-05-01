//==============================================================================
//  Message blinking on the bottom of the screen telling you who is trying to
//  catch you or ordering to catch somebody
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchMessage extends LocalMessage;


static function string GetString(
	optional int SwitchNum,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
    if(SwitchNum == 0)
	    return "Go catch somebody!";
    else
        return ""$RelatedPRI_1.PlayerName$" is trying to catch you!";
}

defaultproperties
{
     bIsUnique=True
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=150,G=0,R=50)
}
