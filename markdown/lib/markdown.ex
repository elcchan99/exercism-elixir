defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """

  defmodule Utils do
    def enclose_with_tag({tag, line}, function \\ & &1) do
      "<#{tag}>" <> function.(line) <> "</#{tag}>"
    end
  end

  defmodule Header do
    @markdown_tag "#"
    @html_tag "h"

    def type?(line), do: String.starts_with?(line, @markdown_tag)

    def to_html(line) do
      line
      |> parse()
      |> enclose_with_tag()
    end

    defp parse(line) do
      [header | tail] = String.split(line)
      {parse_level(header), Enum.join(tail, " ")}
    end

    defp parse_level(header) do
      header
      |> String.length()
    end

    defp enclose_with_tag({level, content}) do
      {@html_tag <> to_string(level), content}
      |> Utils.enclose_with_tag()
    end
  end

  defmodule List do
    @markdown_tag "*"
    @html_tag "li"

    def type?(line), do: String.starts_with?(line, @markdown_tag)

    def to_html(line) do
      line
      |> parse()
      |> enclose_with_tag()
    end

    def patch_unorder_tag(html) do
      html
      |> String.replace("<li>", "<ul><li>", global: false)
      |> String.replace_suffix("</li>", "</li></ul>")
    end

    defp parse(line) do
      {String.trim_leading(line, "#{@markdown_tag} ")}
    end

    defp enclose_with_tag({content}) do
      {@html_tag, content}
      |> Utils.enclose_with_tag()
    end
  end

  defmodule Paragraph do
    def to_html(line), do: enclose_with_tag({line})

    defp enclose_with_tag({content}) do
      {"p", content}
      |> Utils.enclose_with_tag()
    end
  end

  defmodule Bold do
    @markdown_tag "__"
    @html_tag "strong"
    @match_regex ~r/#{@markdown_tag}(.*)#{@markdown_tag}/U
    @replacement "<#{@html_tag}>\\1</#{@html_tag}>"

    def type?(line), do: line =~ @match_regex

    def to_html(line) do
      line
      |> replace_with_tag()
    end

    defp replace_with_tag(line) do
      Regex.replace(@match_regex, line, @replacement)
    end
  end

  defmodule Italic do
    @markdown_tag "_"
    @html_tag "em"
    @match_regex ~r/#{@markdown_tag}(.*)#{@markdown_tag}/U
    @replacement "<#{@html_tag}>\\1</#{@html_tag}>"

    def type?(line), do: line =~ @match_regex

    def to_html(line) do
      line
      |> replace_with_tag()
    end

    defp replace_with_tag(line) do
      Regex.replace(@match_regex, line, @replacement)
    end
  end

  defmodule Text do
    @text_styles [{~r/__(.*)__/U, :bold}, {~r/_(.*)_/U, :italic}]

    def to_html({:bold, line}), do:  line |> Bold.to_html() |> to_html()
    def to_html({:italic, line}), do:  line |> Italic.to_html() |> to_html()
    def to_html({_, line}), do:  line

    # Ref: https://elixirforum.com/t/simulate-regex-match-guards-in-functions/675/2
    def to_html(line) do
      {_, type} = Enum.find(@text_styles, {nil, ""}, fn {reg, _} ->
        String.match?(line, reg)
      end)
      to_html({type, line})
    end
  end

  @spec parse(String.t()) :: String.t()
  def parse(m) do
    m
    |> String.split("\n")
    |> Enum.map_join("", &to_html(&1))
    |> List.patch_unorder_tag()
  end

  defp to_html(line = "#" <> _), do: line |> Header.to_html()

  defp to_html(line = "*" <> _), do: line |> List.to_html() |> Text.to_html()

  defp to_html(line),  do: line |> Paragraph.to_html() |> Text.to_html()
end
