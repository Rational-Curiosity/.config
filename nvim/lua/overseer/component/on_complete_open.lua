return {
  params = {
    enter = {
      desc = "See :help enter",
      type = "boolean",
      default = true,
      default_from_task = true,
    },
    direction = {
      desc = "See :help direction",
      type = "enum",
      choices = { "left", "right" },
      default = "left",
    },
  },
  constructor = function(params)
    return {
      on_exit = function(self, task, code)
        if code ~= 0 then
          require('overseer').open(params)
        end
      end
    }
  end,
}
