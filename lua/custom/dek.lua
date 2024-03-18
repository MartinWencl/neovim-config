require "lib.env"

-- Sets the correct encoding for these files
-- cp1250 encoding for .pas, .dfm, .proj, .dproj 
-- NOTE: Reopens the file with the correct encodinga
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = {"*.pas", "*.dfm", "*.proj", "*.dproj"},
  group = vim.api.nvim_create_augroup("DEKEncoding", { clear = true }),
  callback = function ()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_call(bufnr, function ()
      vim.cmd("edit! ++enc=cp1250")
    end)
  end
})

-- Searching trough project notes
local path_to_notes = vim.fn.expand("~") .. "/Notes/work/projects"
vim.api.nvim_create_user_command("DEKSearchNote", function () require("telescope.builtin").find_files({ search_dirs = { path_to_notes } }) end, {})

-- DEKSearch
-- Paths to search in
local path_to_repo = "/mnt/c/Vyvoj/Projekty-developer/ripgrep/"
local excluded = { ".svn", "Zdroje", "zzzDCU", "zzzHelp" }

--- Function that returns a list of directories, from a given path, while excluding given directory names
---@param path string given path to repo, using linux conventions
---@param excluded_names table list of names that will be excluded from the resulting list
local get_repo_directories = function(path, excluded_names)
  local dirs_in_repo = vim.fs.dir(path)
  local dirs = {}

  for name, type in dirs_in_repo do
    if type ~= "directory" then goto continue end
    if vim.list_contains(excluded_names, name) then goto continue end

    table.insert(dirs, name)
    ::continue::
  end
  return dirs
end

-- mode for telescope
local mode = ""

-- TODO: find out if there is a way to pass mode as param, instead of "global" var `mode`
-- currently cant change params on this func cause the `vim.select` expects a function with two parameters
on_dir_select = function(item, lnum)
  if item == nil then return end

  if mode == "live_grep" then
    require("telescope.builtin").live_grep({ cwd = path_to_repo .. item, file_format = "cp1250" })
  elseif mode == "find_files" then
    require("telescope.builtin").find_files({ cwd = path_to_repo .. item, file_format = "cp1250" })
  else
    vim.notify("Telescope mode not recognized or implemented!", vim.log.levels.ERROR)
  end
end

--- Checks the ripgrep repo for directories, asks to select one and calls `on_dir_select`
---  - expects the var `mode` to be set
local select_dir_to_search = function()
  if not EnvLib:CheckLocation("work") then
    vim.notify("Not at work!", vim.log.levels.ERROR)
  end

  if not mode then
    vim.notify("Telescope mode is not set!", vim.log.levels.ERROR)
    return
  end

  local dirs = get_repo_directories(path_to_repo, excluded)

  vim.ui.select(dirs, { prompt = "Select a folder: " }, on_dir_select)
end

-- Setting the keymaps for the mutliple search modes
local use_live_grep = function()
  mode = "live_grep"
  select_dir_to_search()
end
vim.api.nvim_create_user_command("DEKSearchGrep", use_live_grep, {})

local use_find_files = function()
  mode = "find_files"
  select_dir_to_search()
end
vim.api.nvim_create_user_command("DEKSearchFiles", use_find_files, {})

-- Neorg config for DEK
local dirman = require('neorg').modules.get_module("core.dirman")

-- Creating new notes for ITAs
local new_ita = function()
  vim.ui.input({ prompt = "New ITA-" }, function(id)
    if id == nil or dirman == nil then
      return
    end

    local workspace_name = "work"
    local workspace_path = dirman.get_workspace(workspace_name)
    local projects_folder = "projects/"
    local ita_folder = "ITA-" .. id
    local template = vim.split(
      [[
@document.meta
title: ]] .. " " .. ita_folder .. "\n" .. [[
authors: martinw
categories: ITA
@end ]]
      .. "\n\n" .. "* " .. ita_folder .. "\n\n" ..
    [[
** Zadání:
   - zde vypsat (ideálně v bodech) o čem v projektu jde

** Části kódu kde se co děje
  - *DEKLibN/Unita* - *Class/Metoda* - proč co jak

** TODO:
   - (?) zamysli se nad prací a vypiš základní kroky 
    ]]
      , "\n")

    -- Creates the ITA dir and index file
    vim.fn.mkdir(workspace_path .. "/" .. projects_folder .. ita_folder)
    dirman.create_file(projects_folder .. ita_folder .. "/" .. "index.norg", workspace_name)

    -- Writes the template to the new index file
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, template)
  end)
end

-- New ITA note in the ~/notes/projects/ dir
vim.api.nvim_create_user_command("DEKNewNote", new_ita, {})
