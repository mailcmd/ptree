defmodule PTree do
  @moduledoc File.read!("README.md")
  
  defmodule Build do
    @app_dir (
      if File.cwd!() =~ "/deps/ptree" do
        File.cwd!() <> "/../.."
      else
        File.cwd!()
      end
     ) |> Path.expand()

    @external_resource "#{@app_dir}/words.txt"
    
    @builtin_words_list (
      case File.read("#{@app_dir}/words.txt") do
        {:ok, words} ->
          IO.puts("#{IO.ANSI.green_background()}#{IO.ANSI.black()}The builtin prefix tree was"<>
                    " successfully built from #{@app_dir}/words.txt file.#{IO.ANSI.reset()}")
          words
          |> String.split("\n")
          |> Enum.map(&String.trim/1)
          |> Enum.filter(&(&1 != ""))

        _ ->
          IO.puts("#{IO.ANSI.red_background()}No #{@app_dir}/words.txt file found. "
                 <> "Builtin prefix tree empty.#{IO.ANSI.reset()}")
          []
      end
    )    

    @type ptree :: map()
    @type words :: list(String.t())
  
    @doc false
    def build_builtin_ptree(), do: build_ptree(@builtin_words_list)
    
    ##############################################################################################
    ## Public API
    ##############################################################################################
    @spec build_ptree(words_list :: words, ptree :: ptree) :: ptree
    def build_ptree(words, ptree \\ %{})
    def build_ptree([], ptree), do: ptree 
    def build_ptree([word | words], ptree) do
      ptree = add_ptree_word(word, ptree)
      build_ptree(words, ptree)
    end

    ##############################################################################################
    ## Private lib
    ##############################################################################################
    defp add_ptree_word(word, ptree), do: add_ptree_word(word, word, ptree)
    defp add_ptree_word(<<>>, word, ptree), do: Map.put(ptree, :word, word)
    defp add_ptree_word(<<l>> <> postfix, word, ptree) do
      update_in(ptree, [<<l>>], fn
        nil -> add_ptree_word(postfix, word, %{})
        map -> add_ptree_word(postfix, word, map)  
      end)
    end
  end

  @builtin_ptree Build.build_builtin_ptree()

  ################################################################################################
  ## Public API
  ################################################################################################

  @spec get_builtin_ptree() :: Build.ptree
  def get_builtin_ptree(), do: @builtin_ptree
  
  @spec search_words(prefix :: String.t()) :: Build.words
  def search_words(prefix) do
    search_words(@builtin_ptree, prefix)
  end
  @spec search_words(prefix_tree :: Build.ptree, prefix :: String.t()) :: Build.words
  def search_words(ptree, prefix) do
    ptree = search_subptree(ptree, prefix)
    get_words(ptree)
  end


  ################################################################################################
  ## Private lib
  ################################################################################################
  defp search_subptree(ptree, <<>>), do: [{nil, ptree}]
  defp search_subptree(ptree, <<l::8>> <> prefix) do
    if ptree[<<l>>] do
      search_subptree(ptree[<<l>>], prefix)
    else
      ptree[<<l>>]
    end
  end
  
  defp get_words(ptree, acc \\ [])
  defp get_words(nil, acc), do: acc 
  defp get_words(ptree, acc) when is_map(ptree), do: get_words(Map.to_list(ptree), acc)
  defp get_words([], acc), do: acc 
  defp get_words([{_, %{word: word} = subptree} | ptree], acc) do    
    acc =
      subptree
      |> Map.delete(:word)
      |> get_words([word | acc])
    get_words(ptree, acc)
  end
  defp get_words([{_, %{} = subptree} | ptree], acc) do
    acc = get_words(subptree, acc)
    get_words(ptree, acc)
  end
  
end


