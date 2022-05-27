function ReliableSequenceGreaterThan( s1, s2) {
	return ( ( s1 > s2 ) && ( s1 - s2 <= 32768 ) ) || 
           ( ( s1 < s2 ) && ( s2 - s1  > 32768 ) );
}

function ReliableSequenceLessThan(s1, s2) {
	return ReliableSequenceGreaterThan(s2, s1);
}