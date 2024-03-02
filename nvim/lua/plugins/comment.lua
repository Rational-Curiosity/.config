return {
  {
    "jbyuki/venn.nvim",
    keys = { { "<leader>B", ":VBox<cr>", mode = "x", desc = "VBox" } },
    cmd = { "VBox" },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "x" }, desc = "Comment" },
      { "gb", mode = { "n", "x" }, desc = "Comment block" },
    },
    config = function()
      require("Comment").setup()
    end,
  },
}
