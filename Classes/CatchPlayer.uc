//==============================================================================
//  Default player for the catch game
//  extended movement inspired by a Mutator of Wormbo that i can't find anymore
//	http://www.koehler-homepage.de/Wormbo/
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchPlayer extends xPlayer;


    var EPhysics    CurPhysics;
    var EPhysics    LastPhysics;

    var int         NumDodgesPerJump;
    var int         MaxDodgesPerJump;

    var EDoubleClickDir  LastDoubleClickDir;

    var bool    bFastDodging;
    var bool    bAlwaysAllowDodgeDoubleJump;

function PostBeginPlay()
{
  Super.PostBeginPlay();
}

//------------------------------------------------------------------------------
// PlayerTick based checking functions
//

event PlayerTick( float DeltaTime )
{
    local bool  bWasActive;

//    CheatProtection();
    Super.PlayerTick(DeltaTime);

    //CurPhysics = Pawn.Physics;

  if ( Pawn != None && Pawn.Physics == PHYS_Walking )
    NumDodgesPerJump = MaxDodgesPerJump;

  if ( bWasActive || DoubleClickDir == DCLICK_Active ) {
    if ( NumDodgesPerJump != 0 ) {
      NumDodgesPerJump--;
      if ( !bFastDodging || !bWasActive )
        ClearDoubleClick();
      DoubleClickDir = DCLICK_None;
    }
    if ( Pawn != none && xPawn(Pawn) != None && xPawn(Pawn).MultiJumpRemaining == 0 )
      xPawn(Pawn).MultiJumpRemaining = 1;
  }
  LastDoubleClickDir = DoubleClickDir;


}

defaultproperties
{
     MaxDodgesPerJump=2
     PlayerReplicationInfoClass=Class'CatchV2.CatchPRI'
     PawnClass=Class'CatchV2.CatchPawn'
}
