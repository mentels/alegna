defmodule Alegna.TreeTest do
  use ExUnit.Case
  doctest Alegna.Tree

  alias Alegna.Tree
  alias Alegna.Tree.{Node, Leaf}

  describe "tree construction" do
    test "creates a new tree which is empty" do
      assert %Tree{} = Tree.new()
      assert Tree.new() |> Tree.empty?()
    end

    test "adds a value to an empty tree" do
      {tree, hash} = Tree.new() |> Tree.add_node(value())
      assert %Tree{size: 1, root: %Leaf{hash: ^hash}} = tree
    end

    test "adds two values to an empty tree" do
      #    h1+h2
      #     /  \
      #    h1  h2

      {tree, [hash2, hash1]} = tree(2)

      node_hash = hash1 <> hash2
      assert %Tree{size: 3, root: r} = tree

      assert %Node{
               height: 1,
               hash: ^node_hash,
               left: %Leaf{hash: ^hash1},
               right: %Leaf{hash: ^hash2}
             } = tree.root
    end

    test "adds three values to an empty tree" do
      #    h1+h2+h3
      #      /   \
      #    h1+h2 h3
      #     /  \
      #    h1  h2

      {tree, [hash3, hash2, hash1]} = tree(3)

      root_hash = hash1 <> hash2 <> hash3
      assert %Tree{size: 5} = tree

      assert %Node{height: 2, hash: ^root_hash, left: %Node{}, right: %Leaf{hash: ^hash3}} =
               tree.root

      l_root_hash = hash1 <> hash2

      assert %Node{
               height: 1,
               hash: ^l_root_hash,
               left: %Leaf{hash: ^hash1},
               right: %Leaf{hash: ^hash2}
             } = tree.root.left
    end

    test "adds four values to an empty tree" do
      #   h1+h2+h3+h4
      #    /       \
      #  h1+h2   h3+h4
      #  /   \   /   \
      # h1   h2 h3   h4

      {tree, [hash4, hash3, hash2, hash1]} = tree(4)

      assert %Tree{size: 7} = tree
      root_hash = hash1 <> hash2 <> hash3 <> hash4
      assert %Node{height: 2, hash: ^root_hash, left: %Node{}, right: %Node{}} = tree.root
      left_hash = hash1 <> hash2

      assert %Node{
               height: 1,
               hash: ^left_hash,
               left: %Leaf{hash: ^hash1},
               right: %Leaf{hash: ^hash2}
             } = tree.root.left

      right_hash = hash3 <> hash4

      assert %Node{
               height: 1,
               hash: ^right_hash,
               left: %Leaf{hash: ^hash3},
               right: %Leaf{hash: ^hash4}
             } = tree.root.right
    end

    test "adds 7 values to an empty tree" do
      #   h1+h2+h3+h4+h5+h6+h7
      #         /          \
      #   h1+h2+h3+h4     h5+h6+h6
      #    /       \       /    \
      #  h1+h2   h3+h4   h5+h6  h7
      #  /   \   /   \   /  \
      # h1   h2 h3   h4 h5  h6
      # assert only the right sub-tree

      {tree, hashes = [hash7, hash6, hash5 | _]} = tree(7)

      assert %Tree{size: 13} = tree

      root_hash =
        hashes
        |> Enum.reverse()
        |> Enum.join()

      assert %Node{height: 3, hash: ^root_hash, left: %Node{}, right: %Node{}} = tree.root

      # right sub-tree
      right_hash = hash5 <> hash6 <> hash7

      assert %Node{height: 2, hash: ^right_hash, left: %Node{}, right: %Leaf{hash: ^hash7}} =
               tree.root.right

      left_hash = hash5 <> hash6

      assert %Node{
               height: 1,
               hash: ^left_hash,
               left: %Leaf{hash: hash5},
               right: %Leaf{hash: hash6}
             } = tree.root.right.left
    end
  end

  defp tree(size) when size > 0 do
    Enum.reduce(
      1..size,
      {Tree.new(), _hashes = []},
      fn _idx, {tree, hashes} ->
        {tree, hash} = Tree.add_node(tree, value())
        {tree, [hash | hashes]}
      end
    )
  end

  defp value(), do: Enum.random(0..9) |> to_string()
end
