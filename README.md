# PTree

An experimental and very simple implementation of [prefix tree](https://en.wikipedia.org/wiki/Trie).

## Usage

PTree allow to load in compile time a words list. Just put a text file "words.txt" in the application root. If the file does not exists the builtin list will be empty. 

´´´elixir 
iex> PTree.search_words("he") # Search in builtin PTree
["hesitant", "helpless", "helpful", "help", "hellish", "heavy", "heavenly",
 "heat", "heartbreaking", "heap", "healthy", "health", "heal", "heady", "head"]

iex> ptree = PTree.Build.build_ptree(words_list) # Build a custom PTree from a words list

iex> PTree.search_words(ptree, "he") # Search in a custom PTree
´´´


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ptree` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ptree, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/prefix_tree>.

