import eispice
cct = eispice.Circuit("Capacitor Test")
cct.Vx = eispice.V(1, eispice.GND, 4,
  eispice.Pulse(4, 8, '10n', '2n', '3n', '5n', '20n'))
cct.Cx = eispice.C(1, eispice.GND, '10n')
cct.tran('0.5n', '100n')
print(cct.results)
