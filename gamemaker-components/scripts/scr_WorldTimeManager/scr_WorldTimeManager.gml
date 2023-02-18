
///@desc Time manager ticks per second: how many times per a second the world state updates.
/// SecondsPerTick: How much of a second elapses per tick. WorldSequence: What current iteration of the world state is.
/// TickProgress: Percentage (a number from 0 to 1) of the way to the next frame we are at. Used for draw tweening.
///@param {Struct.TimeProvider} _timeProvider
function WorldTimeManager(_timeProvider) constructor {
    // Feather disable GM2017
    ticksPerSecond = 10;
    secondsPerTick = 1 / ticksPerSecond;
    timeProvider = _timeProvider;

    worldSequence = 0;
    secondsSinceLastTick = 0;
    tickProgress = 0;
    // Feather restore GM2017
    
    ///@function setTickRate(_fps)
    ///@desc     How many frames per second between 0 and 120 should this time manager run.
    ///@param {Real} _fps
    static setTickRate = function set_tick_rate(_fps) {
        ticksPerSecond = round(clamp(_fps, 0, 120));
    
        if(ticksPerSecond > 0) {
            secondsPerTick = 1 / ticksPerSecond;
        }
    }

    ///@function stepClock()
    ///@desc     Advance the time on time manager according to how much time has passed from the timeProvider
    ///@return {Bool} Returns true if the worldSequence progressed, false otherwise
    static stepClock = function step_clock() {
        if(ticksPerSecond < 1) {
            return false;
        }

        secondsSinceLastTick += timeProvider.getDeltaSeconds();
        tickProgress = secondsSinceLastTick / secondsPerTick;
        
        var _progressedSequence = false;
        if( secondsSinceLastTick >= secondsPerTick ) {
            tickProgress = 0;
            secondsSinceLastTick -= secondsPerTick;
            worldSequence += 1;
            _progressedSequence = true;
        }

        return _progressedSequence;
    }
}