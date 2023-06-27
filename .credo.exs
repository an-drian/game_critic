%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["apps/", "/config"],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/priv/"]
      },
      plugins: [],
      requires: [],
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Design.AliasUsage, false},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Readability.AliasOrder, false}
      ]
    }
  ]
}
