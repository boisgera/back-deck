import m from "https://cdn.skypack.dev/mithril";
import * as commonmark from "https://cdn.skypack.dev/commonmark"
import * as uuid from 'https://jspm.dev/uuid';

# TODO: Mathjax (switch the markdown generator? See what marp is using?)

# TODO: define r = String.raw and enjoy the r"""kcldkldk""" raw strings

# TODO: sensible default style

# TODO: what scheme for component to register a (link or css) dependency
#       that we want to be included but not TWICE? Is there something in
#       the lifecycle stuff that would do that? MMmm maybe oninit, but
#       it's probably overkill. Make the stuff manually

# TODO: replicate slides pattern that work, see e.g. 
#       https://www.canva.com/learn/keynote-presentations/


document.head.innerHTML += 
"""
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@300;400;500;600;700&display=swap" rel="stylesheet">
"""

# Google Fonts / Figtree
document.head.innerHTML +=
"""
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Figtree:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Fira+Code:wght@300;400;500;600;700&display=swap" rel="stylesheet"> 
"""

document.head.innerHTML += 
"""
<style> 
* {
  margin: 0;
  padding: 0;
}
html {
  font-family: Inter;
  font-size: 24px;
}
</style>
"""


class Hello
    oninit: (vnode) ->
        this.count = 0
    view: (vnode) ->
        state = vnode.state
        m "main", [
            m "h1", class: "title", "My first zapp",
            m "button", onclick: (=> this.count++), this.count + " clicks",
        ]

# TODO: support gradients
# TODO: support various image transformation (grey-ish, etc. see Marp)
class Background 
    view: (vnode) -> 
        {attrs, children} = vnode
        {url} = attrs
        m "div", 
            style: 
                backgroundImage: "url('#{url}')"
                backgroundSize: "cover"
                width: "100%"
                height: "100%"
            children


class Hero
    view: (vnode) -> 
        m "div", 
            style: 
                width: "100vw" 
                height: "100vh"
                backgroundColor: "#c8d8e4"
                display: "flex"
                alignItems: "center"
                justifyContent: "center"
            m "h1", vnode.children

# TODO: accept style and class and id forwarding (?). Why stop there?
class Markdown
    view: (vnode) ->
        {attrs, children} = vnode
        {text} = attrs
        reader = new commonmark.Parser()
        writer = new commonmark.HtmlRenderer()
        ast = reader.parse(text)
        html = writer.render(ast)
        m.trust(html)

class Slide
    view: ({children}) ->
        return m "div",
            style:
                width: "100vw"
                height: "100vh"
            children

class Row
    view: ({children}) ->
        m "div", 
            style:
               display: "flex"
               flexDirection: "row"
               height: "100%"    
            children

src = """
if True:
    pass
"""

# TODO: width-aware stuff, black'd.

class Code 
    view: (vnode) ->
        {src} = vnode.attrs # TODO: numeric characters (default ?)
                            # Should we register resize event? 
                            # addEventListener('resize', m.redraw)
                            # Use a discrete "grid?" (40, 50, 60, 70, 80, 90?)
                            # TODO: add "current" 
        m "pre", 
            style:
                overflow: "auto"
                width: "23em" # make an option for code width, calc the extra stuff.
                backgroundColor: "rgb(235, 236, 237)"
                padding: "1em 1.5em"
            m "code",
                style:
                    fontFamily: "'Fira Code'"
                    fontSize: "16px"
                src

# The issue I have here: I like inline style better (more coffee, less css,
# easier to deal with), BUT I'd like to style the <strong> children, to assign
# them a given weight and color, AND I don't wanna mess with the markdown
# stuff (I can't deal with strong elements as Mithril components).
#
# Most reasonable option?
#
# Hack I think of: make a style sheet that selects some convoluted data attribute,
# attach it to Markdown. Naaaaah, Markdown doesn't honor the extra attributes
# (and that's a feature). Do that AND an extra wrapping level ... WTF the mess
# that we have to do to emulate scoped css. Can I use a shadow dom here?


# TODO: manage css being text as a special case
# Rk: I could add the scoping id as an ancestor to every css rule, 
#     but what if we want something more precise wrt this ancestor
#     I guess that if that happens, i'll introduce :scope.

# See https://github.com/MithrilJS/mithril.js/blob/master/render/render.js#L798
uppercaseRegex = /[A-Z]/g
toLowerCase = (capital) -> "-" + capital.toLowerCase()
normalizeKey = (key) -> key.replace(uppercaseRegex, toLowerCase)

ScopedStyle = (initialVnode) ->
    view: (vnode) ->
        {css, id} = vnode.attrs
        cssText = ""
        for selector, rules of css
            cssText += "##{id} #{selector} {\n"
            for key, value of rules
                cssText += "  #{normalizeKey(key)}: #{String(value)};\n"
            cssText += "}\n\n"
        console.log cssText
        m "style", 
            cssText


# TODO: study the "freeze to 16/9" (or 4/3?) trick of marp with HTML in SVG in HTML.
# Maybe there are some other ways (transforms, that kind of thing, like reveal?)

#See <https://www.canva.com/learn/keynote-presentations/>
class Slide42
    view: (vnode) ->
        attrs = vnode.attrs
        id = attrs.id
        id ?= "uuid-" + uuid.v4()
        m "div",
            id: id
            style: 
                fontFamily: "Figtree"
                fontWeight: 900
                padding: 96 + "px"
                height: "calc(100vh - 2*96px)"
                display: "grid"
                gridTemplateColumns: "1fr 3fr"
                gap: 48 + "px"
                alignItems: "center"
            m ScopedStyle, 
                id: id
                css:
                    strong:
                        color: "#7fcbde"
                        fontWeight: 900
            m "div",
                style:
                    fontSize: 42 + "px"
                    lineHeight: 0.9 + "em"
                    gridColumn: 1
                    textAlign: "end"
                m Markdown, 
                    text: 
                        """
                        Let me tell   
                        you this
                        """
            m "div",
                style:
                    fontSize: 96 + "px"
                    lineHeight: 0.9 + "em"
                    gridColumn: 2
                m Markdown, 
                    text:
                        """
                        there are  
                        **no creatives**  
                        and there are  
                        **no strategists**
                        """

# TODO: torture test wrt attributes & resize. Currently the visible overflow
#       plus the absence of min height can yield weird, non-centered graphics.
#       But overall, the stuff works.
# TODO: display the background which is not foreign object differently.
#       Yeah, better. Easier to spot the fuck that is going on.
class MarpSlide
    view: ({children}) -> 
        return m "div",
            style:
                width: "#{100}vw"
                height: "#{100}vh"
                backgroundColor: "black"
            m "svg",
                viewBox: "#{0} #{0} #{1600} #{900}"
                preserveAspectRatio: "xMidYMid meet"
                style: 
                    display: "block"
                    width: "100%"
                    height: "100%"
                    position: "absolute"
                    top: 0
                    left: 0
                    overflow: "hidden"
                    overflowClipMargin: "content-box"
                m "foreignObject",
                    width: 1600
                    height: 900
                    #style:
                    #     marginBottom: "27"
                    #     overflow: "hidden"
                    #     overflowClipMargin: "content-box"                  
                    m "section", 
                        "xmlns": "http://www.w3.org/1999/xhtml"
                        style:
                            backgroundColor: "white"
                            width: "1600" # vunits don't work here (???)
                            height: "900"
                        children


body = document.body
# m.mount(body, view: -> m Hero, "Back Deck")
m.route body, "/slide42",
    "/slide42":
        view: ->
            m MarpSlide,
                m Slide42
    "/code": 
        view: ->
            m "div",
                style: 
                    padding: "1em"
                m Code, src: src
    "/splash": 
        view: -> m Hero, [
            "Back Deck",
            m "a", href: "#!hello", "👋"
            m "a", href: "#!pencil", "✏️"
            m "a", href: "#!markdown", "📄"
        ]
    "/hello": 
        view: -> m Hero, "👋 Hello!"
    "/pencil": 
        view: -> 
            m Slide,
                m Background, 
                    url: "images/joanna-kosinska-1_CMoFsPfso-unsplash.jpg"
    "/markdown":
        view: -> m Markdown, text:
            """
            Title
            =====

            Buh

            - I can't do that **Dave**!

            -----

            [Le Monde](https://www.lemonde.fr)

            """
    "/twocolumn":
        view: ->
            m Slide, # TODO: TwoColumnSlide, or columns option to Slide?  
                m Row, [
                    m "div",
                        style:
                            width: "25%"
                        m Background, 
                            url: "images/joanna-kosinska-1_CMoFsPfso-unsplash.jpg"
                    m "div",
                        style:
                            width: "75%" 
                        m Markdown, text: "# This is the end"
                ]
