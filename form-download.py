#!/usr/bin/python

import sys
import mechanize
import simplejson as json
from optparse import OptionParser

parser = OptionParser()
parser.set_usage("usage: %prog [options]...")
parser.add_option('-t', '--theme', type='string', action='store', dest='theme', default='ui-lightness', help='Select what theme to use')
parser.add_option('-f', '--file', type='string', action='store', dest='file', default='jquery.ui.zip', help='Select what filename to save the download to')
parser.parse_args()

response = mechanize.urlopen('http://download.jqueryui.com/download/theme?callback=')
theme = response.read().strip()
theme = theme[1:-2]
j = json.loads(theme)

br = mechanize.Browser()
br.open("http://jqueryui.com/download/")
assert br.viewing_html()
response = br.response()
data = response.get_data()
pos = data.find('action="http://download.jqueryui.com/download"')
print pos
if pos == -1:
	sys.stderr.write('Bad form.')
	sys.exit(-1)
before = data[:pos]
after = data[pos:]
pos = after.find('>')
if pos == -1:
	sys.stderr.write('Bad form.')
	sys.exit(-1)
before += after[:pos]
after = after[pos:]
response.set_data(before + j + after)
br.set_response(response)

found = False
for f in br.forms():
	if f.action == 'http://download.jqueryui.com/download':
		found = True
		br.form = f
		break
if not found:
	sys.stderr.write("Bad form.")
	sys.exit(-1)
items = br.form.controls[0].possible_items()
#FIXME hardcode for now. This is dumb.
br.form['theme'] = [items[1]]
br.form['theme-folder-name'] = parser.values.theme
response2 = br.submit()
file = open(parser.values.file, 'w')
file.write(response2.read())
file.close()
