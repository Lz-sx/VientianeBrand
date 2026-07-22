extends Node

signal attack_finished(attacker:CardBaseOnmap, defender:CardBaseOnmap)
signal unit_died(unit:CardBaseOnmap)
signal grid_changed()
signal hand_card_selected_changed()
signal state_changed(from_state: StateBase, to_state: StateBase)
