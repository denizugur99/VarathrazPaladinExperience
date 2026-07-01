# Varathraz - Tirions Legacy Paladin Voice Pack — Sound Reference

All sound files must be in `.ogg` format (except AFK music which uses `.mp3`) and play through the **Dialog** channel.

**System rules:**
- Global cooldown: 2 seconds between sounds (configurable via `/vpe cd`)
- `Force` sounds bypass the global cooldown and always cut whatever is currently playing
- `Force` sounds cut each other; a non-force sound never cuts a force sound (plays silently on top or is blocked by protect)
- `Protect` locks out non-force sounds for the specified duration; force sounds still break through protect
- Last-played file in each category receives 10% weight in the random roll to reduce repeats

---

## Probability Table

### Ambient Events

| Event | Category | Chance | Notes |
|-------|----------|--------|-------|
| Login / reload | LOGIN | 100% | Once per hour; force, 7–12s protect (per file) |
| Self-target | SELECT | 100% | |
| Enter combat | AGGRO | 33% | |
| Player death | DEATH | 100% | |
| Player revive | REDEMPTION | 100% | |
| Mount up | MOUNT | 100% | Suppressed on world entry |
| Go AFK | AFKSTART | 100% | Music, stopped on return |
| Return from AFK | AFKEND | 100% | |

### Spell Sounds

| Spell | Spell ID | Category | Chance | Force | Protect | Out of Combat | Notes |
|-------|----------|----------|--------|-------|---------|---------------|-------|
| Avenging Wrath | 31884 | WINGS | 100% | ✓ | 3s | ✓ | |
| Avenging Crusader | 216331 | WINGS | 100% | ✓ | 3s | ✓ | |
| Sentinel | 389539 | WINGS | 100% | ✓ | 3s | ✓ | |
| Wake of Ashes | 255937 | WINGS | 100% | ✓ | 3s | ✓ | Requires Radiant Glory (458359) |
| Lay on Hands | 633, 471195 | LAYONHANDS | 100% | ✓ | 3s | ✓ | |
| Divine Shield | 642 | BUBBLE | 100% | ✓ | 3s | ✓ | |
| Aura Mastery | 31821 | AURAMASTERY | 100% | ✓ | — | ✓ | |
| Guardian of Ancient Kings | 86659 | ANCIENTKINGS | 100% | ✓ | — | ✓ | |
| Ardent Defender | 31850 | ARDENTDEFENDER | 100% | ✓ | — | ✓ | |
| Intercession | 391054 | CR | 100% | ✓ | 1–4s (per file) | ✓ | Combat res |
| Redemption (on ally) | 7328 | REVIVE | 100% | | — | ✓ | onCastStart |
| Mass Resurrection | 212056 | ABSOLUTION | 100% | | — | ✓ | onCastStart |
| Beacon of Light | 53563 | BEACON | 100% | | — | ✓ | |
| Beacon of Faith | 156910 | BEACON | 100% | | — | ✓ | |
| Beacon of Virtue | 200025 | BEACON | 100% | | — | ✓ | |
| Blessing of Freedom | 1044 | FREEDOM | 100% | | — | ✓ | |
| Blessing of Protection | 1022 | BOP | 100% | | — | ✓ | |
| Blessing of Spellwarding | 204018 | SPELLWARDING | 100% | | — | ✓ | |
| Divine Steed | 190784 | DIVINESTEED | 100% | | — | ✓ | |
| Blinding Light | 115750 | BLINDINGLIGHT | 100% | | — | ✓ | |
| Divine Protection | 498, 403876 | DIVINEPROTECTION | 100% | | — | ✓ | |
| Blessing of Sacrifice | 6940 | SACRIFICE | 100% | | — | ✓ | |
| Cleanse | 4987 | CLEANSE | 100% | | — | ✓ | |
| Cleanse Toxins | 213644 | CLEANSE | 100% | | — | ✓ | |
| Hand of Reckoning | 62124 | TAUNT | 100% | | — | ✓ | |
| Hammer of Justice | 853 | STUN | 100% | | — | ✓ | |
| Rebuke | 96231 | INTERRUPT | 100% | | — | ✓ | |

---

## Sound Files

### sounds/login/
| File | Protect |
|------|---------|
| login_1.ogg | 12s |
| login_2.ogg | 7s |

### sounds/select/
| File |
|------|
| select_0.ogg |
| select_1.ogg |
| select_2.ogg |
| select_3.ogg |
| select_4.ogg |
| select_5.ogg |

### sounds/aggro/
| File |
|------|
| aggro_1.ogg |
| aggro_2.ogg |
| aggro_3.ogg |

### sounds/death/
| File |
|------|
| death_1.ogg |
| death_2.ogg |
| death_3.ogg |
| death_4.ogg |

### sounds/revive/
| File |
|------|
| revive_1.ogg |

### sounds/redemption/
| File |
|------|
| REDEMPTION.ogg |

### sounds/mount/
| File |
|------|
| mount_1.ogg |
| mount_2.ogg |
| mount_3.ogg |

### sounds/afkstart/
| File |
|------|
| afkmusic_1.mp3 |

### sounds/afkend/
| File |
|------|
| afkend_1.ogg |

### sounds/wings/
| File |
|------|
| wings_1.ogg |
| wings_2.ogg |
| wings_3.ogg |

### sounds/layonhands/
| File |
|------|
| layonhands_1.ogg |

### sounds/bubble/
| File |
|------|
| bubble_1.ogg |

### sounds/auramastery/
| File |
|------|
| auramastery_1.ogg |

### sounds/ancientkings/
| File |
|------|
| ancientkings.ogg |

### sounds/ardentdefender/
| File |
|------|
| ardentdefender_1.ogg |

### sounds/cr/
| File | Protect |
|------|---------|
| cr_1.ogg | 2s |
| cr_2.ogg | 4s |
| cr_3.ogg | 1s |

### sounds/absolution/
| File |
|------|
| absolution_1.ogg |

### sounds/beacon/
| File |
|------|
| beacon_1.ogg |

### sounds/freedom/
| File |
|------|
| freedom_1.ogg |

### sounds/bop/
| File |
|------|
| bop_1.ogg |

### sounds/spellwarding/
| File |
|------|
| spellwarding_1.ogg |

### sounds/divinesteed/
| File |
|------|
| divinesteed_1.ogg |

### sounds/blindinglight/
| File |
|------|
| blindinglight_1.ogg |

### sounds/divineprotection/
| File |
|------|
| divineprotection_1.ogg |

### sounds/sacrifice/
| File |
|------|
| sacrifice_1.ogg |

### sounds/cleanse/
| File |
|------|
| cleanse_1.ogg |

### sounds/taunt/
| File |
|------|
| taunt_1.ogg |

### sounds/stun/
| File |
|------|
| stun_1.ogg |

### sounds/interrupt/
| File |
|------|
| interrupt_1.ogg |
