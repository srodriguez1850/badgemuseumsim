import urllib2
import json
import datetime
import time

theserver = 'http://127.0.0.1:8000/'

#alternatives - get time from self
#dt_now = datetime.datetime.now()

#get time from server
j = urllib2.urlopen(theserver+'time/')
j_obj = json.load(j)
timestring = j_obj['time']
dt_now = datetime.datetime.strptime(timestring, "%Y-%m-%d %H:%M:%S.%f")
#print(dt_now)  


#stuff that we get from the badge
badge_ids = ["corey","corey","friend1","friend2","friend3"]
badge_times = ["10","13","15","19","35"]
badge_itypes = ["DUMP", "RESP", "INIT", "RESP", "INIT"]
num_records = 5;
badge_timeframe = 52;  
#end stuff we get from the badge





data = {}
data['interactions'] = [];
for i in xrange(2, num_records):
	data['interactions'].append(badge_ids[1] + ',' + badge_ids[i] + ',' + (dt_now - datetime.timedelta(seconds=badge_timeframe) + datetime.timedelta(seconds=int(badge_times[i]))).strftime('%H:%M:%S'))
#print(data);
req = urllib2.Request(theserver+'addmany/')
req.add_header('Content-Type', 'application/json')
response = urllib2.urlopen(req, json.dumps(data))