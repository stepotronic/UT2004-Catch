//==============================================================================
//  The fire class used for tracing the opponent 
//  and assign a new person if opponent found
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchFire extends WeaponFire config;

var int TraceRange;

var config sound CatchSound;

event ModeDoFire()
{
 	local Vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local Rotator Aim;
	local Actor Other;
	local CatchPawn Victim;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location;
	Aim = AdjustAim(StartTrace, AimError);
	EndTrace = StartTrace + TraceRange * Vector(Aim);
	Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

	if ( Other != None && Other != Instigator )
	{
		if ( Pawn(Other) != None){
		    Victim = CatchPawn(Pawn(Other));
		    if(CatchPawn(Instigator).bIsCatcher)
            {
               Victim.bIsCatcher=true;
               Victim.bIsCatchable=false;
               Victim.CreateInventory("CatchV2.CatchHand");
               CatchPawn(Instigator).bIsCatcher=false;
               CatchPawn(Instigator).setCatcherTimer();
               CatchPawn(Instigator).DeleteInventory(Weapon);
               //award adrenalin
               Instigator.Controller.AwardAdrenaline(10.0);
               Instigator.Controller.PlayerReplicationInfo.Score+= 1;
               PlayerController(Instigator.Controller).ClientPlaySound(CatchSound);
            }
        }
	}
}

function DoFireEffect()
{

}

defaultproperties
{
     TraceRange=200
     CatchSound=SoundGroup'WeaponSounds.BioRifle.BioRifleFire'
     AmmoClass=Class'CatchV2.CatchAmmo'
}
