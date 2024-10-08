class_name Constants
extends Node

const PLAYER_BUSINESSES = 'businesses'
const PLAYER_FAMILY_1_RESPECT = 'family_1_respect'
const PLAYER_FAMILY_2_RESPECT = 'family_2_respect'
const PLAYER_HEAT = 'heat'
const PLAYER_JOB = 'job'
const PLAYER_LOANS = 'loans'
const PLAYER_MONEY = 'money'
const PLAYER_MONTHS_JAILED = 'months_jailed'
const PLAYER_RENTALS = 'rentals'
const PLAYER_SANITY = 'sanity'
const PLAYER_STREET_SMART = 'street_smart'
const PLAYER_TERRITORIES_RESPECT = 'territories_respect'

const STATS_LIMITS = {
	PLAYER_FAMILY_1_RESPECT: {'min': -1.0, 'max': 1.0},
	PLAYER_FAMILY_2_RESPECT: {'min': -1.0, 'max': 1.0},
	PLAYER_HEAT: {'min': 0.0, 'max': 1.0},
	PLAYER_SANITY: {'min': 0.0, 'max': 1.0},
	PLAYER_STREET_SMART: {'min': 0.0, 'max': 1.0},
	PLAYER_TERRITORIES_RESPECT: {'min': -1.0, 'max': 1.0},
}

const FAM_1 = 'fam_1'
const FAM_2 = 'fam_2'
const BANK = 'bank'

const EXTORTION_RATE_LIMITS = {
	FAM_1: {'min': 0.4, 'max': 0.61},
	FAM_2: {'min': 0.3, 'max': 0.51},
}

const LOAN_RATE_LIMITS = {
	FAM_1: {'min': 0.08, 'max': 0.121},
	FAM_2: {'min': 0.1, 'max': 0.151},
	BANK: {'min': 0.15, 'max': 0.21},
}

const EVENT_BANK_OFFERS_LOAN = 'event_bank_offers_loan'
const EVENT_EMPLOYEES_WANT_TO_UNIONIZE = 'event_employees_want_to_unionize'
const EVENT_FAMILY_1_OFFERS_LOAN = 'event_family_1_offers_loan'
const EVENT_FAMILY_2_OFFERS_LOAN = 'event_family_2_offers_loan'
const EVENT_FAMILY_1_OFFERS_WORK = 'event_family_1_offers_work'
const EVENT_FAMILY_2_OFFERS_WORK = 'event_family_2_offers_work'
const EVENT_FAMILY_1_WANTS_HELP_ROBBING_YOUR_JOB = 'event_family_1_wants_help_robbing_your_job'
const EVENT_FAMILY_2_WANTS_HELP_ROBBING_YOUR_JOB = 'event_family_2_wants_help_robbing_your_job'
const EVENT_FAMILY_1_WANTS_TO_EXTORT_BUSINESS = 'event_family_1_wants_to_extort_business'
const EVENT_FAMILY_2_WANTS_TO_EXTORT_BUSINESS = 'event_family_2_wants_to_extort_business'
const EVENT_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS = 'event_family_1_wants_to_launder_through_business'
const EVENT_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS = 'event_family_2_wants_to_launder_through_business'
const EVENT_FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME = 'event_family_1_wants_to_use_business_to_cover_crime'
const EVENT_FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME = 'event_family_2_wants_to_use_business_to_cover_crime'
const EVENT_FEDS_WANTS_INFO_ON_FAMILY_1 = 'event_feds_wants_info_on_family_1'
const EVENT_FEDS_WANTS_INFO_ON_FAMILY_2 = 'event_feds_wants_info_on_family_2'
const EVENT_FEDS_WANT_PROOF_OF_INCOME = 'event_feds_want_proof_of_income'
const EVENT_HANDLE_GETTING_ARRESTED = 'event_handle_getting_arrested'
const EVENT_NOTICE_HIT_ATTEMPT_BY_FAMILY_1 = 'event_notice_hit_attempt_by_family_1'
const EVENT_NOTICE_HIT_ATTEMPT_BY_FAMILY_2 = 'event_notice_hit_attempt_by_family_2'
const EVENT_ROBBED_BY_FAMILY_1 = 'event_robbed_by_family_1'
const EVENT_ROBBED_BY_FAMILY_2 = 'event_robbed_by_family_2'
const EVENT_ROBBED_BY_STREET_GANG = 'event_robbed_by_street_gang'
const EVENT_TAKE_THE_FALL_FOR_FAMILY_1 = 'event_take_the_fall_for_family_1'
const EVENT_TAKE_THE_FALL_FOR_FAMILY_2 = 'event_take_the_fall_for_family_2'

const TRIGGER_APPROACHED_BY_BANK_FOR_LOAN = 'trigger_approached_by_bank_for_loan'
const TRIGGER_APPROACHED_BY_FAMILY_1_FOR_LOAN = 'trigger_approached_by_family_1_for_loan'
const TRIGGER_APPROACHED_BY_FAMILY_2_FOR_LOAN = 'trigger_approached_by_family_2_for_loan'
const TRIGGER_APPROACHED_BY_FAMILY_1_TO_ROB_FROM_JOB = 'trigger_approached_by_family_1_to_rob_from_job'
const TRIGGER_APPROACHED_BY_FAMILY_2_TO_ROB_FROM_JOB = 'trigger_approached_by_family_2_to_rob_from_job'
const TRIGGER_APPROACHED_BY_FAMILY_1_TO_WORK = 'trigger_approached_by_family_1_to_work'
const TRIGGER_APPROACHED_BY_FAMILY_2_TO_WORK = 'trigger_approached_by_family_2_to_work'
const TRIGGER_ARRESTED = 'trigger_arrested'
const TRIGGER_BRIBE_JURY = 'trigger_bribe_jury'
const TRIGGER_DECLINED_LOAN_FROM_FAMILY_1 = 'trigger_declined_loan_from_family_1'
const TRIGGER_DECLINED_LOAN_FROM_FAMILY_2 = 'trigger_declined_loan_from_family_2'
const TRIGGER_DENY_EMPLOYEES_UNION = 'trigger_deny_employees_union'
const TRIGGER_EMPLOYEES_WANT_TO_UNIONIZE = 'trigger_employees_want_to_unionize'
const TRIGGER_FAMILY_1_OFFERS_WORK = 'trigger_family_1_offers_work'
const TRIGGER_FAMILY_2_OFFERS_WORK = 'trigger_family_2_offers_work'
const TRIGGER_FAMILY_1_WANTS_TO_EXTORT_BUSINESS = 'trigger_family_1_wants_to_extort_business'
const TRIGGER_FAMILY_2_WANTS_TO_EXTORT_BUSINESS = 'trigger_family_2_wants_to_extort_business'
const TRIGGER_FAMILY_1_WANTS_TO_LAUNDER_THROUGH_BUSINESS = 'trigger_family_1_wants_to_launder_through_business'
const TRIGGER_FAMILY_2_WANTS_TO_LAUNDER_THROUGH_BUSINESS = 'trigger_family_2_wants_to_launder_through_business'
const TRIGGER_FAMILY_1_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME = 'trigger_family_1_wants_to_use_business_to_cover_crime'
const TRIGGER_FAMILY_2_WANTS_TO_USE_BUSINESS_TO_COVER_CRIME = 'trigger_family_2_wants_to_use_business_to_cover_crime'
const TRIGGER_FAMILY_1_SABOTAGE_BUSINESS = 'trigger_family_1_sabotage_business'
const TRIGGER_FAMILY_2_SABOTAGE_BUSINESS = 'trigger_family_2_sabotage_business'
const TRIGGER_FAMILY_1_SUSPECTS_RAT = 'trigger_family_1_suspects_rat'
const TRIGGER_FAMILY_2_SUSPECTS_RAT = 'trigger_family_2_suspects_rat'
const TRIGGER_FIGHT_OFF_FAMILY_1_HIT = 'trigger_fight_off_family_1_hit'
const TRIGGER_FIGHT_OFF_FAMILY_2_HIT = 'trigger_fight_off_family_2_hit'
const TRIGGER_HIT_ATTEMPT_BY_FAMILY_1 = 'trigger_hit_attempt_by_family_1'
const TRIGGER_HIT_ATTEMPT_BY_FAMILY_2 = 'trigger_hit_attempt_by_family_2'
const TRIGGER_IRS_INVESTIGATES_PROOF_OF_INCOME = 'trigger_irs_investigates_proof_of_income'
const TRIGGER_IRS_WANTS_PROOF_OF_INCOME = 'trigger_irs_wants_proof_of_income'
const TRIGGER_POLICE_WANTS_INFO_ON_FAMILY_1 = 'trigger_police_wants_info_on_family_1'
const TRIGGER_POLICE_WANTS_INFO_ON_FAMILY_2 = 'trigger_police_wants_info_on_family_2'
const TRIGGER_ROBBED_BY_FAMILY_1 = 'trigger_robbed_by_family_1'
const TRIGGER_ROBBED_BY_FAMILY_2 = 'trigger_robbed_by_family_2'
const TRIGGER_ROBBED_BY_STREET_GANG = 'trigger_robbed_by_street_gang'
const TRIGGER_ROB_FROM_JOB = 'trigger_rob_from_job'
const TRIGGER_RUN_FROM_FAMILY_1_ROBBERY = 'trigger_run_from_family_1_robbery'
const TRIGGER_RUN_FROM_FAMILY_2_ROBBERY = 'trigger_run_from_family_2_robbery'
const TRIGGER_RUN_FROM_HIT_BY_FAMILY_1 = 'trigger_run_from_hit_by_family_1'
const TRIGGER_RUN_FROM_HIT_BY_FAMILY_2 = 'trigger_run_from_hit_by_family_2'
const TRIGGER_RUN_FROM_STREET_GANG_ROBBERY = 'trigger_run_from_street_gang_robbery'
const TRIGGER_SERVE_JAIL_TIME = 'trigger_serve_jail_time'
const TRIGGER_TAKE_THE_FALL_FOR_FAMILY_1 = 'trigger_take_the_fall_for_family_1'
const TRIGGER_TAKE_THE_FALL_FOR_FAMILY_2 = 'trigger_take_the_fall_for_family_2'
const TRIGGER_THREATEN_JURY = 'trigger_threaten_jury'
