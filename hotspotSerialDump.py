import serial, sys, glob, time, os, traceback, datetime

### OPTIONS ###

HARDCODED_PORT = 0
HARD_PORT_STRING = 'COM8'
DEBUG_SERIAL_LIST = 1

### OPTIONS ###

### HELPER FUNCTIONS ###
def serial_ports():
    """ Lists serial port names

        :raises EnvironmentError:
            On unsupported or unknown platforms
        :returns:
            A list of the serial ports available on the system
    """
    if sys.platform.startswith('win'):
        ports = ['COM%s' % (i + 1) for i in range(256)]
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        # this excludes your current terminal "/dev/tty"
        ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):
        ports = glob.glob('/dev/tty.usb*')
    else:
        raise EnvironmentError('Unsupported platform')

    return ports

    # Checking the ports already sends a reset signal.
    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            pass
    return result

def stripped(string):
	return ''.join([i for i in string if 31 < ord(i) < 127])
### HELPER FUNCTIONS ###

### MAIN ###
try:
	ports = serial_ports()
	for p in ports:
		try:
			# Try opening port, send reset signal and establish connection
			if HARDCODED_PORT == 1:
				port = serial.Serial(HARD_PORT_STRING, 115200, timeout=1)
			else:
				port = serial.Serial(p, 115200, timeout=1)
			port.close()
			break
		except:
			# Keep querying until we find a port
			pass
	try:
		port.isOpen()
	except:
		raw_input('Unable to find a hotspot, press Enter to exit.')
		exit()

	# Wait until we receive handshake
	if HARDCODED_PORT == 1:
		print 'Hardcoded port opened, connecting to hotspot.'
	else:
		print 'Dynamic port opened, connecting to hotspot.'
	port.open()
	while stripped(port.readline()) != 'Propeller':
		time.sleep(1)
	print 'Connected to hotspot.'

	# Send handshake to ensure connection
	print 'Initializing stream.'
	port.write('H0st\n')
	time.sleep(1)
	print 'Opened stream.\n'

	while True:

		# Keep an open stream of data
		while 'txBegin' not in stripped(port.readline()):
			pass

		# Debug transmission
		#print port.read(port.inWaiting())
		#print port.inWaiting()

		timeout_buffer = port.readline()
		if stripped(timeout_buffer) == 'Timeout':
			print str(datetime.datetime.now()) + ': IR connection timed out, please try again.'
			continue

	    # Get records, should always find a record
		num_records = int(timeout_buffer)

		badge_ids = []
		badge_times = []
		badge_itypes = []

		for i in xrange(0, num_records):
			t = []
			t = (stripped(port.readline())).split(',')
			# Check for character replacement
			if (not(t[0].isalnum() and t[1].isalnum() and t[2].isalnum())):
				print str(datetime.datetime.now()) + ': Retrieved corrupted content, please try again.'
				continue
			badge_ids.append(t[0])
			badge_times.append(t[1])
			badge_itypes.append(t[2])

		badge_timeframe = int(stripped(port.readline()))

		# Check for data shifting
		if 'DUMP' not in badge_itypes[0]:
			print str(datetime.datetime.now()) + ': Retrieved corrupted content, please try again.'
			continue

		print str(datetime.datetime.now()) + ': Retrieved interactions, saving to file.'
		dt_now = datetime.datetime.now()

		if DEBUG_SERIAL_LIST == 1:
			print 'IDs: ' + str(badge_ids)
			print 'Times: ' + str(badge_times)
			print 'Types: ' + str(badge_itypes)

		# Dump to file
		f = open('hotspotdata.txt', 'a')
		for i in xrange(2, num_records):
			f.write(badge_ids[1] + ',' + badge_ids[i] + ',' + (dt_now - datetime.timedelta(seconds=badge_timeframe) + datetime.timedelta(seconds=int(badge_times[i]))).strftime('%H:%M:%S')  + '\n')
		f.close()

except Exception, err:
	print(traceback.format_exc())
	raw_input('Enter to continue.')
	port.close()

# checksum on content (pass number to serial and then checksum on the host)
