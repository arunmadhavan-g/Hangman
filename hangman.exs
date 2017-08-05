defmodule Hangman do

  defp wordList(), do: ["Health","Wealth","Dinner","Train","Television","Cooking"]

  def getWord(), do: wordList()
                        |> Enum.random
                        |> String.downcase


  def removeIfMatch(letter, word), do: word
                                        |> String.codepoints
                                        |> removeAllOccurrences(letter)
                                        |> List.to_string


  defp removeAllOccurrences(list, letter) do
    case Enum.member?(list, letter) do
      true ->
          removeAllOccurrences(List.delete(list,letter), letter)
      false->
          list
    end
  end

  def play(), do: getWord()
                  |> playUntilFound()

  defp playUntilFound(""), do:  IO.puts("Game Over")

  defp playUntilFound(word), do: IO.gets("Your Guess?")
                                  |> String.trim
                                  |> removeIfMatch(word)
                                  |> playUntilFound()


end
