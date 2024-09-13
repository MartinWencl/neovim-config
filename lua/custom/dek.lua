require "lib.env"

-- cp1250 encoding for .pas, .dfm, .proj, .dproj
-- NOTE222: Reopens the file with the correct encodinga
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*.pas", "*.dfm", "*.proj", "*.dproj" },
    group = vim.api.nvim_create_augroup("DEKEncoding", { clear = true }),
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_call(bufnr, function()
            -- Reopens the files with correct encoding
            vim.cmd("edit! ++enc=cp1250")
        end)
    end
})

-- Searching through project notes
local notes_directory_path = vim.fn.expand("~") .. "/notes/projects"
vim.api.nvim_create_user_command("DEKSearchNote",
    function() require("telescope.builtin").find_files({ search_dirs = { notes_directory_path } }) end, {})

-- DEKSearch
-- Paths to search in
local ripgrep_repo_path = "/mnt/c/Vyvoj/Projekty-developer/ripgrep/"
local excluded_directories = { ".svn", "Zdroje", "zzzDCU", "zzzHelp" }

--- Function that returns a list of directories, from a given path, while excluding given directory names
---@param path string given path to repo, using linux conventions
---@param excluded_names table list of names that will be excluded from the resulting list
local get_repo_directories = function(path, excluded_names)
    local dirs_in_repo = vim.fs.dir(path)
    local dirs = {}

    for name, type in dirs_in_repo do
        if type ~= "directory" then goto continue end
        if vim.list_contains(excluded_names, name) then
          goto continue
        end

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
        require("telescope.builtin").live_grep({ cwd = ripgrep_repo_path .. item, file_format = "cp1250" })
    elseif mode == "find_files" then
        require("telescope.builtin").find_files({ cwd = ripgrep_repo_path .. item, file_format = "cp1250" })
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

    local dirs = get_repo_directories(ripgrep_repo_path, excluded_directories)

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

        local workspace_name = "main"
        local workspace_path = dirman.get_workspace(workspace_name)
        local projects_folder = "projects/"
        local ita_folder_name = "ITA-" .. id
        local template = vim.split(
      [[
@document.meta
title: ]] .. " " .. ita_folder_name .. "\n" .. [[
authors: martinw
categories: ITA
@end ]]
        .. "\n\n" .. "* " .. ita_folder_name .. "\n\n" ..
      [[
** Zadání:
   - zde vypsat o čem v projektu jde

** Části kódu kde se co děje
  - *DEKLibN/Unita* - *Class/Metoda* - proč co jak

** TODO:
   - ( ) zamysli se nad prací a vypiš základní kroky

** DEK:
*** Ke Kontrole
   - ( ) Aktualizace SVN + Aktuální verze na `vyvoj_projektu`
   - ( ) Zkompiluje
   - ( ) Zkontrolován diff
   - (?) Napsán mail nebo zpráva

*** K Testu
    - ( ) Aktualizace SVN + Aktuální verze
    - ( ) Nahrát všechny moduly co budou v releasu
    - (?) Napsána poznámka programátora
    - (?) Pořadí scriptů
    - (?) Ostatní soubory

*** Ke Commitu
   - ( ) Udělat SVN update
   - ( ) Zkontrolován diff
   - ( ) Zkompiluje
   - ( ) Napsána commit message
   - ( ) Napsán mail s moduly a skripty
   -- (?) Skripty, které lze zveřejnit ihned
    ]], "\n")

        -- Creates the ITA dir and index file
        vim.fn.mkdir(workspace_path .. "/" .. projects_folder .. ita_folder_name)
        dirman.create_file(projects_folder .. ita_folder_name .. "/" .. "index.norg", workspace_name)

        -- Writes the template to the new index file
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, template)
    end)
end

-- New ITA note in the ~/notes/projects/ dir
vim.api.nvim_create_user_command("DEKNewNote", new_ita, {})
