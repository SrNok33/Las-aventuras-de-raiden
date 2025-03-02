extends Node  # Este script se ejecutará siempre

var billetes = 0  # ✅ Contador global de billetes

func agregar_billetes(cantidad):
	billetes += cantidad
	print("💰 Billetes actuales:", billetes)

func restar_billetes(cantidad):
	billetes -= cantidad
	if billetes < 0:
		billetes = 0
	print("💰 Billetes actuales:", billetes)
