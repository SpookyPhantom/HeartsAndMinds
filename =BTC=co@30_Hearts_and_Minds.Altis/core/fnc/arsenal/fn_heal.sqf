if (isClass (configfile >> "CfgPatches" >> "ace_medical")) then {

player call ace_medical_treatment_fnc_fullHealLocal;

} else {

player setDamage 0;

};
