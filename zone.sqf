players_zone = [];

fnc_zone = {
	while {true} do {
		sleep 0.1;
		
		_players = list trigger_zone;
		
		{
			if(alive _x) then {
				if(players_zone find _x == -1) then {
				
					if(vehicle _x != _x) then {
						if(list trigger_zone find vehicle _x == -1) then {
							[_x] spawn fnc_zone_player;
							player sideChat "vehicle";
							players_zone = players_zone + [_x];
						};
					};
				
					if(vehicle _x == _x) then {
						if(list trigger_zone find _x == -1) then {
							player sideChat "player";
							[_x] spawn fnc_zone_player;
							players_zone = players_zone + [_x];
						};
					};
				};
			};
		} foreach allPlayers;
	};
};

fnc_zone_player = {
	params ["_unit"];

	_time = 20;
	_looping = true;

	while { _looping } do {
		_time = _time - 1;
		
		[[format["You are outside the playzone\n%1 seconds until death", _time], "PLAIN"]] remoteExec ["titleText", _unit];
		
		if(_time <= 0) then {
			_unit setDamage 1;
			_looping = false;
			
			players_zone = players_zone - [_unit];
		};
		
		if(vehicle _unit != _unit) then {
			if( list trigger_zone find vehicle _unit != -1 ) then {
				_looping = false;
				[["", "PLAIN"]] remoteExec ["titleText", _unit];
				
				players_zone = players_zone - [_unit];
			};
		};
		
		if(vehicle _unit == _unit) then {
			if( list trigger_zone find _unit != -1 ) then {
				_looping = false;
				[["", "PLAIN"]] remoteExec ["titleText", _unit];
				
				players_zone = players_zone - [_unit];
			};
		};
		
		sleep 1;
	};
};

[] spawn fnc_zone;