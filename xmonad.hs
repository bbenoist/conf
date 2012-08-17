import System.IO
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)

import qualified Data.Map           as M
import qualified XMonad.StackSet    as W

main = do
        status <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
        xmonad $ withUrgencyHook NoUrgencyHook $ ewmh azertyConfig
          { terminal = "xterm"
          , modMask = mod4Mask -- Use super key instead of Alt
          , borderWidth = 2
          , normalBorderColor = "#dddddd"
          , focusedBorderColor = "#ff0000"
          , workspaces = myWorkspaces
          , handleEventHook = fullscreenEventHook
          , layoutHook = myLayoutHook
          , manageHook = manageDocks <+> myManageHook
                          <+> manageHook defaultConfig
          , logHook = myLogHook status
          , mouseBindings = myMouseBindings
          }
          `additionalKeysP` myKeys


-- Workspaces
myWorkspaces = ["1","2","3","4","5","6","7","8","9","0"]

-- Window management
myManageHook = composeAll
        [
        ]

-- Xmobar
myLogHook h = dynamicLogWithPP $ myXmobarPP { ppOutput = hPutStrLn h }

myXmobarPP = xmobarPP
    { ppCurrent = xmobarColor "#3399ff" "" . wrap " " " "
    , ppHidden  = xmobarColor "#dddddd" "" . wrap " " " "
    , ppHiddenNoWindows = \x -> "" -- xmobarColor "#777777" "" . wrap " " " "
    , ppUrgent  = xmobarColor "#ff0000" "" . wrap " " " "
    , ppSep     = "     "
    , ppLayout  = xmobarColor "#aaaaaa" "" . wrap "·" "·"
    , ppTitle   = xmobarColor "#ffffff" "" . shorten 25
    }

-- Layouts
myLayoutHook = avoidStruts $ minimize $ maximize (tiled ||| Mirror tiled ||| Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- Key bindings. Add, modify or remove key bindings here.T
myKeys = [
    -- Toggle last workspace (super-tab)
    ("M1-<Tab>", toggleWS),
    -- Go to next workspace
    ("M-<Right>", nextWS),
    -- Go to prev
    ("M-<Left>", prevWS),
    -- Move client to next workspace
    ("M-S-<Right>", shiftToNext),
    -- Move client to prev workspace
    ("M-S-<Left>", shiftToPrev),
    -- Shrink the master area
    ("M-<KP_Add>", sendMessage Shrink),
    -- Expand the master area
    ("M-<KP_Subtract>", sendMessage Expand),
    -- Shrink the master area
    ("M-S-h", sendMessage Shrink),
    -- Expand the master area
    ("M-S-l", sendMessage Expand),
    -- App launcher
    ("M-r", spawn "gmrun")
    ]

-- Non-numeric num pad keys, sorted by number
numPadKeys = [ xK_KP_End,  xK_KP_Down,  xK_KP_Page_Down -- 1, 2, 3
             , xK_KP_Left, xK_KP_Begin, xK_KP_Right     -- 4, 5, 6
             , xK_KP_Home, xK_KP_Up,    xK_KP_Page_Up   -- 7, 8, 9
             , xK_KP_Insert] -- 0

-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

