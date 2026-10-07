-- Local plugin: Play Framework conf/routes support.
--
-- There is no upstream plugin for routes files (no tree-sitter parser, no LSP
-- server, no formatter exists), so this file IS the plugin: filetype
-- detection, :PlayRoutesAlign, gd controller jump and format-on-save.
-- Highlight rules live in syntax/play2-routes.vim, which Vim's own Syntax
-- handler sources after its internal `syn clear` (the only order-safe way).
--
-- NOTE: top-level code below runs when lazy.nvim imports plugin specs at
-- startup, i.e. before initial file args are read, so `nvim conf/routes`
-- is detected correctly. Returns an empty spec because there is no remote
-- repo to install.

do
  vim.filetype.add({
    filename = { ["routes"] = "play2-routes" },
    extension = { ["routes"] = "play2-routes" },
  })

  -- Own group so re-sourcing never stacks duplicate autocmds.
  local proup = vim.api.nvim_create_augroup("play2_routes", { clear = true })

  if vim.g.play_routes_format_on_save == nil then
    vim.g.play_routes_format_on_save = true
  end

  ---PATH columns wider than this overflow instead of stretching the file.
  local MAX_PATH_WIDTH = 60

  ---Align METHOD / PATH / ACTION columns with one shared width for the
  ---whole range (matches the file's uniform hand-aligned style).
  ---Leading indentation (if any) is preserved; comment, blank and
  ---`->` include lines are left untouched.
  ---@param buf integer target buffer handle
  ---@param first integer 1-based start line
  ---@param last integer 1-based end line (inclusive)
  local function align_routes(buf, first, last)
    local lines = vim.api.nvim_buf_get_lines(buf, first - 1, last, false)
    local rows = {}
    local max_method = 0
    local max_path = 0
    for i, line in ipairs(lines) do
      local stripped = line:match("^%s*(.-)%s*$")
      if stripped == "" or stripped:sub(1, 1) == "#" or stripped:sub(1, 2) == "->" then
        rows[i] = false
      else
        local method, path, action = stripped:match("^(%u+)%s+(%S+)%s+(%S.*)$")
        if method and path and action then
          max_method = math.max(max_method, #method)
          max_path = math.max(max_path, #path)
          rows[i] = { indent = line:match("^(%s*)"), method = method, path = path, action = action }
        else
          rows[i] = false
        end
      end
    end
    if max_method == 0 then
      vim.notify("PlayRoutesAlign: no route lines in range", vim.log.levels.INFO)
      return
    end
    if max_path > MAX_PATH_WIDTH then
      max_path = MAX_PATH_WIDTH
    end
    -- Only touch the buffer when something actually changes, so no-op saves
    -- (and ranges that are already aligned) don't pollute undo history.
    local dirty = false
    for i, row in ipairs(rows) do
      if row then
        local new_line = row.indent
          .. string.format("%-" .. max_method .. "s  %-" .. max_path .. "s  %s", row.method, row.path, row.action)
        if new_line ~= lines[i] then
          lines[i] = new_line
          dirty = true
        end
      end
    end
    if not dirty then
      return
    end
    vim.api.nvim_buf_set_lines(buf, first - 1, last, false, lines)
  end

  ---Jump from the `controllers.xxx.Yyy.action(...)` reference on the current
  ---line to `app/controllers/xxx/Yyy.java` (`.scala` fallback), landing on
  ---the action method. The project root is found by searching upward for the
  ---`app/controllers` tree, so it also works in nested modules.
  local function goto_controller()
    local line = vim.api.nvim_get_current_line()
    local fqn = line:match("(controllers%.[%w_%.]+)")
    if not fqn then
      vim.notify("No controllers.* reference on this line", vim.log.levels.WARN)
      return
    end
    local parts = vim.split(fqn, ".", { plain = true })
    local method = table.remove(parts)
    local rel = "app/" .. table.concat(parts, "/")
    local current_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    local found = vim.fs.find(
      { rel .. ".java", rel .. ".scala" },
      { upward = true, stop = vim.uv.os_homedir(), path = current_dir }
    )
    local target = found and found[1]
    if not target then
      vim.notify("Controller not found: " .. rel, vim.log.levels.ERROR)
      return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(target))
    if method and not vim.fn.search("\\<" .. method .. "\\>\\s*(", "w") then
      vim.notify(
        "Opened " .. vim.fn.fnamemodify(target, ":t") .. " (method " .. method .. " not found)",
        vim.log.levels.INFO
      )
    end
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "play2-routes",
    group = proup,
    desc = "Play routes: align + controller jump (highlight: syntax/play2-routes.vim)",
    callback = function(args)
      if vim.b[args.buf].did_play2_routes then
        return
      end
      vim.b[args.buf].did_play2_routes = true
      vim.bo[args.buf].commentstring = "# %s"
      vim.bo[args.buf].expandtab = true
      vim.bo[args.buf].shiftwidth = 2
      vim.bo[args.buf].tabstop = 2
      vim.bo[args.buf].softtabstop = 2
      vim.api.nvim_buf_create_user_command(args.buf, "PlayRoutesAlign", function(opts)
        align_routes(args.buf, opts.line1, opts.line2)
      end, { range = "%", desc = "Align Play routes METHOD/PATH/ACTION columns" })
      local map = function(mode, lhs, rhs, description)
        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = description, silent = true })
      end
      map("n", "gd", goto_controller, "Go to Play controller")
      map({ "n", "v" }, "<leader>cf", ":PlayRoutesAlign<CR>", "Align Play routes")
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        desc = "Auto-align Play routes on save",
        callback = function()
          if not vim.g.play_routes_format_on_save then
            return
          end
          local view = vim.fn.winsaveview()
          align_routes(args.buf, 1, vim.api.nvim_buf_line_count(args.buf))
          vim.fn.winrestview(view)
        end,
      })
    end,
  })
end

return {}
