defmodule Hangman do

  defp getWord(), do: Hangman.Config.wordList
                        |> Enum.random
                        |> String.downcase


  defp removeIfMatch(letter, word), do: word
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

  def play() do
    word = getWord()
    playUntilFound({word, word, [], 0})
  end

  defp playUntilFound({originalWord, _ , _ , attemptCount}) when attemptCount >= 10 do
      Hangman.PrintHelper.printFail({originalWord, attemptCount})
  end

  defp playUntilFound({originalWord, "", _ , attemptCount}) do
    Hangman.PrintHelper.printSuccess({originalWord, attemptCount})
  end

  defp playUntilFound({originalWord, word, letterList, attemptCount}) do
     IO.puts(Hangman.PrintHelper.fillDashes(originalWord, letterList))
     IO.puts("Your Guesses Till now : ")
     IO.puts(letterList)
     guess = IO.gets("Your Guess?") |> String.trim
     case String.contains?(word, guess) do
       true -> playUntilFound({originalWord, removeIfMatch(guess, word), letterList++[guess], attemptCount})
       false -> playUntilFound({originalWord, word, letterList++[guess], attemptCount+1})
     end
  end

  defmodule Config do
    def wordList, do: ["Health","Wealth","Dinner","Train","Television","Cooking"]
  end

  defmodule PrintHelper do
    def fillDashes word, availableList do
      fillListWithDashes String.codepoints(word),availableList, []
    end

    defp fillListWithDashes([], _, dashesList), do: dashesList
    defp fillListWithDashes([letter|word], availableList, dashesList) do
        fillListWithDashes word, availableList, dashesList++[getDashIfUnavailable(letter,availableList)]
    end

    defp getDashIfUnavailable letter, list do
      case Enum.member?(list, letter) do
        true ->  letter
        false -> "_"
      end
    end

    def printFail({originalWord, attemptCount}) do
      IO.puts("You have lost to guess the word "++ originalWord)
      IO.puts("Total Attempts:" <> attemptCount)
    end

    def printSuccess({ _ , attemptCount}) do
      IO.puts("You have Won with " <> spareAttempts(attemptCount) <> " lifes to spare")
    end
    defp spareAttempts(attemptCount), do: 10-attemptCount |> Integer.to_string
  end
end
