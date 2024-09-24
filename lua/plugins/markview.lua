require("markview").setup({
  modes = { "n", "i", "no", "c" },
  hybrid_modes = { "i", "n" },

  callbacks = {
    on_enable = function(_, win)
      vim.wo[win].conceallevel = 2
      vim.wo[win].concealcursor = "nc"
    end,
  },

  checkboxes = {
    checked = {
      text = "",
      hl = "Green",
    },
    unchecked = {
      text = "",
    },
  },
  headings = {
    heading_1 = {
      style = "icon",
      shift_char = "",
      icon = " ",
      hl = "Red",
    },
    heading_2 = {
      style = "label",
      shift_char = "",
      icon = " ",
      hl = "Orange",
    },
    heading_3 = {
      style = "label",
      shift_char = "",
      icon = " ",
      hl = "Yellow",
    },
    heading_4 = {
      style = "label",
      shift_char = "",
      icon = " ",
      hl = "Green",
    },
    heading_5 = {
      style = "label",
      shift_char = "",
      icon = " ",
      hl = "Blue",
    },
    heading_6 = {
      style = "label",
      shift_char = "",
      icon = " ",
      hl = "Aqua",
    },
  },
  links = {
    hyperlinks = {
      custom = {
        { hl = "Blue", match = "https:", icon = " ", corner_right = " " },
        { hl = "Blue", match = "^http:", icon = " ", corner_right = " " },
        { hl = "Aqua", match = "%.md", icon = "󱅷 " },
      },
    },
  },
  list_items = {
      shift_width = 2,
      indent_size = 3,
  },
})
