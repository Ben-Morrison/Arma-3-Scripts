/*
	Author: Ben Morrison
	Date: 29 September 2017
	Description: This is a server side script that takes a unit and a radius as parameters and makes the unit loiter randomly in the given radius
*/

if(!isServer) exitWith {};

params ["_unit", "_radius"];

_center = position _unit;

while {!(isNil "_unit")} do {	
	deleteWaypoint [group _unit, 0];
	
	_posX = (_center select 0) + (random _radius) - (random _radius);
	_posY = (_center select 1) + (random _radius) - (random _radius);
	_location = [_posX,_posY,0];
	_location = [_center, 0, _radius, 0, 0, 0, 0, [], [_location]] call BIS_fnc_findSafePos;

	_waypoint = group _unit addwaypoint [_location,0];
	_waypoint setWayPointtype "MOVE";
	
	sleep random [5, 30, 120];
	
	if(!(alive _unit)) then {
		_unit = nil;
	};
};



