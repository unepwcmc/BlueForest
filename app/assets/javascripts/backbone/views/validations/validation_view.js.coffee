BlueCarbon.Views.Validations ||= {}

class BlueCarbon.Views.Validations.ValidationView extends Backbone.View
  template: JST["backbone/templates/validations/validation"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
