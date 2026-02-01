/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int gappih    = 20;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 30;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const unsigned int snap      = 32;       /* snap pixel */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "Hack Nerd Font:size=16" };
static const char dmenufont[]       = "Hack Nerd Font:size=16";

// Opacity levels
static const unsigned int baralpha = 0xb0;      // opacity
static const unsigned int borderalpha = OPAQUE; // Fully opaque (make sure OPAQUE is defined as 0xff)

/* default colors used if xrdb is not loaded */
static const char normbgcolor[]           = "#076678"; // blue
static const char selbgcolor[]            = "#b57614"; // yellow

static const char normfgcolor[]           = "#282828"; // black
static const char selfgcolor[]            = "#282828";
static const char normbordercolor[]       = "#282828";
static const char selbordercolor[]        = "#fe8019"; // orange

static const char *colors[][3] = {
       /*               fg           bg           border   */
		[SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
		[SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
		/* for bar --> {text, background, null} */
        [SchemeStatus]  = { normfgcolor, normbgcolor,  normbgcolor }, /* status R */
		[SchemeTagsSel]  = { selfgcolor, selbgcolor, selbgcolor }, /* tag L selected */
		[SchemeTagsNorm]  = { normfgcolor, normbgcolor,  normbgcolor }, /* tag L unselected */
		[SchemeInfoSel]  = { selfgcolor, selbgcolor, selbgcolor  }, /* info M selected */
		[SchemeInfoNorm]  = { normfgcolor, normbgcolor,  normbgcolor  }, /* info M unselected */
};

// Transparency settings: fg, bg, border (values: 0x00 transparent to 0xff opaque)
static const unsigned int alphas[][3] = {
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
    [SchemeSel] = { OPAQUE, baralpha, borderalpha },
    [SchemeStatus]  = { OPAQUE, baralpha, borderalpha },
    [SchemeTagsSel]  = { OPAQUE, baralpha, borderalpha },
    [SchemeTagsNorm]  = { OPAQUE, baralpha, borderalpha },
    [SchemeInfoSel]  = { OPAQUE, baralpha, borderalpha },
    [SchemeInfoNorm]  = { OPAQUE, baralpha, borderalpha },
};


/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                      instance             title     tags mask  isfloating  isterminal  noswallow  monitor */
	{ "Gimp",                     NULL,                NULL,     0,         1,          0,           0,        -1 },
	{ "Firefox",                  NULL,                NULL,     1 << 8,    0,          0,          -1,        -1 },
	{ "St",                       NULL,                NULL,     0,         0,          1,           0,        -1 },
	{ "discord",                  NULL,                NULL,     0,         0,          0,           0,        1 },
	{ "signal-desktop",                  NULL,                NULL,     0,         0,          0,           0,        1 },
	{ "Lutris",                   "net.lutris.Lutris", NULL,     1 << 2,    0,          0,           0,        0 },
    { "heroesofthestorm_x64.exe", NULL,                NULL,     1 << 2,    1,          -1,          0,        0 },

	{ NULL,                       NULL,  "Event Tester",  0,    0,          0,           1,        -1 }, /* xev */
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define SUPER Mod4Mask
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
#define STACKKEYS(MOD,ACTION) \
	{ MOD, XK_j,     ACTION##stack, {.i = INC(+1) } }, \
	{ MOD, XK_l,     ACTION##stack, {.i = INC(+1) } }, \
	{ MOD, XK_Tab,     ACTION##stack, {.i = INC(+1) } }, \
	{ MOD, XK_k,     ACTION##stack, {.i = INC(-1) } }, \
	{ MOD, XK_h,     ACTION##stack, {.i = INC(-1) } }, \
	{ MOD, XK_grave, ACTION##stack, {.i = PREVSEL } },// \
//	{ MOD, XK_q,     ACTION##stack, {.i = 0 } }, \
	{ MOD, XK_a,     ACTION##stack, {.i = 1 } }, \
	{ MOD, XK_z,     ACTION##stack, {.i = 2 } }, \
	{ MOD, XK_x,     ACTION##stack, {.i = -1 } },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)  (Arg){ .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"
#define BROWSER "firefox"

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normbordercolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *lockcmd[]  = { "slock", NULL };
static const char *screenshotcmd[] = { "/bin/sh", "-c", "maim -s | xclip -selection clipboard -t image/png -i", NULL };
static const char *poweroffcmd[] = { "/bin/sh", "-c", "poweroff", NULL };


// change keyboard layouts (us int vs us)
static const char *kbdtogglecmd[] = { "/bin/sh", "-c",
    "variant=$(setxkbmap -query | grep variant | awk '{print $2}'); "
    "if [ \"$variant\" = \"intl\" ]; then "
    "setxkbmap us; "
    "else "
    "setxkbmap us -variant intl; "
    "fi",
NULL };


static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	// { MODKEY,                       XK_b,      togglebar,      {0} },
	STACKKEYS(MODKEY,                          focus)
	STACKKEYS(MODKEY|ShiftMask,                push)
	// { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	// { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	// { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	// { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	// { MODKEY|ShiftMask,             XK_h,      setcfact,       {.f = +0.25} },
	// { MODKEY|ShiftMask,             XK_l,      setcfact,       {.f = -0.25} },
	// { MODKEY|ShiftMask,             XK_o,      setcfact,       {.f =  0.00} },
	{ MODKEY,                       XK_Return, zoom,           {0} },

    /* vanity gaps */
	// { MODKEY|Mod4Mask,              XK_u,      incrgaps,       {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_i,      incrigaps,      {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_o,      incrogaps,      {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_0,      togglegaps,     {0} },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },

	// { MODKEY,                    XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_m,      togglelayout,   {0} },
	{ MODKEY|ShiftMask,             XK_f,      fullscreen,     {0} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmonandfocus, {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmonandfocus, {.i = +1 } },
	{ MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {0} },

    // change keyboard layout
	{ ControlMask,                     XK_k,        spawn,      { .v= kbdtogglecmd} },
    // screen lock
	{ MODKEY|ControlMask|ShiftMask,    XK_l,        spawn,      { .v= lockcmd} },
    // take screenshot (print screen   shot)
	{ 0,                               XK_Print,    spawn,      { .v= screenshotcmd} },
	{ MODKEY|ControlMask|ShiftMask,    XK_p,        spawn,      {.v = poweroffcmd } },

    /* application bindings */
    { MODKEY,			XK_m,          spawn,      {.v = (const char*[]){ "st", "-e", "rmpc", NULL } } },
    { MODKEY,			XK_w,          spawn,      {.v = (const char*[]){ BROWSER, NULL } } },
    { MODKEY,			XK_n,          spawn,      {.v = (const char*[]){ "st", "-e", "nvim", NULL } } },
    { MODKEY,			XK_o,          spawn,      {.v = (const char*[]){ "st", "-e", "zsh", "-ic", "ranger", NULL } } },
    { MODKEY|ShiftMask,	XK_h,          spawn,      {.v = (const char*[]){ "st", "-e", "htop", NULL } } },
    { MODKEY,			XK_d,          spawn,      {.v = (const char*[]){ "discord", NULL } } },
    { MODKEY,			XK_s,          spawn,      {.v = (const char*[]){ "signal-desktop", NULL } } },
    { MODKEY,	        XK_g,          spawngames, {0} },


    /* tag keys */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)

    /* fn keys */
    { 0,                            XF86XK_KbdBrightnessUp,     spawn,      SHCMD("/home/gmelodie/dotfiles/scripts/kblight.sh") },
    { 0,                            XF86XK_AudioMute,     spawn,      SHCMD("wpctl set-mute @DEFAULT_SINK@ toggle; pkill -RTMIN+10 dwmblocks") },
    { 0,                            XF86XK_AudioLowerVolume,     spawn,      SHCMD("wpctl set-volume @DEFAULT_SINK@ 5%-; pkill -RTMIN+10 dwmblocks") },
    { 0,                            XF86XK_AudioRaiseVolume,     spawn,      SHCMD("wpctl set-volume @DEFAULT_SINK@ 5%+; pkill -RTMIN+10 dwmblocks") },
    { 0,                            XF86XK_AudioPrev,     spawn,      SHCMD("playerctl previous") },
    { 0,                            XF86XK_AudioNext,     spawn,      SHCMD("playerctl next") },
    { 0,                            XF86XK_AudioPlay,     spawn,      SHCMD("playerctl play-pause") },
    { 0,                            XF86XK_MonBrightnessUp,     spawn,      SHCMD("brightnessctl set 5%+") },
    { 0,                            XF86XK_MonBrightnessDown,   spawn,      SHCMD("brightnessctl set 5%-") }
    // f11 print screenshot
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
    { ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
    { ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
