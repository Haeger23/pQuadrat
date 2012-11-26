var dom2js = function(node) {

	var	js = {};

	// append a value
	function add(name, value) {
		if (js[name]) {
			if (js[name].constructor != Array) {
				js[name] = [js[name]];
			}
			js[name][js[name].length] = value;
		}
		else {
			js[name] = value;
		}
	};
	
	// element attributes
	var c, cn;
	for (c = 0; cn = node.attributes[c]; c++) {
		add(cn.name, cn.value);
	}
	
	// child elements
	for (c = 0; cn = node.childNodes[c]; c++) {
		if (cn.nodeType == 1) {
			if (cn.childNodes.length == 1 && cn.firstChild.nodeType == 3) {
				// text value
				add(cn.nodeName, cn.firstChild.nodeValue);
			}
			else {
				// sub-object
				add(cn.nodeName, dom2js(cn));
			}
		}
	}

	return js;

}