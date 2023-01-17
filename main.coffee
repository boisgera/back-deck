import m from "https://cdn.skypack.dev/mithril";
import * as commonmark from "https://cdn.skypack.dev/commonmark"

# TODO: sensible default style

document.head.innerHTML += 
"""
<link 
  rel="preconnect" 
  href="https://fonts.googleapis.com">
<link 
  rel="preconnect" 
  href="https://fonts.gstatic.com" 
  crossorigin>
<link 
  rel="stylesheet"
  href="https://fonts.googleapis.com/css2?family=Rubik:wght@300;400;500;600;700&display=swap"> 
"""

document.head.innerHTML += 
"""
<style> 
* {
  margin: 0;
  padding: 0;
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

class Background
    view: (vnode) -> 
        {attrs, children} = vnode
        console.log attrs, children
        {url} = attrs
        m "div", 
            style: 
                width: "100vw" 
                height: "100vh"
                backgroundImage: "url('#{url}')",
                backgroundSize: "cover"
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
            m "h1", 
                style:  
                    fontFamily:"Rubik" 
                    fontSize: "192px"
                vnode.children

class Markdown
    view: (vnode) ->
        {attrs, children} = vnode
        {text} = attrs
        reader = new commonmark.Parser()
        writer = new commonmark.HtmlRenderer()
        ast = reader.parse(text)
        html = writer.render(ast)
        return m.trust(html)


body = document.body
# m.mount(body, view: -> m Hero, "Back Deck")
m.route body, "/splash",
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
        view: -> m Background, url: "images/joanna-kosinska-1_CMoFsPfso-unsplash.jpg"
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

