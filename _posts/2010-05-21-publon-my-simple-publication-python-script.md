---
id: 3846
title: 'Publon: my simple publication Python script'
date: '2010-05-21T21:20:00+12:00'
author: Luis
layout: post
guid: 'https://luis.apiolaza.net/?p=3846'
permalink: /2010/05/21/publon-my-simple-publication-python-script/
classic-editor-remember:
    - block-editor
image: /wp-content/uploads/2010/01/IMG_20200416_085853.jpg
tags:
    - meta
    - programming
    - recycling
---

After using PmWiki (PHP wiki software) for nearly five years to maintain my web site I was a bit tired of fiddling with it. I then rolled out the following very simple and crummy Python script. Besides a basic Python distribution it only requires [Python Markdown](https://pypi.org/project/Markdown/) and [Pygments](http://pygments.org/).

There are no external templates or any other niceties–although it deals with unicode–but it just works.

```python
#!/usr/bin/python
# coding: utf-8

import codecs, getopt, markdown, os, os.path, sys 

# Some important constants
base_path = '/Users/luis/Dropbox/website/'
site_path = 'http://apiolaza.net/'


# Basic inside-code template, making
# script self-contained
def inline_template():
    template = u'''
    
    <html>
    <head>
        <title><!--title--></title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name='author' content='Luis A. Apiolaza' />
        <meta name='keywords' content='<!--tags-->' />
        <link rel='stylesheet' href='http://apiolaza.net/css/mANDo.css' type='text/css' />
        <link rel='stylesheet' href='http://apiolaza.net/css/pygments.css' type='text/css' />
    </head>
    <body>
        <div id='container'>
            <div id='page-header'>
            <h1><a href='http://apiolaza.net/'>Sketchbook</a></h1>
                <div id='page-menu'>
                <ul>
                <li><a href='http://apiolaza.net/ego-sum.html' title='Ego sum qui sum'>about</a></li>
                <li><a href='http://apiolaza.net/asreml-r/' title='asreml-r cookbook'>asreml-r</a></li>
                <li><a href='http://quantumforest.com/' title='Quantum Forest blog'>blog</a></li>
                <li><a href='http://apiolaza.net/code/' title='software'>code</a></li>
                <li><a href='http://apiolaza.net/colophon.html' title='Gory technical details'>colophon</a></li>
                <li><a href='http://apiolaza.net/publications.html'>publications</a></li>
                <li><a href='http://apiolaza.net/writings/'>writings</a></li>
                </ul>
                </div>
            </div>
            <div id='page-meta'>
                <!--navbar-->
                <p>This page was updated on <!--date--> (NZST) and is tagged 
                <!--tags-->.</p>
            </div>
            <div id='page-body'>
                <!--body-->
            </div>
            <div id='footer'>
                <p>All bits sowed, harvested and baked in Christchurch, New 
                Zealand—43º31'S, 172º32'E—by <a href='http://apiolaza.net'>Luis 
                Apiolaza</a> with 
                <a href='http://creativecommons.org/licenses/by-nc-sa/3.0/nz/'>some rights reserved</a>.
                A longer blurb and gory technical details can be found in the 
                <a href='http://apiolaza.net/colophon.html'>colophon</a>.</p>
            </div>
        </div>
    </body>
    </html>
    '''
    return(template)


# In case of using external template file
def read_template(filename = 'page-template.html'):
    try:
        f = codecs.open(filename, mode = 'r', encoding = 'utf-8')
    except IOError:
        print 'Template file not found'
        sys.exit()
    
    text = f.read()
    return(text)


# Obtains body and meta values from single page
def process_page(text):
    # Instance of class Markdown with two extensions
    md = markdown.Markdown(extensions = ['meta', 'codehilite', 'footnotes'])
    body = md.convert(text)
    meta = md.Meta
    return([body, meta])


# Combines body, meta information and template
def build_page(body, meta, template):    
    for key in meta.keys():
        lookfor = '<!--' + key + '-->'
        template = template.replace(lookfor, meta[key][0])

    template = template.replace('<!--body-->', body)
    return(template)


# Creates location bar
def location(filename, base_path, site_path):
    full_name = os.path.abspath(filename)
    base_length = len(base_path)
    nav = u'<p>Document tree: <a href="' + site_path + u'">home</a>'

    if full_name.find(base_path) >=0:
        rel_path = full_name[base_length:-5] + 'html'
        rel_path_parts = rel_path.rsplit('/')
    else:
        print 'File is not in site folder'
        sys.exit()

    for i in range(len(rel_path_parts)):
        nav = nav + u' « ' + u'<a href="' + \
              (site_path + u'/'.join(rel_path_parts[:1+i])) + \
              u'">' + rel_path_parts[i] + u'</a>'

    nav = nav + '</p>'
    return(nav)


# Writes page encoded as utf8
def write_page(page, name):
    (root, ext) = os.path.splitext(name)
    newname = root + '.html'
    f = codecs.open(newname, 'w', encoding = 'utf8')
    f.write(page)
    return()


# Help function
def usage():
    print 'Usage:'
    print 'python publon.py -d file.markdown (draft default) OR'
    print 'python publon.py -p file.markdown (publish)'
    return()


# Dictionary defining Castilian replacements
castilian = {u'á': '&aacute;', u'é': '&eacute;', u'í': '&iacute;',
             u'ó': '&oacute;', u'ú': '&uacute;', u'ñ': '&ntilde', 
             u'¿': '&iquest;', u'¡': '&iexcl;', u'ü': '&uuml;'}


# Convert castilian code to html entities
def convert_castilian(text, dictionary):
    for key in dictionary:
        text = text.replace(key, dictionary[key])

    return(text)


if __name__ == '__main__':
    # Processing command line options and arguments
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'dp', ['draft', 'publish'])
    except  getopt.GetoptError, err:
        print 'Error detected: ', err
        usage()
        sys.exit()

    # Reading file
    filename = args[0]
    try:
        f = codecs.open(filename, mode = 'r', encoding = 'utf-8')
    except IOError:
        print 'Markdown file not found'
        sys.exit()

    text = f.read()
    html, meta = process_page(text)
    template = inline_template()
    navbar = location(filename, base_path, site_path)
    meta[u'navbar'] = [navbar]
    page = build_page(html, meta, template)
    write_page(page, filename)
```

And that’s it.