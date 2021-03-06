defmodule Pdf2htmlex do
  @moduledoc """
    Provides functions to convert PDF documents to HTML.
    The command line tool [pdf2HtmlEX](http://coolwanglu.github.io/pdf2htmlEX/) must be installed and needs to be
    added to your PATH.

    ## Examples

      iex(1)> Pdf2htmlex.open("test/fixtures/simple.pdf") |> Pdf2htmlex.convert_to!("/tmp")

      iex(2)> Pdf2htmlex.open("test/fixtures/simple.pdf") |> Pdf2htmlex.zoom(2.0) |> Pdf2htmlex.convert_to!("/tmp")
  """

  @doc """
    Adds the path to an input file (PDF) to a list that will be used to build up options that
    will be used for conversion.
  """
  def open(pdf_path) when is_binary(pdf_path) do
    pdf_path = Path.expand(pdf_path)
    unless File.regular?(pdf_path), do: raise(File.Error, reason: :enoent, action: "read", path: pdf_path)

    [pdf_path]
  end
  @doc """
    Converts the PDF with given options to a output directory
  """
  def convert_to!(opts, dir) when is_list(opts) do
    exec_cmd(["--dest-dir", dir | opts])
  end

  @doc """
    Zoom ratio
  """
  def zoom(opts, zoom_ratio) when is_list(opts) and is_float(zoom_ratio), do: ["--zoom", f_to_s(zoom_ratio) | opts]
  @doc """
    First page to convert
  """
  def first_page(opts, first) when is_list(opts) and is_integer(first), do: ["--first-page", i_to_s(first) | opts]
  @doc """
    Last page to convert
  """
  def last_page(opts, last) when is_list(opts) and is_integer(last), do: ["--last-page", i_to_s(last) | opts]
  @doc """
    Fit width to (in pixels)
  """
  def fit_width(opts, width) when is_list(opts) and is_integer(width), do: ["--fit-width", i_to_s(width) | opts]
  @doc """
    Fit height to (in pixels)
  """
  def fit_height(opts, height) when is_list(opts) and is_integer(height), do: ["--fit-height", i_to_s(height) | opts]
  @doc """
    Use CropBox instead of MediaBox
  """
  def use_mediabox(opts) when is_list(opts), do: ["--use-cropbox", "0" | opts]
  @doc """
    Horizontal resolution for graphics in DPI (default: 144)
  """
  def hdpi(opts, dpi) when is_list(opts) and is_integer(dpi), do: ["--hdpi", i_to_s(dpi) | opts]
  @doc """
    Vertical resolution for graphics in DPI (default: 144)
  """
  def vdpi(opts, dpi) when is_list(opts) and is_integer(dpi), do: ["--vdpi", i_to_s(dpi) | opts]
  @doc """
    Puts CSS in external files
  """
  def externalize_css(opts) when is_list(opts), do: ["--embed-css", "0" | opts]
  @doc """
    Puts fonts in external files
  """
  def externalize_font(opts) when is_list(opts), do: ["--embed-font", "0" | opts]
  @doc """
    Puts images in external files
  """
  def externalize_image(opts) when is_list(opts), do: ["--embed-image", "0" | opts]
  @doc """
    Puts Javascript in external files
  """
  def externalize_javascript(opts) when is_list(opts), do: ["--embed-javascript", "0" | opts]
  @doc """
    Puts outline in external file
  """
  def externalize_outline(opts) when is_list(opts), do: ["--embed-outline", "0" | opts]
  @doc """
    Puts every page in an external HTML file
  """
  def split_pages(opts) when is_list(opts), do: ["--split-pages", "1" | opts]

  defp exec_cmd(opts) do
    cmd = System.find_executable("pdf2htmlEX") || ""
    {msg, exit_status} = System.cmd(cmd, opts, stderr_to_stdout: true)
    if exit_status != 0 do
      raise RuntimeError, message: "The command line tool reported an error: #{msg}"
    end
  end

  defp i_to_s(s), do: Integer.to_string(s)
  defp f_to_s(f), do: Float.to_string(f, [decimals: 1, compact: true])
end
