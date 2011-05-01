//==============================================================================
//  Damage type anouncing the death for the event when a player wasn't able to 
//  catch somebody in time
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
Class Expired extends DamageType
    abstract;

defaultproperties
{
     DeathString="%o couldn't catch anyone in time :D"
     FemaleSuicide="%o couldn't catch anyone in time :D"
     MaleSuicide="%o couldn't catch anyone in time :D"
     bArmorStops=False
     bAlwaysGibs=True
     bLocationalHit=False
     GibPerterbation=1.000000
}
