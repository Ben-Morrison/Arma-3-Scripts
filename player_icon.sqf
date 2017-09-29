/*
	Author: Ben Morrison
	Date: 29 September 2017
	Description: This is a client side script that creates a map marker for each player connected to the server, and for each vehicle with players inside of it.
	Player markers display the player group and name, aand change color if the player is alive, incapacitated, or dead.
	Vehicle markers display the vehicle type and the name of each player that is inside of it.
*/

if(isDedicated) exitWith {};

_markers = [];
_vehicleMarkers = [];

while{true} do {
	try {

		if (visibleGPS || visibleMap) then {
			_players = [];
			
			{	
				_name = name _x;
				_group = groupId group _x;
				_markername = _name;
				
				_player = [_name, _x];
				_players pushBack _player;
				
				if(getMarkerColor _markername == "") then {
					_marker = createMarkerLocal [_markername, getpos _x];
					_marker setMarkerTypeLocal "b_inf";
					_marker setMarkerColorLocal "ColorGreen";
					_marker setMarkerTextLocal format["%1: %2", _group, _name];
					_markers pushBack _markername;
					
					//systemChat format["%1 marker created", _name];
				};
			} foreach allPlayers;
			
			_deleteArray = [];
			
			{
				_y = _x;
				_delete = true;
				
				{
					_temp = _x select 1;
					
					if(_x select 0 == _y) then {
						if(vehicle _temp != _temp) then {
							_y setMarkerAlphaLocal 0;
						} else { _y setMarkerAlphaLocal 1; };
					
						_y setMarkerPosLocal getpos _temp;
						_delete = false;
						
						if(lifeState _temp == "HEALTHY") then {
							_y setMarkerColorLocal "ColorGreen";
						};
						
						if(lifeState _temp == "DEAD" || lifeState _temp == "DEAD-RESPAWN" || lifeState _temp == "DEAD-SWITCHING") then {
							_y setMarkerColorLocal "ColorRed";
						};
						
						if(lifeState _temp == "INCAPACITATED") then {
							_y setMarkerColorLocal "ColorYellow";
						};
					};
				} foreach _players;
				
				if(_delete) then {
					_deleteArray pushBack _x;
					deleteMarkerLocal _x;
				};
			} foreach _markers;
			
			{
				_markers = _markers - [_x];
				//systemChat format["%1 marker deleted", _y];
			} foreach _deleteArray;
			
			{
				deleteMarkerLocal _x;
			} foreach _vehicleMarkers;
			
			{
				_count = 0;				
				_names = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "DisplayName");
				_names = _names + ": ";
				
				{
					if(isPlayer _x) then {
						if(_count != 0) then { _names = _names + ", "; };
						_count = _count + 1;
						_names = _names + name _x;
					}
				} foreach crew _x;
				
				if(_count > 0) then {
					_marker = createMarkerLocal [_names, getpos _x];
					_marker setMarkerTextLocal _names;
					_marker setMarkerTypeLocal "b_inf";
					_marker setMarkerColorLocal "ColorBlue";
					_vehicleMarkers pushBack _marker;
				};
			} foreach vehicles;
		};
	}
	catch {
		
	};

	sleep 0.1;
};