--[[============================================================================
org.oscillity.Babbler.xrnx/main.lua
============================================================================]]--


require "Babbler"



--------------------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------------------

-- hello_world

function hello_world()

  local pool = loadfile('data/cumbria_fells.lua')
  print("pool",pool)
  local pool_names = pool()
  print("pool_names",pool_names)

  local babbler = Babbler(pool_names)
  print("babbler",babbler)

  local vb = renoise.ViewBuilder()

  local dialog_title = "Babbler"

  local dialog_content = vb:column{
    margin = 10,
    spacing = 3,
    vb:text {
      text = "Press the button to \ngenerate a random word",
      width = "100%",
      align = "center",
    },
    vb:row{
      style = "border",
      width = 300,
      margin = 10,
      vb:horizontal_aligner{
        mode = "center",
        vb:textfield{
          id = "babble_output",
          --font = "big",
          text = "",
          align = "center",
          width = 150,
        },
      },
    },
    vb:horizontal_aligner{
      mode = "center",
      vb:button{
        text = "Generate",
        height = 30,
        width = 80,
        notifier = function()
          print("babbler",babbler)
          local str = babbler:generate()
          vb.views["babble_output"].text = str
        end
      }
    }
  }

  renoise.app():show_custom_dialog(dialog_title, dialog_content)


end

--------------------------------------------------------------------------------
-- menu entries
--------------------------------------------------------------------------------

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Babbler",
  invoke = function() hello_world() end 
}

