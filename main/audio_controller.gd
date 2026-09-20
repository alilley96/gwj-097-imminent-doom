class_name AudioController
extends Node

# Exports ----------------------------------------------------------------

@export var sfx_audio_player: AudioStreamPlayer2D
@export var music_audio_player: AudioStreamPlayer2D

@export var pop_sfx: Array[AudioStream]
@export var damage_sfx: Array[AudioStream]


# Public Functions ----------------------------------------------------------------

func play_pop_sfx() -> void:
	var random_index = randi_range(0, pop_sfx.size() - 1)

	sfx_audio_player.stream = pop_sfx[random_index]
	sfx_audio_player.play()


func play_damage_sfx() -> void:
	var random_index = randi_range(0, damage_sfx.size() - 1)

	sfx_audio_player.stream = damage_sfx[random_index]
	sfx_audio_player.play()


func play_music(music_name: String) -> void:
	var playback: AudioStreamPlaybackInteractive = music_audio_player.get_stream_playback()
	playback.switch_to_clip_by_name(music_name)
