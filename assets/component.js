App.Utils.renderer.multiplecollectionlink = function(v) {
  var cnt = Array.isArray(v) ? v.length : 0;
  let tooltip = [];
  if (cnt) {
    v.forEach(function(link) {
      tooltip.push(link.display || link.link)
    });
  }
  return '<span class="uk-badge" title="'+tooltip.join(', ')+'" data-uk-tooltip>'+(cnt+(cnt == 1 ? ' Link' : ' Links'))+'</span>';
};