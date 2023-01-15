import m from "https://cdn.skypack.dev/mithril";

document.head.innerHTML += '
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Alegreya+SC&family=Alegreya:wght@400;700&family=Rubik:wght@300;400;500;600;700&display=swap" rel="stylesheet"> 
'

document.head.innerHTML += "
<style> 
* {
  margin: 0;
  padding: 0;
}
</style>
"


class Hello
    oninit: (vnode) ->
        vnode.state.count = 0
    view: (vnode) ->
        state = vnode.state
        m "main", [
            m "h1", class: "title", "My first zapp",
            m "button", onclick: (-> state.count++), state.count + " clicks",
        ]

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


body = document.body
# m.mount(body, view: -> m Hero, "Back Deck")
m.route body, "/splash",
    "/splash": view: -> m Hero, [
        "Back Deck",
        m "a", href: "#!hello", "👋"
    ]
    "/hello": view: -> m Hero, "👋 Hello!"

