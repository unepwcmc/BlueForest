window.Backbone ||= {}
window.Backbone.Views ||= {}

class Backbone.Views.AreaView extends Backbone.View
  template: JST['area']

  events:
    'click #delete-area': 'deleteArea'
    'click #new-polygon': 'toggleDrawing'

  initialize: (options) ->
    @area = options.area
    @area.on('change', @render)

    @showAreaPolygonsView = window.pica.currentWorkspace.currentArea.newShowAreaPolygonsView()
    @showAreaPolygonsView.on("polygonClick", @handlePolygonClick)

    @render()

  toggleDrawing: (event) ->
    if @polygonView?
      @removeNewPolygonView()
      Pica.config.map.off('draw:poly-created', @renderLoadingSpinner)
    else
      Pica.config.map.on('draw:poly-created', @renderLoadingSpinner)
      @polygonView = @area.drawNewPolygonView(
        success: () =>
          @removeNewPolygonView()
          @template = JST['area']
        error: (xhr, textStatus, errorThrown) =>
          alert("Can't save polygon: #{errorThrown}")
      )

  removeNewPolygonView: ->
    if @polygonView?
      @polygonView.close()
      delete @polygonView

  handlePolygonClick: (polygon, event) ->
    new Backbone.Views.PolyActionsView(
      polygon: polygon
      event: event
    )

  deleteArea: (event) ->
    

  resultsToObj: ->
    if @area.get('results')?
      results =
        sum: {}
        habitats: {}

      compareByName = (name) ->
        (obj) ->
          obj.display_name == name

      values =
        carbon: _.find(@area.get('results'), compareByName("Carbon")).value_json.rows
        area: _.find(@area.get('results'), compareByName("Area")).value_json.rows
        percentage: _.find(@area.get('results'), compareByName("Percentage")).value_json.rows

      _.each values, (habitats, operation) ->
        _.each habitats, (habitat) ->
          results.habitats[habitat.habitat] ||= {}
          results.habitats[habitat.habitat][operation] = habitat[operation]

          results.sum[operation] ||= 0
          results.sum[operation]  += habitat[operation]

      results.sum.human_emissions = _.find(@area.get('results'), compareByName("Emissions")).value_json.time

      return results
    else
      return {}

  renderLoadingSpinner: (e) =>
    @template = JST['area_loading']
    @render()

  render: =>
    @$el.html(@template(area: @area, results: @resultsToObj()))
    return @

  onClose: ->
    @removeNewPolygonView()
    Pica.config.map.off('draw:poly-created', @renderLoadingSpinner)
    @showAreaPolygonsView.off("polygonClick", @handlePolygonClick)
    @showAreaPolygonsView.close()
    @area.off('sync', @render)
