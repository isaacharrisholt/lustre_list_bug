import gleam/int
import gleam/io
import gleam/list
import lustre
import lustre/attribute.{class}
import lustre/element.{element}
import lustre/element/html.{html}
import lustre/event

pub fn app() {
  lustre.simple(init, update, view)
}

pub opaque type Model {
  Model(num: Int, pokemon: List(Int))
}

pub opaque type Msg {
  AddPokemon
}

fn init(_) {
  Model(1, [])
}

fn update(model: Model, msg: Msg) {
  case msg {
    AddPokemon -> {
      io.debug(model)
      Model(
        model.num + 1,
        [int.random(100), ..model.pokemon] |> list.sort(int.compare),
      )
    }
  }
}

fn view(model: Model) {
  html.div([class("grid grid-cols-2 gap-6 py-12 px-24")], [
    html.button(
      [
        class("col-span-2 p-4 text-lg bg-red-500 text-white rounded-lg"),
        event.on_click(AddPokemon),
      ],
      [html.text("Add Pokemon")],
    ),
    html.div([class("flex flex-col gap-4")], [
      html.h2([class("text-3xl font-bold")], [html.text("Keyed")]),
      element.keyed(
        html.div([class("flex flex-col gap-2 w-full")], _),
        list.map(model.pokemon, fn(pokemon) {
          #(pokemon |> int.to_string, pokemon_button(pokemon))
        }),
      ),
    ]),
    html.div([class("flex flex-col gap-4")], [
      html.h2([class("text-3xl font-bold")], [html.text("Not keyed")]),
      html.div(
        [class("flex flex-col gap-2 w-full")],
        list.map(model.pokemon, pokemon_button),
      ),
    ]),
  ])
}

fn pokemon_button(pokemon: Int) {
  html.button(
    [
      class(
        "flex flex-row items-center gap-4 px-8 py-4 rounded-lg bg-blue-500 text-white",
      ),
    ],
    [
      html.img([
        class("w-24 h-24"),
        attribute.src(
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
          <> int.to_string(pokemon)
          <> ".png",
        ),
      ]),
      html.text(int.to_string(pokemon)),
    ],
  )
}
