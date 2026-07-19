defmodule PTree.Example do
  @moduledoc """
  Just type:
  ```elixir
  iex> PTree.Example.writer
  ```
  
  """
  
  alias IO.ANSI, as: C
  
  def writer(curr_word \\ "", curr_text \\ "")
  def writer("<exit>" <> curr_word, curr_text) do
    clear()
    IO.puts("#{curr_text}#{curr_word}")
  end
  def writer(" " <> curr_word, curr_text) do
    writer("", curr_text <> curr_word <> " ")
  end
  def writer(curr_word, curr_text) do
    clear()
    curr_word
    |> PTree.search_words([:sort])
    |> show_words()
    
    IO.write "#{C.cursor(1, 1)}"
    # IO.write(curr_text)
    # IO.write "#{C.cursor(2, 1)}"
    IO.write("# #{curr_text}#{curr_word}")
    curr_word = user_input(curr_word)
    writer(curr_word, curr_text)
  end

  defp user_input(text) do
    case read_char() |> IO.inspect do
      <<3>> -> "<exit>" <> text
      "\r" -> "<exit>" <> text
      "\n" -> "<exit>" <> text
      " " -> " " <> text
      "\d" -> String.slice(text, 0, max(0, String.length(text)-1))
      "\e" -> text
      c -> text <> c
    end    
  end
  
  defp read_char do
    System.shell(
      "(OC=`stty -g` ; stty raw -echo; head -c1; stty $OC) > x < /dev/stdin",
      [use_stdio: false]
    )
    File.read!("x")
  end

  defp clear do
    IO.puts "#{C.clear()}"
  end

  defp show_words(words) do
    IO.write("#{C.cursor(2,1)}")
    words
    |> Enum.join(" ")
    |> IO.write()
  end
  
end
