App.Utils.renderer.multiplecollectionlink = function(v, field) {
  var viewMode = field.options && field.options.viewMode || "tooltip";

  var links = Array.isArray(v) ? v : [v];
  var cnt = links.length;
  var output = "";
  var items = [];

  if (viewMode === 'tooltip') {
    links.forEach(function(link) {
      items.push(link.display || link.link || "n/a")
    });
    output = '<span class="uk-badge" title="'+items.join(', ')+'" data-uk-tooltip>'+(cnt+(cnt == 1 ? ' Link' : ' Links'))+'</span>';
  } else {
    links.forEach(function(link, idx) {
      if (link.display && link.link && link._id) {
        var url = App.route('/collections/entry/'+link.link+'/'+link._id);
        items.push('<a target="_blank" class="uk-text-small uk-button-small" href="'+url+'">'+link.display+'</a>');
      } else {
        items.push("")
      }
    });
    output = items.join("<br/>");
  }

  return output;
};
