class_name PlayerStates
extends RefCounted

static var DOOMED: PlayerState = PlayerState.create("doomed", 20.0, "doomed", 1.5)
static var ANXIOUS: PlayerState = PlayerState.create("anxious", 40.0, "anxious", 1.0)
static var NOT_GREAT: PlayerState = PlayerState.create("not_great", 60.0, "not_great", 0.7)
static var NEUTRAL: PlayerState = PlayerState.create("neutral", 80.0, "neutral", 0.5)
static var CONTENT: PlayerState = PlayerState.create("content", 100.0, "content", 0.3)

static var STATES: Array[PlayerState] = [
	DOOMED,
	ANXIOUS,
	NOT_GREAT,
	NEUTRAL,
	CONTENT
]
