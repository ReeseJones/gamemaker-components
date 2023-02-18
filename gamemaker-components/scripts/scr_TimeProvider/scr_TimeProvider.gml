function TimeProvider() constructor {
    
    ///@function getDeltaSeconds()
    ///@desc     returns number of seconds elapsed since last frame
    static getDeltaSeconds = function() {
        return delta_time / MICROSECONDS_PER_SECOND;
    }

}