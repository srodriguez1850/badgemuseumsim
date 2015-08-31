import os

while True:
	os.system('cls' if os.name == 'nt' else 'clear')
	raw_input('Please connect a hotspot and press Enter to connect.')
	execfile('hotspotSerialDump.py')