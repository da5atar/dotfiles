-- For surround operations
--
-- '*' denotes cursor position
-- '.' dot repeats the change and jumps to the nearest surround (forward and backwards)
-- "help nvim-surround" for more details
--     Old text                               Command                 New text
-- -------------------------------------------------------------------------------------------------
--     surr*ound_words                        ysiw) or ysiwb                        (surround_words)
--     (surround_words)                       dsb or ds( or ds)                      surround_words
--     surr*ound_words                        ysiw(                                ( surround_words )
--     ( surround_words                       dsb or ds( or ds)                      surround_words
--     surr*ound_words                        ysiw} or ysiwB                        {surround_words}
--     {surround_words}                       ysaB] or ysa{]                       [{surround_words}]
--     [{surround_words}]                     csB)                                 [(surround_words)]
--     [(surround_words)]                     ysa]}                               {[(surround_words)]}
--     {[(surround_words)]}                   cs([ or csb[                       {[[ surround_words ]]}
--     {[[ surround_words ]]}                 csBr or cs}r                       [[[ surround_words ]]]
--     [[[ surround_words ]]]                 csrB or csr}                       [[{ surround_words }]]
--     [[{ surround_words }]]                 dsr or ds[                          [{ surround_words }]
--     [{ surround_words }]                   ds{ and ds]                            surround_words
--     surr*ound_words                        ysiwb or ysaw)                        (surround_words)
--     (surround_words)                       csbt and div id="test"  <div id="test">surround_words</div>
--     <div id="test">surround_words</div>    cst and h1               <h1 id="test">surround_words</h1>
--     <h1 id="test">surround_words</h1>      cst and h2               <h2 id="test">surround_words</h2>
--     <h2 id="test">surround_words</h2>      csT and h3                         <h3>surround_words</h3>
--     <h3>surround_words</h3>                dst                                    surround_words
--     *make strings                          ys$"                                  "make strings"
--     "make*strings"                         cs"*                                  *make strings*
--     **make strings*                        ys$_                                 _*make strings*_
--     _*make*strings*_                       ds_                                   *make strings*
--     *mak*e strings*                        cs*'                                  'make strings'
--     'make*strings'                         cs'`                                  `make strings`
--     `make*strings`                         csq"                                  "make strings"
--     "make*strings"                         dsq                                    make strings
--     delete(functi*on calls)                dsf                                    function calls
--     he*lp nvim-surround                    ys4w"                                 "help nvim-surround"
return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {},
}
