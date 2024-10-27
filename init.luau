--!strict

local partitions = require("./partitions")

local Gadget_SRAW = {}
Gadget_SRAW.__index = Gadget_SRAW
local SRAW = Gadget_SRAW

function SRAW:on_load(
	sraw: SoldierWeaponBlueprint,
    guided: ProjectileBlueprint,
    laser: ProjectileBlueprint
)

    -- FGM172_Predator_SRAW
    local sraw_object = sraw.object :: SoldierWeaponData
    local sraw_shot = sraw_object.weaponFiring.primaryFire.shot :: ShotConfigData
    local sraw_ammo = sraw_object.weaponFiring.primaryFire.ammo :: AmmoConfigData
    local sraw_locking = sraw_object.customWeaponType :: LockingWeaponData
    local sraw_zoom = sraw_object.zoomLevels[2] :: WeaponZoomLevelData
	
    sraw_shot.initialSpeed.z = 15.0
    sraw_ammo.ammoBagPickupDelayMultiplier = 8.0
    sraw_object.allowSwitchingToWeaponInVehicles = true

    sraw_locking.lockingController.lockTime = 1.5

    sraw_locking.secondaryLockingController.checkVisibilityLength = 1000
    sraw_locking.secondaryLockingController.rayLength = 1000

    sraw_zoom.renderFov = 24.0

    -- SRAW_Projectile_Guided
    local guided_object = guided.object :: MissileEntityData
    local guided_explosion = guided_object.dudExplosion :: VeniceExplosionEntityData

    guided_object.timeToLive = 12.0
    guided_object.engineStrength = 25.0
    guided_object.engineTimeToLive = 12.0
    guided_object.maxTurnAngle = 360.0
    guided_object.minTurnAngle = 25.0
    guided_object.turnAngleMultiplier = 2.0
    guided_object.damage = 215.0

    guided_explosion.innerBlastRadius = 0.35
    guided_explosion.blastDamage = 112.0

    -- SRAW_Projectile_Laser
    local laser_object = laser.object :: MissileEntityData
    local laser_explosion = laser_object.dudExplosion :: VeniceExplosionEntityData

    laser_object.engineTimeToIgnition = 0.5
    laser_object.timeToActivateGuidingSystem = 1.75
    laser_object.maxTurnAngle = 3600.0
    laser_object.impactImpulse = 7000.0
    laser_object.damage = 225.0
    laser_object.unguidedData.targetPositionOffset.x = 25.0

    laser_explosion.maxOcclusionRaycastRadius = 0.25
    laser_explosion.innerBlastRadius = 0.35
    laser_explosion.blastDamage = 112.0
    laser_explosion.blastRadius = 4.0
    laser_explosion.blastImpulse = 2000.0
end

partitions.onAllInstancesLoaded(SRAW, SRAW.on_load, {
	partition = Guid("5447EA56-802F-4C23-8DA8-F4072073E0B9"),
	instance = Guid("7623EB41-2B65-42C4-830C-B2512CA52DC1") -- FGM172_Predator_SRAW
},
{
    partition = Guid("85430CC9-3441-496E-9443-96B4283F0EFA"),
	instance = Guid("9B809681-B710-405D-BD48-E339A20FD5AE") -- SRAW_Projectile_Guided
},
{
    partition = Guid("DFB65405-D6A9-424D-AC0D-4E97724C1A7D"),
	instance = Guid("F2393279-E742-43F8-8420-B27CA2269A7B") -- SRAW_Projectile_Laser
})

print("SRAW MOD LOADED")