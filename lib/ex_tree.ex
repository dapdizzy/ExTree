defmodule ExTree do

  @moduledoc """
  An implementation of the Binary Sarch Abstract data structure with algorythms
  """

  @doc """
  Tree structure definition
  """
  defstruct [value: :none, left: :none, right: :none]

  @doc """
  Creates a new Binary Search Tree with the root's value passed as an argument.
  """
  @spec new(any) :: %ExTree{}

  def new(value) do
    %ExTree{value: value}
  end

  @doc """
  Creates and inserts a node with its value into the tree/
  """
  @spec insert(nil | :none | %ExTree{}, any) :: %ExTree{}

  def insert(nil, value), do: %ExTree{value: value}
  def insert(:none, value), do: %ExTree{value: value}
  def insert(%ExTree{value: value, left: left, right: right}, new_value) do
    cond do
      new_value < value ->
        %ExTree{value: value, left: insert(left, new_value), right: right}
      true ->
        %ExTree{value: value, left: left, right: insert(right, new_value)}
    end
  end

  @doc """
  Removes a node with 'node_value' from the given 'tree'.
  Returns nil if the leaf does not exist.
  """

  @spec delete_node(nil | %ExTree{}, any) :: %ExTree{} | nil

  def delete_node(nil, _), do: nil
  def delete_node(tree, node_value) do
    if exists?(tree, node_value) do
      delete tree, node_value
    else
      nil
    end
  end

  defp delete(%ExTree{value: node_value, left: left, right: right} = tree, value) do
    cond do
      node_value == value -> del(tree)
      node_value < value ->
        %ExTree
        {
          left: left,
          value: node_value,
          right: delete(right, value)
        }
      node_value > value ->
        %ExTree
        {
          left: delete(left, value),
          value: node_value,
          right: right
        }
    end
  end

  defp del(%ExTree{left: :none, value: _, right: right}), do: right
  defp del(%ExTree{left: left, value: _, right: :none}), do: left
  defp del(%ExTree{left: left, value: _, right: right}) do
    new_value = min(right)
    %ExTree
    {
      left: left,
      value: new_value,
      right: delete(right, new_value)
    }
  end

  defp min(%ExTree{left: :none, value: value}), do: value
  defp min(%ExTree{left: left}), do: min left

  @doc """
  Finds the node with the provided 'node_value' or nil if it does not exist.
  """

  @spec find_node(%ExTree{} | :none | nil, any) :: %ExTree{} | nil

  def find_node(nil, _), do: nil
  def find_node(:none, _), do: nil
  def find_node(%ExTree{value: new_value} = node, new_value), do: node
  def find_node(%ExTree{value: value, left: left, right: right}, node_value) do
    if node_value < value do
      find_node(left, node_value)
    else
      find_node(right, node_value)
    end
  end

  @doc """
  Finds the parent of the node with the given 'node_value'.
  """

  @spec find_parent(%ExTree{} | :none | nil, any) :: %ExTree{} | nil

  def find_parent(nil, _), do: nil
  def find_parent(:none, _), do: nil
  def find_parent(%ExTree{left: %ExTree{value: search_value}} = node, search_value), do: node
  def find_parent(%ExTree{right: %ExTree{value: search_value}} = node, search_value), do: node
  def find_parent(%ExTree{value: value, left: left, right: right}, search_value) do
    cond do
      search_value < value -> find_parent(left, search_value)
      true -> find_parent(right, search_value)
    end
  end

  @doc """
  Finds the depth of the node with the given 'node_value'.
  """

  @spec node_depth(%ExTree{} | :none | nil, any) :: integer

  def node_depth(nil, _), do: 0
  def node_depth(:none, _), do: 0
  def node_depth(%ExTree{} = tree, node_value), do: nd tree, node_value, 0

  defp nd(:none, _, _), do: -1
  defp nd(%ExTree{value: node_value}, node_value, depth), do: depth
  defp nd(%ExTree{value: value, left: left, right: right}, node_value, depth) do
    cond do
      node_value < value -> nd(left, node_value, depth + 1)
      true -> nd(right, node_value, depth + 1)
    end
  end

  @doc """
  Finds the height of the given tree.
  """

  @spec tree_height(nil | :none | %ExTree{}) :: integer

  def tree_height(nil), do: 0
  def tree_height(:none), do: 0
  def tree_height(%ExTree{} = tree) do
    tree
    |> th(0)
    |> Enum.group_by(fn {_, h} -> h end)
    |> Map.to_list
    |> List.last
    |> Tuple.to_list
    |> List.first
  end

  defp th(:none, _), do: []
  defp th(%ExTree{value: value, left: :none, right: :none}, h), do: [{value, h}]
  defp th(%ExTree{value: value, left: left, right: right}, h) do
    [{value, h}] ++ th(left, h + 1) ++ th(right, h + 1)
  end

  @doc """
  Does a depth-first search in the given tree.
  Nodes are returned in the List.
  The order is defined in the 'order' parameter with the following values:
  :in_order, :pre_order, :post_order
  """

  @spec depth_first_search(:none | %ExTree{}, atom) :: list(any)

  def depth_first_search(tree, order)
  when order == :pre_order
  or order == :in_order
  or order == :post_order
  do
    # Parameters goes like this: tree, order, acc, tobe_searched, tobe_appended
    dfs_tail tree, order, [], [], [] |> Enum.reverse
  end

  # defp dfs(:none, _), do: []
  # defp dfs(%ExTree{value: value, left: :none, right: :none}, _), do: [value]
  # defp dfs(%ExTree{value: value, left: left, right: right}, order) do
  #   case order do
  #     :pre_order ->
  #       [value] ++ dfs(left, order) ++ dfs(right, order)
  #     :in_order ->
  #       dfs(left, order) ++ [value] ++ dfs(right, order)
  #     :post_order ->
  #       dfs(left, order) ++ dfs(right, order) ++ [value]
  #   end
  # end

  defp dfs_tail(:none, _order, acc, [], []), do: acc
  defp dfs_tail(:none, _order, acc, [], tobe_appended), do: acc ++ tobe_appended
  # defp dfs_tail(:none, order, acc, tobe_searched, tobe_appended) do
  #   dfs_tail(tobe_searched, order, acc, [], tobe_appended)
  # end
  defp dfs_tail(
    :none, :pre_order = order, acc,
    [first_tobe_searched|rest_tobe_searched],
    tobe_appended)
  do
    # Means that we must have already considered the value,
    # Thus we need to consider tobe_searched first node and go from there
    dfs_tail(first_tobe_searched, order, acc, rest_tobe_searched, tobe_appended)
  end
  defp dfs_tail(
    :none, :in_order = order, acc,
    [first_tobe_searched|rest_tobe_searched],
    [first_tobe_appended|rest_tobe_appended])
  do
    # First append last captured node (there should be one at least) to the acc
    # then start iterating with the first to be searched node in the list
    dfs_tail(first_tobe_searched, order, [first_tobe_appended|acc], rest_tobe_searched, rest_tobe_appended)
  end
  defp dfs_tail(
    :none, :post_order = order, acc,
    [first_tobe_searched|rest_tobe_searched],
    tobe_appended
  )
  do
    # In this case all the values are to be appended when there is nothing to search for
    # so just go ahead iterating the first node to search in the list
    dfs_tail(first_tobe_searched, order, acc, rest_tobe_searched, tobe_appended)
  end
  defp dfs_tail(
    %ExTree{value: value, left: left, right: right},
    order, acc, tobe_searched, tobe_appended)
  do
    case order do
      :pre_order ->
        dfs_tail(left, order, [value|acc], [right|tobe_searched], tobe_appended)
      :in_order ->
        dfs_tail(left, order, acc, [right|tobe_searched], [value|tobe_appended])
      :post_order ->
        dfs_tail(left, order, acc, [right|tobe_searched], [value|tobe_appended])
    end
  end

  defp children(list) do
    list |> Enum.map(
    fn x ->
      case x do
        %ExTree{left: :none, right: :none} -> []
        %ExTree{left: left, right: :none} -> left
        %ExTree{left: :none, right: right} -> right
        %ExTree{left: left, right: right} -> [left, right]
        _ -> []
      end
    end)
    |> List.flatten
  end

  defp children_with_position(list) do
    list |> Enum.map(
    fn {level, offset, min_offset, step, tree} ->
      IO.puts "offset #{offset} min_offset #{min_offset} step #{step}"
      next_step = step - 1
      left_offset = offset - step
      case tree do
        :none -> []
        %ExTree{left: :none, right: :none} -> []
        %ExTree{left: :none, right: right} -> [{level + 1, offset + step, min_offset, next_step, right}]
        %ExTree{left: left, right: :none} -> [{level + 1, left_offset, if(left_offset < min_offset, do: left_offset, else: min_offset), next_step, left}]
        %ExTree{left: left, right: right} -> [{level + 1, left_offset, if(left_offset < min_offset, do: left_offset, else: min_offset), next_step, left}, {level + 1, offset + step, min_offset, next_step, right}]
        _ -> []
      end
    end
    )
    |> List.flatten
  end

  # defp extract_min_offset([[{_level, _offset, min_offset, _step, _tree}|_t]|_tl]) do
  #   min_offset
  # end
  # defp extract_min_offset(_), do: -1

  @doc """
  Performs a breadht-first search in the given 'tree'.
  The nodes values are returned in the form of a list.
  """

  @spec breadth_first_search(%ExTree{} | :none) :: nonempty_list(any)

  def breadth_first_search(tree) do
    [tree] |> bfs_tail([]) |> Enum.map(fn (%ExTree{value: value}) -> value end)
  end

  # defp bfs([]), do: []
  # defp bfs(list) do
  #   list ++ bfs(childern(list))
  # end

  defp bfs_tail([], acc), do: acc |> Enum.reverse |> List.flatten
  defp bfs_tail(list, acc) do
    list |> children |> bfs_tail([list|acc])
  end

  @doc """
  Determines whether the 'node_value' exists in the 'tree'.
  """

  @spec exists?(%ExTree{} | :none, any) :: boolean

  def exists?(tree, search_value) do
    e tree, search_value
  end

  defp e(:none, _), do: false
  defp e(%ExTree{value: search_value}, search_value), do: true
  defp e(%ExTree{left: left, right: right, value: value}, search_value) do
    if search_value < value do
      e left, search_value
    else
      e right, search_value
    end
  end

  @doc """
  Determines how many occurances there are in the tree of a given value.
  """

  @spec how_many(%ExTree{} | :none, any) :: integer

  def how_many(tree, value) do
    d tree, value, 0
  end

  defp d(:none, _value, count), do: count
  defp d(%ExTree{value: node_value, left: left, right: right}, value, count) do
    cond do
      value < node_value ->
        d left, value, count
      value > node_value ->
        d right, value, count
      value == node_value ->
        d right, value, count + 1
    end
  end

  @doc """
  Prints the tree in an indented fashion.
  """

  @spec tree_positioned_list(:none | %ExTree{}) :: list({integer, integer, any})

  def tree_positioned_list(tree) do
    tpl [{0, 0, 0, tree_height(tree), tree}], []
  end

  defp tpl([], res), do: {res |> Enum.reverse, res |> List.flatten |> Enum.map(fn {_level, _offset, min_offset, _step, _tree} -> min_offset end) |> Enum.min}
  defp tpl(list, res) do
    list |> children_with_position |> tpl([list|res])
  end

  defp tpl_to_string_list(list, min_offset) do
    IO.puts "Min offset: #{min_offset}"
    list |> Enum.map(
    fn layer_list ->
      {string_list, _offset} =
      layer_list |> Enum.reduce(
      {[], nil},
      fn ({level, offset, _min_offset, step, %ExTree{value: value}}, {res, last_offset}) ->
        padding_count =
        case last_offset do
          nil ->
            offset - min_offset
          _ ->
            offset - last_offset
        end
        value_string = value |> to_string
        len = value_string |> String.length
        {[value_string |> String.rjust(len + padding_count + 1)|res], offset}
      end
      )
      string_list |> Enum.reverse |> Enum.join
    end
    )
  end

  defp render_tpl({tpl_list, min_offset}) do
    tpl_to_string_list(tpl_list, min_offset)
    |> Enum.each(&IO.puts/1)
  end

  @doc """
  Renders the tree to the STD IO.
  """

  @spec render_tree(%ExTree{}) :: integer

  def render_tree(tree) do
    tree |> tree_positioned_list |> render_tpl
  end

end
