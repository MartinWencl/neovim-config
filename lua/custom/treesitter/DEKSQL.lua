require "lib.treesitter"
-- Imbedded SQL formatting for csharp
-- works specificaly with DEKLib

-- FIX: looks like the formatting itself is broken, check text before/after, load into python repl
local sql_query = vim.treesitter.query.parse(
  "c_sharp",
  [[
  (using_statement
      (variable_declaration
       type: (identifier) @_name (#eq? @_name "DEKQuery")
      )
      (block (expression_statement ( assignment_expression
           left: (member_access_expression name: (identifier) @_text (#eq? @_text "CommandText"))
           right: (verbatim_string_literal) @sql_str)
      ))
  )
  ]]
)

local run_formatter = function (text)
  -- TODO: change to a vim job so its non-blocking
  local str_output = vim.fn.system(vim.fn.stdpath("config") .. "/support/sqlformat.py", text)
  vim.notify(str_output, vim.log.levels.WARN)
  if str_output == nil then
    return ""
  end

  local output = vim.split(str_output, '\n')
  return output
end

local format_sql = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].filetype ~= "cs" then
    vim.notify("Can only be used in c#!", vim.log.levels.WARN)
  end

  local root = TreesitterLib:get_root(bufnr, "c_sharp")
  local changes = {}

  for id, node in sql_query:iter_captures(root, bufnr, 0, -1) do
    local name = sql_query.captures[id]

    if name == "sql_str" then
      -- { start row, start col, end row, end col}
      local range = { node:range() }
      -- local indentation = string.rep(" ", range[2])

      local formatted = run_formatter(vim.treesitter.get_node_text(node, bufnr))

      -- for idx, line in ipairs(formatted) do
      --   formatted[idx] = indentation .. line
      -- end

      -- always insert at position one -> pushes others to lower index -> reversed order
      table.insert(changes, 1, {
        start = range[1] + 1,
        final = range[3],
        formatted = formatted
      })

      for _, change in ipairs(changes) do
        vim.api.nvim_buf_set_lines(bufnr, change.start, change.final, false, change.formatted)
      end
    end
  end
end

-- TODO: Enable again, cant use t as group leader
-- vim.keymap.set("n", "<leader>tf", format_sql, { desc = "Format" })
