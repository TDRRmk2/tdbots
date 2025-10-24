#ifndef __INC_TDBOTS_H__
#define __INC_TDBOTS_H__

#pragma ACS library "TDBots"

typedef struct TDB_WeaponInfo
{
	__str wpnName;
	__str wpnTick; // Should return buttons to press, args: (int distToTarget)
	int wpnId;

	// These properties are still relevant regardless of tick script, so
	// they're also copied
	__str ammo1, ammo2;
	int ammoUse1, ammoUse2;
	int flags;
	int priority;

	// These properties only get copied with the default tick function
	_Accum minDist, maxDist;
	_Accum projSpeed;

	_Accum minDistAlt, maxDistAlt;
	_Accum projSpeedAlt;

	_Accum altFireChance;
} TDB_WeaponInfoT;

enum
{
	TDB_CW_MELEE = 1 << 0,
	TDB_CW_EXPLOSIVE = 1 << 1,
	TDB_CW_PROJECTILE = 1 << 2
};

enum
{
	TDB_FLAGS_WAIT = 1,
	TDB_FLAGS_PREC = 1 << 1,
	TDB_FLAGS_NOJUMPNODE = 1 << 2,
	TDB_FLAGS_NOMOVE = 1 << 3
};

enum {NO_WPN_ID = -1};

[[call("StkCall"), extern("ACS"), optional_args(1)]] void TDB_Weapon_New(__str wpn, int priority, int flags, __str callback, int wpnId);
[[call("StkCall"), extern("ACS"), optional_args(5)]] void TDB_Weapon_Pri(__str wpn, __str ammo, int ammoUse, _Accum projSpeed, _Accum minDist, _Accum maxDist, int flags);
[[call("StkCall"), extern("ACS"), optional_args(6)]] void TDB_Weapon_Alt(__str wpn, __str ammo, int ammoUse, _Accum projSpeed, _Accum minDist, _Accum maxDist, int flags, _Accum altFireChance);
[[call("StkCall"), extern("ACS")]] void TDB_TargetCallbacks_Append(__str val);

[[call("StkCall"), extern("ACS")]] void TDB_Set_Flags(int pnum, int flags);
[[call("StkCall"), extern("ACS")]] void TDB_Clear_Flags(int pnum, int flags);
[[call("StkCall"), extern("ACS")]] int TDB_Get_Flags(int pnum);

#endif
