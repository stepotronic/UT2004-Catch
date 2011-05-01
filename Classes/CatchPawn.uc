//==============================================================================
//  Default pawn for the catch-game
//  extended movement inspired by a Mutator of Wormbo that i can't find anymore
//	http://www.koehler-homepage.de/Wormbo/
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchPawn extends xPawn;

var bool bIsCatcher;
var bool bIsCatchable;
//no inventory
function AddDefaultInventory()
{
}
//if the player died change the status
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local int actualDamage;
    local Controller Killer;

    if ( damagetype == None )
    {
        if ( InstigatedBy != None )
            warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
        DamageType = class'DamageType';
    }

    if ( Role < ROLE_Authority )
    {
        log(self$" client damage type "$damageType$" by "$instigatedBy);
        return;
    }

//    if ( Health <= 0 )
//        return;

    if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
        instigatedBy = DelayedDamageInstigatorController.Pawn;

    if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
        SetMovementPhysics();
    if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
        momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
    if ( instigatedBy == self )
        momentum *= 0.6;
    momentum = momentum/Mass;

    if (Weapon != None)
        Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if (DrivenVehicle != None)
            DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
        Damage *= 2;
    actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
    if( DamageType.default.bArmorStops && (actualDamage > 0) )
        actualDamage = ShieldAbsorb(actualDamage);


    if ( HitLocation == vect(0,0,0) )
        HitLocation = Location;

     if (instigatedBy != self ){
        Health -= actualDamage;
        if ( DamageType!=class'Expired'){
           MakeNoise(1.0);
           PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);
        }
    }
    if ( Health <= 0 )
    {
        // pawn died
        if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
            Killer = LastHitBy;
        else if ( instigatedBy != None )
            Killer = instigatedBy.GetKillerController();
        if ( Killer == None && DamageType.Default.bDelayedDamage )
            Killer = DelayedDamageInstigatorController;
        if ( bPhysicsAnimUpdate )
            TearOffMomentum = momentum;
        Died(Killer, damageType, HitLocation);
        bIsCatcher=false;
    }
    else
    {
        AddVelocity( momentum );
        if ( Controller != None && DamageType!=class'Expired')
            Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
        if ( instigatedBy != None && instigatedBy != self )
            LastHitBy = instigatedBy.Controller;
    }
}
//***********************************************************
//better movement
//***********************************************************
function bool Dodge(eDoubleClickDir DoubleClickMove)
{
    local vector X,Y,Z, TraceStart, TraceEnd, Dir, Cross, HitLocation, HitNormal;
    local Actor HitActor;
    local rotator TurnRot;

    if ( bIsCrouched || bWantsToCrouch || (Physics != PHYS_Walking && Physics != PHYS_Falling) )
        return false;

    TurnRot.Yaw = Rotation.Yaw;
    GetAxes(TurnRot,X,Y,Z);

    if ( Physics == PHYS_Falling )
    {
        if ( !bCanWallDodge )
            return false;
        if (DoubleClickMove == DCLICK_Forward)
            TraceEnd = -X;
        else if (DoubleClickMove == DCLICK_Back)
            TraceEnd = X;
        else if (DoubleClickMove == DCLICK_Left)
            TraceEnd = Y;
        else if (DoubleClickMove == DCLICK_Right)
            TraceEnd = -Y;
        TraceStart = Location - CollisionHeight*Vect(0,0,1) + TraceEnd*CollisionRadius;
        TraceEnd = TraceStart + TraceEnd*32.0;
        HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false, vect(1,1,1));
        if ( (HitActor == None) || (!HitActor.bWorldGeometry && (Mover(HitActor) == None)) )
             return false;
    }
    if (DoubleClickMove == DCLICK_Forward)
    {
        Dir = X;
        cross = Y;
    }
    else if (DoubleClickMove == DCLICK_Back)
    {
        Dir = -1 * X;
        Cross = Y;
    }
    else if (DoubleClickMove == DCLICK_Left)
    {
        Dir = -1 * Y;
        Cross = X;
    }
    else if (DoubleClickMove == DCLICK_Right)
    {
        Dir = Y;
        Cross = X;
    }
    if ( AIController(Controller) != None )
        cross = vect(0,0,0);
    return PerformDodge(DoubleClickMove, Dir,Cross);
}

function bool PerformDodge(eDoubleClickDir DoubleClickMove, vector Dir, vector Cross)
{
    local float VelocityZ;
    local name Anim;

    if ( Physics == PHYS_Falling )
    {
        if (DoubleClickMove == DCLICK_Forward)
            Anim = WallDodgeAnims[0];
        else if (DoubleClickMove == DCLICK_Back)
            Anim = WallDodgeAnims[1];
        else if (DoubleClickMove == DCLICK_Left)
            Anim = WallDodgeAnims[2];
        else if (DoubleClickMove == DCLICK_Right)
            Anim = WallDodgeAnims[3];

        if ( PlayAnim(Anim, 1.0, 0.1) )
            bWaitForAnim = true;
            AnimAction = Anim;

        TakeFallingDamage();
        if (Velocity.Z < -DodgeSpeedZ*0.5)
            Velocity.Z += DodgeSpeedZ*0.5;
    }

    VelocityZ = Velocity.Z;
    Velocity = DodgeSpeedFactor*GroundSpeed*Dir + (Velocity Dot Cross)*Cross;

//    if ( !bCanDodgeDoubleJump )
//        MultiJumpRemaining = 0;
    if ( bCanBoostDodge || (Velocity.Z < -100) )
        Velocity.Z = VelocityZ + DodgeSpeedZ;
    else
        Velocity.Z = DodgeSpeedZ;

    CurrentDir = DoubleClickMove;
    SetPhysics(PHYS_Falling);
    MultiJumpRemaining = 1;

    if (Controller != None && PlayerController(Controller)!= None){
//        PlayerController(Controller).ClearDoubleClick();
        PlayerController(Controller).DoubleClickDir = DCLICK_None;
        PlayerController(Controller).bDoubleJump = false;
    }

    PlayOwnedSound(GetSound(EST_Dodge), SLOT_Pain, GruntVolume,,80);
    return true;
}

function DoDoubleJump( bool bUpdating )
{
    PlayDoubleJump();

    if ( !bIsCrouched && !bWantsToCrouch )
    {
        if ( !IsLocallyControlled() || (AIController(Controller) != None) )
            MultiJumpRemaining -= 1;
        Velocity.Z = JumpZ + MultiJumpBoost;
        SetPhysics(PHYS_Falling);
        if ( !bUpdating )
            PlayOwnedSound(GetSound(EST_DoubleJump), SLOT_Pain, GruntVolume,,80);
    }
}

function bool CanDoubleJump()
{
    return ( (MultiJumpRemaining > 0) && (Physics == PHYS_Falling) );
}


function Landed(vector HitNormal)
{
    super.Landed(HitNormal);

}

function bool DoJump( bool bUpdating )
{
    // This extra jump allows a jumping or dodging pawn to jump again mid-air
    // (via thrusters). The pawn must be within +/- 100 velocity units of the
    // apex of the jump to do this special move.

    if ( !bUpdating && CanDoubleJump()&& (Abs(Velocity.Z) < 100) && IsLocallyControlled() )
    {
        if ( PlayerController(Controller) != None )
            PlayerController(Controller).bDoubleJump = true;
        DoDoubleJump(bUpdating);
        MultiJumpRemaining -= 1;
        return true;
    }

    if ( Super.DoJump(bUpdating) )
    {
        if ( !bUpdating )
            PlayOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
        return true;
    }
    return false;
}


function setCatcherTimer()
{
    SetTimer(5.0,false);
    bIsCatchable=false;
}


function Timer()
{
    bIsCatchable=true;
}

defaultproperties
{
     bIsCatchable=True
     bCanBoostDodge=True
}
