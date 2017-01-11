window.JST ||= {}

window.JST['tabs'] = _.template("""
  <div class="tabs">
    <% _.each(workspace.areas, function(area, index) { %>
      <% current_class = (area == workspace.currentArea) ? 'active' : '' %>
      <div data-area-id="<%= index %>" class="tabs__tab <%= current_class %>"><%= area.get('name') %></div>
    <% }); %>

    <% if (workspace.areas.length < 3) { %>
      <div class="tabs__tab tabs__tab--new" id="add-area"><i class="fa fa-plus-circle"></i></div>
    <% } %>
  </div>

  <div id="area">
  </div>
""")
