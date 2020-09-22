defmodule Forth do
  @type t :: %{
          stack: List.t(),
          dictionary: Map.t()
        }
  @opaque evaluator :: t

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    %{stack: [], dictionary: %{}}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator
  def eval(ev, s) do
    s
    |> String.trim()
    |> String.split(";", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(ev, fn statement, acc -> do_eval(acc, statement) end)
  end

  defp do_eval(ev, ":" <> s) do
    input =
      s
      |> String.upcase()
      |> tokenize()

    do_eval_word(ev, input)
  end

  defp do_eval(ev, []), do: ev

  defp do_eval(%{dictionary: dictionary} = ev, s) do
    input =
      s
      |> String.upcase()
      |> strip(Map.keys(dictionary) |> Enum.join(""))
      |> tokenize()
      |> translate(dictionary)

    do_eval_stack(ev, input)
  end

  defp strip(s, keep_chars), do: Regex.replace(~r/[^\dA-Z+-\/\*:;#{keep_chars}]/, s, " ")

  defp tokenize(s), do: String.split(s)

  defp translate(stacks, dictionary) do
    stacks |> Enum.flat_map(&translate_word(&1, dictionary))
  end

  defp translate_word(word, dictionary), do: Map.get(dictionary, word, [word])

  defp do_eval_stack(ev, []), do: ev

  defp do_eval_stack(%{stack: stack} = ev, [value | tail]) do
    new_stack = do_operate(value, stack)
    do_eval_stack(%{ev | stack: new_stack}, tail)
  end

  defp do_eval_word([], buffer), do: buffer
  defp do_eval_word([head | tail], buffer), do: do_eval_word(tail, [head | buffer])

  defp do_eval_word(%{dictionary: dictionary} = ev, [word | tail]) do
    case numeric?(word) do
      true ->
        raise Forth.InvalidWord

      _ ->
        word_def = do_eval_word(tail, [])
        new_dictionary = Map.put(dictionary, word, word_def)
        %{ev | dictionary: new_dictionary}
    end
  end

  # helper functions
  defp numeric?(s) when is_binary(s), do: Regex.match?(~r/\d+/, s)

  @spec take_one_and_compute(List.t(), (String.t(), List.t() -> List.t())) :: List.t()
  defp take_one_and_compute([value | stack], compute), do: compute.(value, stack)
  defp take_one_and_compute(_, _), do: raise(Forth.StackUnderflow)

  @spec take_one_and_compute(List.t(), (String.t(), String.t(), List.t() -> List.t())) :: List.t()
  defp take_two_and_compute([second | [first | stack]], compute),
    do: compute.(first, second, stack)

  defp take_two_and_compute(_, _), do: raise(Forth.StackUnderflow)

  defp calculate(arg_1, arg_2, func) do
    func.(parse_as_int(arg_1), parse_as_int(arg_2))
    |> Integer.to_string()
  end

  defp parse_as_int(arg) do
    {int_arg, _} = Integer.parse(arg)
    int_arg
  end

  # integer arithmetic
  @spec do_operate(String.t(), List.t()) :: List.t()
  defp do_operate("+", stack) do
    take_two_and_compute(stack, fn val1, val2, stack ->
      [calculate(val1, val2, &+/2) | stack]
    end)
  end

  defp do_operate("-", stack) do
    take_two_and_compute(stack, fn val1, val2, stack ->
      [calculate(val1, val2, &-/2) | stack]
    end)
  end

  defp do_operate("*", stack) do
    take_two_and_compute(stack, fn val1, val2, stack ->
      [calculate(val1, val2, &*/2) | stack]
    end)
  end

  defp do_operate("/", ["0" | [_ | _]]), do: raise(Forth.DivisionByZero)

  defp do_operate("/", stack) do
    take_two_and_compute(stack, fn val1, val2, stack ->
      [calculate(val1, val2, &div/2) | stack]
    end)
  end

  # stack manipulation
  defp do_operate("DUP", stack) do
    take_one_and_compute(stack, fn val, stack -> [val | [val | stack]] end)
  end

  defp do_operate("DROP", stack) do
    take_one_and_compute(stack, fn _, stack -> stack end)
  end

  defp do_operate("SWAP", stack) do
    take_two_and_compute(stack, fn val1, val2, stack -> [val1 | [val2 | stack]] end)
  end

  defp do_operate("OVER", stack) do
    take_two_and_compute(stack, fn val1, val2, stack -> [val1 | [val2 | [val1 | stack]]] end)
  end

  defp do_operate(value, stack) do
    case numeric?(value) do
      true -> [value | stack]
      false -> raise Forth.UnknownWord
    end
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%{stack: []}), do: ""

  def format_stack(%{stack: stack}) do
    stack |> Enum.reverse() |> Enum.join(" ")
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
