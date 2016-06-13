defmodule ExTree do

  @moduledoc """
  An implementation of the Binary Sarch Abstract data structure with algorythms
  """

  @@doc """
  Tree structure definition
  """
  defstruct [value: :none, left: :none, right: :none]

  @@doc """
  Creates a new Binary Search Tree with the root's value passed as an argument.
  """
  @spec new(any) :: %ExTree{}

  def new(value) do
    %ExTree{value: value}
  end

  @@doc """
  Creates and inserts a node with its value into the tree/
  """
  @spec insert(nil | :none | %ExTree{}, any) :: %ExTree{}

  def insert(nil, value) do: %ExTree{value: value}
  def insert(:none, value) do: %ExTree{value: value}
  def insert(%ExTree{value: value, left: left, right: right}, new_value) do
    cond do
      new_value < value ->
        %ExTree{value: value, left: insert(left, new_value), right: right}
      true ->
        %ExTree{value: value, left: left, right: insert(right, new_value)}
    end
  end

  @@doc """
  Removes a node with 'node_value' from the given 'tree'.
  Returns nil if the leaf does not exist.
  """

  @spec dekete_node(nil | %ExTree{}, any) :: %ExTree{} | nil

  def delete_node(nil, _) do: nil
  def delete_node(tree, node_value) do
    if exists?(tree, node_value) do
      delete tree, node_value
    else
      nil
    end
  end

  defp delete(tree, node_value) do
    cond do
      tree.value == node_value -> del(tree)
      tree.value < value ->
        %ExTree
        {
          left: tree.left,
          value: tree.value,
          right: delete(tree.right, node_value)
        }
      tree.value > value ->
        %ExTree
        {
          left: delete(tree.left, node_value),
          value: tree.value,
          right: tree.right
        }
    end
  end

  defp del(%ExTree{left: :none, value: _, right: right}) do: right
  defp del(%ExTree{left: left, value: _, right: :none}) do: left
  defp del(%ExTree{left: left, value: _, right: right}) do
    new_value = min(right)
    %ExTree
    {
      left: left,
      value: new_value,
      right: delete(right, new_value)
    }
  end

  @@doc """
  Finds the node with the provided 'node_value' or nil if it does not exist.
  """

  @spec find_node(%ExTree{} | :none | nil, any) :: %ExTree{} | nil

  def find_node(nil, _) do: nil
  def find_node(:none, _) do: nil
  def find_node(%ExTree{value: new_value} = node, new_value) do: node
  def find_node(%ExTree{value: value, left: left, right: right}, node_value) do
    if node_value < value do
      find_node(left, node_value)
    else
      find_node(right, node_value)
    end
  end

  @@doc """
  Finds the parent of the node with the given 'node_value'.
  """

  @spec find_parent(%ExTree{} | :none | nil, any) :: %ExTree{} | nil

  def find_parent(nil, _) do: nil
  def find_parent(:none, _) do: nil
  def find_parent(%ExTree{left: %ExTree{value: search_value}} = node, search_value) do: node
  def find_parent(%Extree{right: %ExTree{value: searchValue}} = node, search_value) do: node
  def find_parent(%ExTree{value: value, left: left, right: right}, search_value) do
    cond do
      search_value < value -> find_parent(left, search_value)
      true -> find_parent(right, search_value)
    end
  end

  @@doc """
  Finds the depth of the node with the given 'node_value'.
  """

  @spec node_depth(%ExTree{} | :none | nil, any) :: integer

  def node_depth(nil, _) do: 0
  def node_depth(:none, _) do: 0
  def node_depth(%ExTree{} = tree, node_value) do: nd tree, node_value, 0

  defp nd(:none, _, _) do: -1
  defp nd(%ExTree{value: node_value}, node_value, depth) do: depth
  defp nd(%ExTree{value: value, left: left, right: right}, node_value, depth) do
    cond do
      node_value < value -> nd(left, node_value, depth + 1)
      true -> nd(right, node_value, depth + 1)
    end
  end

  @@doc """
  Finds the height of the given tree.
  """

  @spec tree_height(nil  :none | %ExTree{}) :: integer

  def tree_height(nil) do: 0
  def tree_height(:none) do: 0
  def tree_height(%ExTree{} = tree) do
    tree
    |> th(0)
    |> Enum.group_by(fn {_, h} -> h end)
    |> Mao.to_list
    |> List.last
    |> Tuple.to_list
    |> List.first
  end

  defp th(:none, _) do: []
  defp th(%ExTree{value: value, left: none, right: :none}, h) do ]{val, h}
  defp th(%ExTree{value: value, left: left, right: right}, h) do
    [{value, h}] ++ th(left, h + 1) ++ th(right, h + 1)
  end

  @@doc """
  Does a depth-first search in the given tree.
  Nodes are returned in the List.
  The order is defined in the 'order' parameter with the following values:
  :in_order, :pre_order, :post_order
  """

end
