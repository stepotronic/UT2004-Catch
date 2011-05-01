//==============================================================================
//  Main Game Class
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchGame extends xLastManStandingGame config;

event InitGame(string Options, out string Error)
{
    Super.InitGame(Options, Error);
    GameDifficulty = 7;
    GameSpeed = 1.0;
    bAutoNumBots = false;
    bAdjustSkill = false;
    SpawnProtectionTime = 0.0;
}

function AddGameSpecificInventory(Pawn p)
{
}

function BeginPlay()
{
    Super.BeginPlay();
}

event PostLogin(PlayerController NewPlayer)
{
    Super.PostLogin(NewPlayer);
}

static function bool AllowMutator( string MutatorClassName )
{
	return true;
}

defaultproperties
{
     bAllowAdrenaline=True
     bForceRespawn=True
     bAllowWeaponThrowing=False
     DefaultPlayerClassName="CatchV2.CatchPawn"
     HUDType="CatchV2.CatchHud"
     MutatorClass="CatchV2.CatchMutator"
     PlayerControllerClassName="CatchV2.CatchPlayer"
     GameName="Catch"
     Description="A little game of catch :) www.nimbleminds.eu"
     Acronym="Catch"
}
