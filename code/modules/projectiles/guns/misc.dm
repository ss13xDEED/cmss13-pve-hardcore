//-------------------------------------------------------
//This gun is very powerful, but also has a kick.

/obj/item/weapon/gun/minigun
	name = "\improper Ol' Painless"
	desc = "An enormous multi-barreled rotating gatling gun. This thing will no doubt pack a punch."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/event.dmi'
	icon_state = "painless"
	item_state = "painless"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_minigun.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/minigun
	w_class = SIZE_HUGE
	force = 20
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	gun_category = GUN_CATEGORY_HEAVY
	start_semiauto = FALSE
	start_automatic = TRUE

/obj/item/weapon/gun/minigun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/minigun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9 // Most of the scatter should come from the recoil

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_buildup_limit = RECOIL_AMOUNT_TIER_3 / RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER

/obj/item/weapon/gun/minigun/handle_starting_attachment()
	..()
	//invisible mag harness
	var/obj/item/attachable/magnetic_harness/Integrated = new(src)
	Integrated.hidden = TRUE
	Integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	Integrated.Attach(src)
	update_attachable(Integrated.slot)

//Minigun UPP
/obj/item/weapon/gun/minigun/upp
	name = "\improper GSh-7.62 rotary machine gun"
	desc = "A gas-operated rotary machine gun used by UPP heavies. Its enormous volume of fire and ammunition capacity allows the suppression of large concentrations of enemy forces. Heavy weapons training is required control its recoil."
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_CAN_POINTBLANK|GUN_AUTO_EJECT_CASINGS
	current_mag = /obj/item/ammo_magazine/minigun/upp

/obj/item/weapon/gun/minigun/upp/able_to_fire(mob/living/user)
	. = ..()
	if(!. || !istype(user)) //Let's check all that other stuff first.
		return 0
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0
	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_UPP)
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0


//M60
/obj/item/weapon/gun/m60
	name = "\improper H-G Mk70 Machine Gun"
	desc = "Part of the Henjin-Garcia repro line, the Mk70 found surprising niche in Frontier colony home defense against aggressive, largescale xenofauna. \n<b>Alt-click to open the feed tray cover for handling reloads.</b>"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/colony.dmi'
	icon_state = "m60"
	item_state = "m60"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_m60.ogg'
	cocked_sound = 'sound/weapons/gun_m60_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/m60
	w_class = SIZE_LARGE
	force = 25
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
	)
	starting_attachment_types = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
		/obj/item/attachable/stock/m60,
	)
	start_semiauto = FALSE
	start_automatic = TRUE

	var/cover_open = FALSE //if the gun's feed-cover is open or not.


/obj/item/weapon/gun/m60/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/m60/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 37, "muzzle_y" = 16, "rail_x" = 0, "rail_y" = 0, "under_x" = 27, "under_y" = 12, "stock_x" = 10, "stock_y" = 14)

/obj/item/weapon/gun/m60/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)
	set_burst_amount(BURST_AMOUNT_TIER_5)
	set_burst_delay(FIRE_DELAY_TIER_12)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	empty_sound = 'sound/weapons/gun_empty.ogg'

/obj/item/weapon/gun/m60/clicked(mob/user, list/mods)
	if(!mods["alt"] || !CAN_PICKUP(user, src))
		return ..()
	else
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You can't do that with your hands full!"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You open [src]'s feed cover, allowing the belt to be removed."))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You close [src]'s feed cover."))
			cover_open = FALSE
		update_icon()
		return TRUE

/obj/item/weapon/gun/m60/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't put a new belt in! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/m60/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't take out the belt! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/m60/update_icon()
	. = ..()
	if(cover_open)
		overlays += image("+[base_gun_icon]_cover_open", pixel_x = -2, pixel_y = 8)
	else
		overlays += image("+[base_gun_icon]_cover_closed", pixel_x = -10, pixel_y = 0)

/obj/item/weapon/gun/m60/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(cover_open)
			to_chat(user, SPAN_WARNING("You can't fire [src] with the feed cover open! <b>(alt-click to close)</b>"))
			return FALSE


/obj/item/weapon/gun/pkp
	name = "\improper QYJ-72 General Purpose Machine Gun"
	desc = "The QYJ-72 is the standard GPMG of the Union of Progressive Peoples, chambered in 10x27mm, it fires a hard-hitting round with a high rate of fire. With an extremely large box at 250 rounds, the QJY-72 is designed with suppressing fire and accuracy by volume of fire at its forefront. \n<b>Alt-click it to open the feed cover and allow for reloading.</b>"
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/upp.dmi'
	icon_state = "qjy72"
	item_state = "qjy72"

	fire_sound = 'sound/weapons/gun_mg.ogg'
	cocked_sound = 'sound/weapons/gun_m60_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/pkp
	w_class = SIZE_LARGE
	force = 30 //the image of a upp machinegunner beating someone to death with a gpmg makes me laugh
	start_semiauto = FALSE
	start_automatic = TRUE
	flags_gun_features = GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_AMMO_COUNTER|GUN_AUTO_EJECT_CASINGS
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(
		/obj/item/attachable/pkpbarrel,
		/obj/item/attachable/stock/pkpstock,
	)
	var/cover_open = FALSE //if the gun's feed-cover is open or not.


/obj/item/weapon/gun/pkp/handle_starting_attachment()
	..()
	var/obj/item/attachable/attachie = new /obj/item/attachable/pkpbarrel(src)
	attachie.flags_attach_features &= ~ATTACH_REMOVABLE
	attachie.Attach(src)
	update_attachable(attachie.slot)

	var/obj/item/attachable/pkpstock = new /obj/item/attachable/stock/pkpstock(src)
	pkpstock.flags_attach_features &= ~ATTACH_REMOVABLE
	pkpstock.Attach(src)
	update_attachable(pkpstock.slot)

	//invisible mag harness
	var/obj/item/attachable/magnetic_harness/Integrated = new(src)
	Integrated.hidden = TRUE
	Integrated.flags_attach_features &= ~ATTACH_REMOVABLE
	Integrated.Attach(src)
	update_attachable(Integrated.slot)

/obj/item/weapon/gun/pkp/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/pkp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 18,"rail_x" = 5, "rail_y" = 5, "under_x" = 39, "under_y" = 7, "stock_x" = 10, "stock_y" = 13)


/obj/item/weapon/gun/pkp/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_LMG
	burst_amount = BURST_AMOUNT_TIER_4
	burst_delay = FIRE_DELAY_TIER_LMG
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_4
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	fa_max_scatter = SCATTER_AMOUNT_TIER_6
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	empty_sound = 'sound/weapons/gun_empty.ogg'

/obj/item/weapon/gun/pkp/clicked(mob/user, list/mods)
	if(!mods["alt"] || !CAN_PICKUP(user, src))
		return ..()
	else
		if(!locate(src) in list(user.get_active_hand(), user.get_inactive_hand()))
			return TRUE
		if(user.get_active_hand() && user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You can't do that with your hands full!"))
			return TRUE
		if(!cover_open)
			playsound(src.loc, 'sound/handling/smartgun_open.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You open [src]'s feed cover, allowing the belt to be removed."))
			cover_open = TRUE
		else
			playsound(src.loc, 'sound/handling/smartgun_close.ogg', 50, TRUE, 3)
			to_chat(user, SPAN_NOTICE("You close [src]'s feed cover."))
			cover_open = FALSE
		update_icon()
		return TRUE

/obj/item/weapon/gun/pkp/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't put a new belt in! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/pkp/unload(mob/user, reload_override, drop_override, loc_override)
	if(!cover_open)
		to_chat(user, SPAN_WARNING("[src]'s feed cover is closed! You can't take out the belt! <b>(alt-click to open it)</b>"))
		return
	return ..()

/obj/item/weapon/gun/pkp/update_icon()
	. = ..()
	if(cover_open)
		overlays += "+[base_gun_icon]_cover_open"
	else
		overlays += "+[base_gun_icon]_cover_closed"

/obj/item/weapon/gun/pkp/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(cover_open)
			to_chat(user, SPAN_WARNING("You can't fire [src] with the feed cover open! <b>(alt-click to close)</b>"))
			return FALSE
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_TRAINED))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return FALSE

/obj/item/weapon/gun/pkp/iff
	name = "\improper QYJ-72-I General Purpose Machine Gun"
	desc = "The QYJ-72-I is an experimental variant of common UPP GPMG featuring IFF capabilities which were developed by reverse-engineering USCM smartweapons. Aside from that, not much has been done to this machinegun: it's still heavy, overheats rather quickly and is able to lay down range unprecedented amounts of lead. \n<b>Alt-click it to open the feed cover and allow for reloading.</b>"
	actions_types = list(/datum/action/item_action/toggle_iff_pkp)
	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	var/iff_enabled = TRUE
	var/requires_harness = TRUE

/obj/item/weapon/gun/pkp/iff/able_to_fire(mob/living/user)
	. = ..()
	if(.)
		if(!ishuman(user))
			return FALSE
		var/mob/living/carbon/human/H = user
		if(requires_harness)
			if(!H.wear_suit || !(H.wear_suit.flags_inventory & SMARTGUN_HARNESS))
				balloon_alert(user, "harness required")
				return FALSE

/obj/item/weapon/gun/pkp/iff/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff) //it has no PVE IFF mechanics because its innacurate as hell and is used for suppression and not as assault weapon.
	))
	AddComponent(/datum/component/iff_fire_prevention)

/datum/action/item_action/toggle_iff_pkp/New(Target, obj/item/holder)
	. = ..()
	name = "Toggle IFF"
	action_icon_state = "iff_toggle_on"
	button.name = name
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/toggle_iff_pkp/action_activate()
	. = ..()
	var/obj/item/weapon/gun/pkp/iff/G = holder_item
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(H.is_mob_incapacitated() || G.get_active_firearm(H, FALSE) != holder_item)
		return

/datum/action/item_action/toggle_iff_pkp/action_activate()
	. = ..()
	var/obj/item/weapon/gun/pkp/iff/G = holder_item
	G.toggle_lethal_mode(usr)
	if(G.iff_enabled)
		action_icon_state = "iff_toggle_on"
	else
		action_icon_state = "iff_toggle_off"
	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/obj/item/weapon/gun/pkp/iff/proc/toggle_lethal_mode(mob/user)
	to_chat(user, "[icon2html(src, usr)] You [iff_enabled? "<B>disable</b>" : "<B>enable</b>"] \the [src]'s fire restriction. You will [iff_enabled ? "harm anyone in your way" : "target through IFF"].")
	playsound(loc,'sound/machines/click.ogg', 25, 1)
	iff_enabled = !iff_enabled
	if(iff_enabled)
		add_bullet_trait(BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff))
	if(!iff_enabled)
		remove_bullet_trait("iff")
	SEND_SIGNAL(src, COMSIG_GUN_IFF_TOGGLED, iff_enabled)

/obj/effect/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	anchored = TRUE
	density = FALSE

/obj/effect/syringe_gun_dummy/Initialize()
	create_reagents(15)
	. = ..()

//-------------------------------------------------------
//P9 Sonic Harpoon Artillery Remote Projectile(SHARP) Rifle

/obj/item/weapon/gun/rifle/sharp
	name = "\improper P9 SHARP rifle"
	desc = "An experimental harpoon launcher rifle manufactured by Armat Systems. It's specialized for specific ammo types out of a 10-round magazine, best used for area denial and disruption.\n<b>Change firemode</b> in order to set fuse for delayed explosion darts. <b>Unique action</b> in order to track targets hit by tracker darts."
	icon_state = "sharprifle"
	item_state = "sharp"
	fire_sound = 'sound/weapons/gun_sharp.ogg'
	reload_sound = 'sound/weapons/handling/gun_vulture_bolt_close.ogg'
	unload_sound = 'sound/weapons/handling/gun_vulture_bolt_eject.ogg'
	unacidable = TRUE
	indestructible = TRUE
	muzzle_flash = null

	current_mag = /obj/item/ammo_magazine/rifle/sharp/explosive
	attachable_allowed = list(/obj/item/attachable/magnetic_harness, /obj/item/attachable/bayonet, /obj/item/attachable/flashlight)

	aim_slowdown = SLOWDOWN_ADS_SPECIALIST
	wield_delay = WIELD_DELAY_NORMAL
	flags_gun_features = GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER

	flags_item = TWOHANDED|NO_CRYO_STORE
	start_semiauto = TRUE
	start_automatic = FALSE


	var/explosion_delay_sharp = FALSE
	var/list/sharp_tracked_mob_list = list()

/obj/item/weapon/gun/rifle/sharp/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 17,"rail_x" = 12, "rail_y" = 24, "under_x" = 23, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/rifle/sharp/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_1
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_NONE
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_OFF

/obj/item/weapon/gun/rifle/sharp/unique_action(mob/user)
	track(user)

/obj/item/weapon/gun/rifle/sharp/proc/track(mob/user)
	var/mob/living/carbon/human/M = user

	var/max_count = 5 //max number of tracking
	var/target
	var/direction = -1
	var/atom/areaLoc = null
	var/output = FALSE

	var/x = sharp_tracked_mob_list.len - max_count
	for(var/i=0,i<x,++i)
		popleft(sharp_tracked_mob_list)

	for(var/mob/living/mob_tracked as mob in sharp_tracked_mob_list)
		if(!QDELETED(mob_tracked))
			if(M.z == mob_tracked.z)
				var/dist = get_dist(M,mob_tracked)
				target = dist
				direction = get_dir(M,mob_tracked)
				areaLoc = loc

			if(target < 900)
				output = TRUE
				var/areaName = get_area_name(areaLoc)
				to_chat(M, SPAN_NOTICE("\The [mob_tracked] is [target > 10 ? "approximately <b>[round(target, 10)]</b>" : "<b>[target]</b>"] paces <b>[dir2text(direction)]</b> in <b>[areaName]</b>."))
	if(!output)
		to_chat(M, SPAN_NOTICE("There is nothing currently tracked."))

	return

/obj/item/weapon/gun/rifle/sharp/cock()
	return

/obj/item/weapon/gun/rifle/sharp/do_toggle_firemode(datum/source, datum/keybinding, new_firemode)
	explosion_delay_sharp = !explosion_delay_sharp
	playsound(source, 'sound/weapons/handling/gun_burst_toggle.ogg', 15, 1)
	to_chat(source, SPAN_NOTICE("You [explosion_delay_sharp ? SPAN_BOLD("enable") : SPAN_BOLD("disable")] [src]'s delayed fire mode. Explosive ammo will blow up in [explosion_delay_sharp ? SPAN_BOLD("five seconds") : SPAN_BOLD("one second")]."))
