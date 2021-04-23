_factions = _this select 0; // array of str
_classes = _this select 1; // array of str

// Grab configClasses and insert into an array, excluding base classes
private _cfgArr = "getText (_x >> 'faction') in _factions and 'Man' in ([_x, true] call BIS_fnc_returnParents) and !('base' in toLower configName _x)" configClasses (configFile >> "CfgVehicles");

// Add specific classes
{
    _cfgArr pushBackUnique (configfile >> "CfgVehicles" >> _x)
} forEach _classes;

// Capture items from each configuration
private _backpacks = [];
private _items = [];
private _magazines = [];
private _uniforms = [];
private _weapons = [];
{
    _backpacks pushBackUnique getText (_x >> 'backpack');
    _items append getArray (_x >> 'linkedItems');
    _uniforms pushBackUnique getText (_x >> 'uniformClass');
    _magazines append getArray (_x >> 'magazines');
    _weapons append getArray (_x >> 'weapons');
} forEach _cfgArr;

// Clean up duplicates
_items = _items arrayIntersect _items;
_weapons = _weapons arrayIntersect _weapons;

// Get all attachments and magazines for each weapon
private _attachments = [];
{
    _attachments append (_x call BIS_fnc_compatibleItems);
    _magazines append getArray (configfile >> "CfgWeapons" >> _x >> 'magazines');
} forEach _weapons;

// Clean up duplicates again
_attachments = _attachments arrayIntersect _attachments;
_magazines = _magazines arrayIntersect _magazines;

// Prune disallowed attachments
// by partial name match
{
    if ('broken' in _x or 'tws' in _x) then
    {
        _attachments deleteAt _forEachIndex;
    };
} forEach _attachments;
// by class name
private _attachmentsDisallowed = [
    'optic_NVS',
    'optic_Nightstalker',
    'optic_tws_mg'
];
{
    _attachments deleteAt (_attachments find _x);
} forEach _attachmentsDisallowed;

// Add specific equipment
// ACE medical
{
    _items pushBackUnique configName _x;
} forEach ("'medical' in getText (_x >> 'picture')" configClasses (configFile >> "CfgWeapons"));
// ACRE radios
{
    _items pushBackUnique configName _x;
} forEach ("getNumber (_x >> 'acre_hasUnique') == 1 and !('base' in toLower configName _x)" configClasses (configFile >> "CfgWeapons"));
// Glasses
{
    _items pushBackUnique configName _x;
} forEach ("!('base' in toLower configName _x) and !('None' in toLower configName _x)" configClasses (configfile >> "CfgGlasses"));
// Grenades
// {
//     _magazines pushBackUnique configName _x;
// } forEach ("getText (_x >> 'nameSound') isEqualTo 'handgrenade' and !('base' in toLower configName _x)" configClasses (configFile >> "CfgMagazines"));

private _cfgHash = createHashMapFromArray [
    ["attachments", _attachments],
    ["backpacks", _backpacks],
    ["items", _items],
    ["magazines", _magazines],
    ["uniforms", _uniforms],
    ["weapons", _weapons]
];

// Useful debugging code
// [thebox, true] call ACE_arsenal_fnc_removeVirtualItems;
// [thebox, []] call ace_arsenal_fnc_initBox;
// [thebox, _attachments] call ace_arsenal_fnc_addVirtualItems;
// [thebox, _backpacks] call ace_arsenal_fnc_addVirtualItems;
// [thebox, _items] call ace_arsenal_fnc_addVirtualItems;
// [thebox, _magazines] call ace_arsenal_fnc_addVirtualItems;
// [thebox, _uniforms] call ace_arsenal_fnc_addVirtualItems;
// [thebox, _weapons] call ace_arsenal_fnc_addVirtualItems;

_cfgHash
