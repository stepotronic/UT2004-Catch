//==============================================================================
//  Mutator simulating a game of catch: Finds a player who has to catch the 
//  other people and constantly removes hitpoints
//	Removes all weapons and powerups
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchMutator extends Mutator;

var() int HealthDecrease;
var() int MaxHealth;
var catchPawn CurrentCatcher;


simulated function BeginPlay()
{
    local xPickupBase P;
    local Pickup L;

    foreach AllActors(class'xPickupBase', P)
    {
        P.bHidden = true;
        //if the pickup had an emitter we want it to be gone as well
        if (P.myEmitter != None)
            P.myEmitter.Destroy();
    }
    //Maybe this could be played on AS Maps :D
    foreach AllActors(class'Pickup', L)
        if ( L.IsA('WeaponLocker') )
            L.GotoState('Disabled');

    Super.BeginPlay();
 }


function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	super.CheckReplacement(Other, bSuperRelevant);

	bSuperRelevant = 0;
    if ( Other.IsA('Weapon') )
    {
        if ( Weapon(Other).bNoInstagibReplace )
        {
            bSuperRelevant = 0;
            return true;
        }

        if ( Other.IsA('TransLauncher'))
        {
            bSuperRelevant = 0;
            return true;
        }
    }

    if ( Other.IsA('Pickup') )
    {
        if ( Other.bStatic || Other.bNoDelete )
            Other.GotoState('Disabled');
        return false;
    }

    return true;
}


event PostBeginPlay()
{

    SetTimer(1.0,true);
}

function Timer()
{
    local Controller C;
    local Vector LocAndMom;
    local Pawn PawnForDamage;
    Local CatchPawn Catcher;
    Local CatchPawn MaxHealthCatcher;

    if (!Level.bBegunPlay) return;
    log('started');

    for (C = Level.ControllerList; C != None; C = C.NextController)
    {
        if (C.Pawn != None && C.Pawn.Health > 0 && CatchPawn(C.Pawn) != None)
        {
            Catcher = CatchPawn(C.Pawn);
            if (MaxHealthCatcher == none || (Catcher.Health + Catcher.Controller.PlayerReplicationInfo.NumLives * 100) > (MaxHealthCatcher.Health + MaxHealthCatcher.PlayerReplicationInfo.NumLives * 100))
            {
                MaxHealthCatcher = Catcher;
            }

            if (CurrentCatcher != none && Level.Game.bGameEnded != true)
            {
                if (Catcher.bIsCatcher)
                {
                    PlayerController(C).ReceiveLocalizedMessage(class'CatchMessage', 0);
                    CurrentCatcher = Catcher;
                    C.Pawn.TakeDamage(HealthDecrease, PawnForDamage, LocAndMom, LocAndMom, class'Expired');
                }
                else
                {
                    PlayerController(C).ReceiveLocalizedMessage(class'CatchMessage', 1, CurrentCatcher.PlayerReplicationInfo);
                }
            }
        }
    }

    if (CurrentCatcher==none)
    {
     CurrentCatcher = MaxHealthCatcher;
     CurrentCatcher.bIsCatcher=true;
     CurrentCatcher.CreateInventory("CatchV2.CatchHand");
    }


}


function ModifyPlayer(Pawn Other)
{
    //Other.CreateInventory("CatchV2.CatchHand");
    Other.Health=MaxHealth;
    Super.ModifyPlayer(Other);
}

defaultproperties
{
     HealthDecrease=3
     MaxHealth=100
     FriendlyName="Catch V2"
     Description="A little game of catch :) www.nimbleminds.eu "
}
