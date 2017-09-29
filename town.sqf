/*
	Author: Ben Morrison
	Date: 29 September 2017
	Description: This is a server side script that represents a Town on the map.
	Each town has a maximum number of stationed units, and one recon patrol
	When no players are near the town, the town will regenerate units and patrols until the units are at maximum
	When all units have been eliminated in a town, the town will become inactive.
	The town will become active again when no player has been present after a period of time and resume spawning units and patrols.
*/

if(!isServer) exitWith {};

params ["_center", "_size", "_markerStatus", "_maxUnits", "_spawnPatrol"];

_active = true;
_unitList = [];

_patrol = [];
_patrol_group = creategroup west;

// Create the initial units in the town
while{count _unitList < _maxUnits} do {
	_unitList = [_unitList, _maxUnits] call createUnits;
};

//[] call createCivilians;

if(_spawnPatrol) then {
	[_center, _size, _patrol_group] call createPatrol;
};

_timer = 0;
_timerMax = 600;

_timerSpawn = 0;
_timerSpawnMax = 300;

_timerPatrol = 0;
_timerPatrolMax = 200;

_playerNear = false;

while {true} do {
	sleep (1 * towns_timer_modifier);
	
	// Display status
	if(_active) then { 
		_markerStatus setmarkercolor "ColorYellow"; 
	} else {
		_markerStatus setmarkercolor "ColorRed"; 
	};
	
	_markerStatus setmarkertext format ["Units: %1 Timer: %2 TimerSpawn: %3 TimerPatrol: %4", count _unitList, _timer, _timerSpawn, _timerPatrol];

	// Remove dead units
	for [{_i=0}, {_i<count _unitList}, {_i=_i+1}] do {
		_unit = _unitList select _i;
	
		if(isNil "_unit") then {
			_unitList = _unitList - [_unitList select _i];
			_i = _i - 1;
			
			if(count _unitList == 0) then {
				_active = false;
				_timer = 0;
				_timerSpawn = 0;
			};
		} else {
			if(!(alive (_unitList select _i))) then {
				_unitList = _unitList - [_unitList select _i];
				_i = _i - 1;
				
				if(count _unitList == 0) then {
					_active = false;
					_timer = 0;
					_timerSpawn = 0;
				};
			};
		};
	};	
	
	// Check for near players
	_playerNear = false;
	
	{
		if((getpos _x distance2d _center) < 2000) then { _playerNear = true; _timerSpawn = 0; _timerPatrol = 0; };
	} foreach allPlayers;
	
	// Increment timer
	if(_active) then {
		if(count _unitList < _maxUnits) then {
			if(_timerSpawn < _timerSpawnMax) then {
				_timerSpawn = _timerSpawn + 1;
			} else {
				_unitList = [_unitList, _maxUnits] call createUnits;
				_timerSpawn = 0;
			};
		};
		
		if(_spawnPatrol) then {
			if(count units _patrol_group == 0) then {
				if(_timerPatrol < _timerPatrolMax) then {
					_timerPatrol = _timerPatrol + 1;
				} else {
					_timerPatrol = 0;
					[_center, _size, _patrol_group] call createPatrol;
				};
			} else { _timerPatrol = 0; };
		};
	} else {
		if(_timer < _timerMax) then {
			if(!_playerNear) then {
				_timer = _timer + 1;
			};
		} else {
			_active = true;
			_timer = 0;
			_timerSpawn = 0;
			_timerPatrol = 0;
		};
	};
};