defmodule ByoxApi.Topics.TopicTest do
  use ExUnit.Case

  alias ByoxApi.Topics.Topic

  import AntlUtilsEcto.Changeset

  describe "changeset/2" do
    test "invalid changeset with missing title" do
      params = %{}
      changeset = Topic.changeset(%Topic{}, params)

      refute changeset.valid?
      assert %{title: ["can't be blank"]} = errors_on(changeset)
    end

    test "valid changeset" do
      params = %{title: "Some Title"}
      changeset = Topic.changeset(%Topic{}, params)

      assert changeset.valid?
    end
  end

end
