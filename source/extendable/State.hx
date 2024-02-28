package extendable;

import flixel.FlxState;

import flixel.addons.transition.FlxTransitionableState;

import subStates.Transition;

class State extends FlxState
{
    override function create():Void
    {
        super.create();

        if (FlxTransitionableState.skipNextTransIn)
            FlxTransitionableState.skipNextTransIn = false;
        else
            openSubState(new Transition(function() {}, 0.875, true));
    }

    override function startOutro(onOutroComplete:()->Void):Void
    {
        if (FlxTransitionableState.skipNextTransOut)
            FlxTransitionableState.skipNextTransOut = false;
        else
        {
            openSubState(new Transition(onOutroComplete, 0.875, false));

            return;
        }

        onOutroComplete();
    }
}