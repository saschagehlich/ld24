window.every = (t, f) -> setInterval f, t
window.after = (t, f) -> setTimeout f, t

$ ->
  game = window.game = new LD24.Game($('canvas'))