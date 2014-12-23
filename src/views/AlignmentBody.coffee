boneView = require("backbone-childs")
SeqBlock = require "./canvas/CanvasSeqBlock"
LabelBlock = require "./labels/LabelBlock"

module.exports = boneView.extend

  initialize: (data) ->
    @g = data.g

    if true
      labelblock = new LabelBlock {model: @model, g: @g}
      labelblock.ordering = -1
      @addView "labelblock",labelblock

    if @g.vis.get "sequences"
      seqblock = new SeqBlock {model: @model, g: @g}
      seqblock.ordering = 0
      @addView "seqblock",seqblock

    @listenTo @g.zoomer, "change:alignmentHeight", @adjustHeight
    @listenTo @g.columns, "change:hidden", @adjustHeight

  render: ->
    @renderSubviews()
    @el.className = "biojs_msa_albody"
    @el.style.whiteSpace = "nowrap"
    @adjustHeight()
    @

  adjustHeight: ->
    if @g.zoomer.get("alignmentHeight") is "auto"
      # TODO: fix the magic 5
      @el.style.height = (@g.zoomer.get("rowHeight") * @model.length) + 5
    else
      @el.style.height = @g.zoomer.get "alignmentHeight"

    # TODO: 15 is the width of the scrollbar
    @el.style.width = @getWidth() + 15

  getWidth: ->
    width = 0
    if @g.vis.get "labels"
      width += @g.zoomer.get "labelWidth"
    if @g.vis.get "metacell"
      width += @g.zoomer.get "metaWidth"
    if @g.vis.get "sequences"
      width += @g.zoomer.get "alignmentWidth"
    width