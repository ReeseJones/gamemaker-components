function reliable_sequence_greater_than( _s1, _s2) {
    return ( ( _s1 > _s2 ) && ( _s1 - _s2 <= 32768 ) ) ||
           ( ( _s1 < _s2 ) && ( _s2 - _s1  > 32768 ) );
}

function reliable_sequence_less_than(_s1, _s2) {
    return reliable_sequence_greater_than(_s2, _s1);
}