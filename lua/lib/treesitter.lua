--- Metatable containing all the treesitter helper functions
TreesitterLib = {}

--- Parses the given buffer, using the language parser and returns the root node.
--- @param bufnr number bufnr of the buffer to be parsed.
--- @param lang string treesitter parser to be used.
--- @return TSNode root the root node of the parsed tree.
function TreesitterLib:get_root(bufnr, lang)
  local parser = vim.treesitter.get_parser(bufnr, lang, {})
  local tree = parser:parse()[1]
  return tree:root()
end

