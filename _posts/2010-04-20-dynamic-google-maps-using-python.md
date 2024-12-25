---
id: 3851
title: 'Dynamic Google maps using Python'
date: '2010-04-20T21:44:00+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=3851'
permalink: /2010/04/20/dynamic-google-maps-using-python/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2012/04/cabbage-trees.jpg
tags:
    - programming
    - writing
---

I originally wrote this code on 2 February 2009, as a quick hack to publish air pollution in Santiago. The air quality stations now present data in a different way, so the mapping doesn’t work, but the general idea is still useful. A barebones version of my Python code to generate the KML file is:

```python
#!/usr/bin/env python
# encoding: utf-8

import urllib, random

# Charting function
def lineChart(data, size = '250x100'):
    baseURL = 'http://chart.apis.google.com/chart?cht=lc&chs='
    baseData = '&chd=t:'
    newData = ','.join(data)
    baseData = baseData + newData
    URL = baseURL + size + baseData    
    return URL

# Reading test data: connecting to server and extracting lines
f = urllib.urlopen('http://gis.someserver.com/TestData.csv')
stations = f.readlines()
kmlBody = ('')

for s in stations:
    data = s.split(',')
    # Generate random data
    a = []
    for r in range(60):
        a.append(str(round(random.gauss(50,10), 1)))

    chart = lineChart(a)

    # data is csv as station name (0), long (1), lat (2), y (3)
    kml = (
        '<Placemark>\n'
        '<name>%s</name>\n'
        '<description>\n'
        '<![CDATA[\n'
        '<p>Value: %s</p>\n'
        '<p><img src="%s" width="250" height="100" /></p>\n'
        ']]>\n'
        '</description>\n'
        '<Point>\n'
        '<coordinates>%f,%f</coordinates>\n'
        '</Point>\n'
        '</Placemark>\n'
        ) %(data[0], data[3], chart, float(data[1]), float(data[2]))

    kmlBody = kmlBody + kml

# Bits and pieces of the KML file
contentType = ('Content-Type: application/vnd.google-earth.kml+xml\n')

kmlHeader = ('<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n'
             '<kml xmlns=\"http://earth.google.com/kml/2.1\">\n'
             '<Document>\n')

kmlFooter = ('</Document>\n'
             '</kml>\n')


print contentType
print kmlHeader
print kmlBody
print kmlFooter
```

Well, this was not exactly barebones, because we also wanted to generate dynamic graphs for each placemark, in the easiest possible way. My first idea was to use one of the multiple javascript libraries available in the net However, a quick search revealed that KML files do not support javascript in the `description` tag. That was the time when I remembered playing with [Google Charts](http://code.google.com/apis/charttools/) a long time ago. The `lineChart` function above is simply a call to create a line chart using the charts API. Because this is a test, I used 60 randomly generated data points, which explains the presence of `random` as an imported library. The actual code is even larger, because I was (and am) also doing data scrapping from the Chilean meteorological service web pages.

Originally, I did not want to use javascript at all, so inserted the code as a search in maps, generating a link like <http://maps.google.com/maps?q=http://some-server.com/AirePuro.py> However, I wanted to embed it in a blog post and I was struggling to do it. The solution was to click on the ‘Link’ link in the generated map to copy the ‘Paste HTML to embed in website’ link. This gave an `iframe` block that can be copied in any page or blog post, like so:

While helping a friend to create another map, we faced the problem that the data set was being updated every five minutes. What is the problem? The map was not being refreshed often enough. I am not sure if the problem was a browser cache or Google Maps, but it could be solved by calling the KML file with a random extra argument (the script does not need take any arguments, so anything after the question mark is ignored). In my case I needed a frequent random argument, so I use the current time (using the date would work for once a day updates). This meant inserting the map using javascript (and using a Google Maps key). The code for a simple page–from the header onwards–would look like:

```html
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<title>A simple dynamic python generated map</title>
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=my_key"
type="text/javascript"></script>
<script type="text/javascript">
    //<![CDATA[ 
    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
        map.setCenter(new GLatLng(-33.458943, -70.658569), 11);
        var pollution = new GGeoXml("http://gis.uncronopio.org/testmapscsv.py?"+
                        (new Date()).getTime());
        map.addOverlay(pollution);
      }
    }
    //]]>
 </script>
 </head>
<body onload="load()" onunload="GUnload()">
<div id="map" style="width:750px;height:600px"></div>
</body>
```

It was not too bad for mucking around on a Friday in between doing house chores.