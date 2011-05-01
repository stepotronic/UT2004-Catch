//==============================================================================
// Debug Hud
//
//  © 2011, Thorsten 'stepotronic' Hallwas www.nimbleminds.eu
//==============================================================================
class CatchHUD extends HudCDeathMatch;

var string debugHelper[11];

simulated function setDebugHelper(String newHelper, int index)
{
    debugHelper[index]=newHelper;
}

simulated function DrawHudPassC (Canvas C)
{
    super.DrawHudPassC(C);

    C.SetDrawColor(255,255,255);
    C.SetPos(0.0,0.0*C.ClipY);
    C.DrawText(debugHelper[0]);
    C.SetPos(0.0,0.05*C.ClipY);
    C.DrawText(debugHelper[1]);
    C.SetPos(0.0,0.1*C.ClipY);
    C.DrawText(debugHelper[2]);
    C.SetPos(0.0,0.15*C.ClipY);
    C.DrawText(debugHelper[3]);
    C.SetPos(0.0,0.2*C.ClipY);
    C.DrawText(debugHelper[4]);
    C.SetPos(0.0,0.25*C.ClipY);
    C.DrawText(debugHelper[5]);
    C.SetPos(0.0,0.3*C.ClipY);
    C.DrawText(debugHelper[6]);
    C.SetPos(0.0,0.35*C.ClipY);
    C.DrawText(debugHelper[7]);

    C.SetPos(0.0,0.40*C.ClipY);
    C.DrawText(debugHelper[8]);
    C.SetPos(0.0,0.45*C.ClipY);
    C.DrawText(debugHelper[9]);
    C.SetPos(0.0,0.50*C.ClipY);
    C.DrawText(debugHelper[10]);


}

defaultproperties
{
}
