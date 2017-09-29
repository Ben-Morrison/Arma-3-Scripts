/*
	Author: Ben Morrison
	Date: 29 September 2017
	Description: This is a server side script defining functions to create enemy units, patrols and civilians
*/

createUnits = {
	params["_unitList", "_maxUnits"];
	
	_group = createGroup west;
	_group enableDynamicSimulation true;
	
	_posX = (_center select 0) + (random _size) - (random _size);
	_posY = (_center select 1) + (random _size) - (random _size);
	
	_pos = [_posX, _posY, 0];
	_pos = [_pos, 0, 25, 0, 0, 0, 0, [], [_pos]] call BIS_fnc_findSafePos;

	_unit = _group createUnit [unit_spawnlist_main select 0, _pos, [], 0, "FORM"];
	_unit enableDynamicSimulation true;
	
	[_unit] call file_unit_init;
	zues1 addCuratorEditableObjects [[_unit]];
	
	[_unit, _size] execVM "loiter.sqf";
	
	_unitList = _unitList + [_unit];
	
	sleep 0.1;
	
	_squadMembers = floor random 3;
	
	for [{_i=0}, {_i<_squadMembers}, {_i=_i+1}] do {
		if(count _unitList < _maxUnits) then {
			_unit = _group createUnit [selectRandom unit_spawnlist_main, [_posX, _posY, 0], [], 0, "FORM"];
			_unit enableDynamicSimulation true;
			[_unit] call file_unit_init;
			
			zues1 addCuratorEditableObjects [[_unit]];
			
			_unitList = _unitList + [_unit];
			
			sleep 0.1;
		};
	};
	
	_group setSpeedMode "LIMITED";
	_group setBehaviour "SAFE";
	
	_group enableDynamicSimulation true;
	
	_unitList;
};

createPatrol = {
	params["_pos", "_radius", "_group"];

	_pos = [_pos, 0, 25, 0, 0, 0, 0, [], [_pos]] call BIS_fnc_findSafePos;
	
	_unit = _group createUnit [unit_spawnlist_patrol select 0, _pos, [], 0, "FORM"];
	[_unit] call file_unit_init;
	zues1 addCuratorEditableObjects [[_unit]];
	
	sleep 0.1;
	
	_count = random [1, 2, 3];
	for [{_i=0}, {_i<_count}, {_i=_i+1}] do {
		_unit = _group createUnit [selectRandom unit_spawnlist_patrol, _pos, [], 0, "FORM"];
		[_unit] call file_unit_init;
		zues1 addCuratorEditableObjects [[_unit]];
		
		sleep 0.1;
	};
	
	_group setSpeedMode "LIMITED";
	_group setBehaviour "SAFE";
	
	_posX = (_pos select 0) + (random _radius) - (random _radius);
	_posY = (_pos select 1) + (random _radius) - (random _radius);
	_location = [_posX,_posY,0];
	_location = [_location, 0, 25, 0, 0, 0, 0, [], [_location]] call BIS_fnc_findSafePos;

	_waypoint1 = _group addwaypoint [_location,0];
	_waypoint1 setWayPointtype "MOVE";
	_waypoint1 setWaypointTimeout [0, 15, random 60];

	_patrolPos = selectRandom patrol_locations;
	_posX = (_patrolPos select 0) + (random _radius) - (random _radius);
	_posY = (_patrolPos select 1) + (random _radius) - (random _radius);
	_location = [_posX,_posY,0];
	_location = [_location, 0, 25, 0, 0, 0, 0, [], [_location]] call BIS_fnc_findSafePos;

	_waypoint2 = _group addwaypoint [_location,1];
	_waypoint2 setWayPointtype "MOVE";
	_waypoint2 setWaypointTimeout [0, 15, random 60];

	_patrolPos = selectRandom patrol_locations;
	_posX = (_patrolPos select 0) + (random _radius) - (random _radius);
	_posY = (_patrolPos select 1) + (random _radius) - (random _radius);
	_location = [_posX,_posY,0];
	_location = [_location, 0, 25, 0, 0, 0, 0, [], [_location]] call BIS_fnc_findSafePos;

	_waypoint3 = _group addwaypoint [_location,2];
	_waypoint3 setWayPointtype "MOVE";
	_waypoint3 setWaypointTimeout [0, 15, random 60];
};

createCivilians = {
	_count = floor random [2, 4, 6];
	
	for [{_i=0}, {_i<_count}, {_i=_i+1}] do {
		_group = createGroup civilian;
		_group enableDynamicSimulation true;
		
		_posX = (_center select 0) + (random _size) - (random _size);
		_posY = (_center select 1) + (random _size) - (random _size);

		_unit = _group createUnit [selectRandom unit_spawnlist_civilian, [_posX, _posY, 0], [], 0, "FORM"];
		_unit enableDynamicSimulation true;
		
		[_unit, _size] execVM "loiter.sqf";
		
		_group setSpeedMode "LIMITED";
		_group setBehaviour "SAFE";
				
		zues1 addCuratorEditableObjects [[_unit]];
		
		_group enableDynamicSimulation true;
	};
};
