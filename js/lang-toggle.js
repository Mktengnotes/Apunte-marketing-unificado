// Language toggle for bilingual gitbook (ES/EN)
// Polls until gitbook is available, then creates toolbar button directly
(function() {
  'use strict';

  var STORAGE_KEY = 'apunte-lang';
  var DATA_ORIG = 'data-orig-text';

  function getLang() {
    return localStorage.getItem(STORAGE_KEY) || 'es';
  }

  function setLang(lang) {
    localStorage.setItem(STORAGE_KEY, lang);
    applyLang(lang);
  }

  function applyLang(lang) {
    var i, j;
    // Toggle .lang-es / .lang-en blocks
    var esBlocks = document.querySelectorAll('.lang-es');
    var enBlocks = document.querySelectorAll('.lang-en');
    for (i = 0; i < esBlocks.length; i++) {
      esBlocks[i].style.display = (lang === 'es') ? 'block' : 'none';
    }
    for (i = 0; i < enBlocks.length; i++) {
      enBlocks[i].style.display = (lang === 'en') ? 'block' : 'none';
    }

    // Translate headers: pandoc puts data-en on the <div> wrapper, not the <h> tag
    var sections = document.querySelectorAll('div[data-en]');
    for (i = 0; i < sections.length; i++) {
      var div = sections[i];
      var h = div.querySelector('h1, h2, h3, h4');
      if (!h) continue;
      var anchorLink = h.querySelector('.anchor-section');
      if (!h.hasAttribute(DATA_ORIG)) {
        var sectionNum = h.querySelector('.header-section-number');
        var anchorText = sectionNum ? sectionNum.textContent : '';
        h.setAttribute(DATA_ORIG, h.textContent.replace(anchorText, '').trim());
      }
      var textToShow = (lang === 'en' && div.getAttribute('data-en'))
        ? div.getAttribute('data-en')
        : h.getAttribute(DATA_ORIG);
      var children = h.childNodes;
      for (j = children.length - 1; j >= 0; j--) {
        if (children[j].nodeType === 3) h.removeChild(children[j]);
      }
      var titleNode = document.createTextNode(textToShow + ' ');
      if (anchorLink) {
        h.insertBefore(titleNode, anchorLink);
      } else {
        h.appendChild(titleNode);
      }
    }

    // Static translations for cross-page TOC entries (chapter titles, etc.)
    var PAGE_TRANSLATIONS = {
      'index.html': 'Foreword',
      'cap-regresion.html': 'Regression Models',
      'cap-probabilisticos.html': 'Probabilistic Models',
      'cap-estructurales.html': 'Structural Models',
      'referencias.html': 'References',
      'anexo-formulas.html': 'Useful Formulas'
    };

    // Translate TOC entries
    var tocLinks = document.querySelectorAll('.book-summary ul.summary li a');
    for (i = 0; i < tocLinks.length; i++) {
      var link = tocLinks[i];
      var href = link.getAttribute('href') || '';

      // Save original text
      if (!link.hasAttribute(DATA_ORIG)) {
        var num = link.querySelector('b');
        var numText = num ? num.textContent : '';
        link.setAttribute(DATA_ORIG, link.textContent.replace(numText, '').trim());
      }

      var enText = null;

      // Try to resolve from current page DOM (anchored links)
      var hashIdx = href.lastIndexOf('#');
      if (hashIdx >= 0) {
        var anchorId = decodeURIComponent(href.substring(hashIdx + 1));
        if (anchorId) {
          var target = document.getElementById(anchorId);
          if (target && target.hasAttribute('data-en')) {
            enText = target.getAttribute('data-en');
          }
        }
      } else if (PAGE_TRANSLATIONS[href]) {
        // Cross-page link without anchor — use static map
        enText = PAGE_TRANSLATIONS[href];
      }

      if (!enText) continue;

      var text = (lang === 'en') ? enText : link.getAttribute(DATA_ORIG);
      var ch = link.childNodes;
      for (j = ch.length - 1; j >= 0; j--) {
        if (ch[j].nodeType === 3) link.removeChild(ch[j]);
      }
      link.appendChild(document.createTextNode(text));
    }

    // Update button label
    var btnLabel = document.getElementById('lang-toggle-label');
    if (btnLabel) {
      btnLabel.textContent = (lang === 'es') ? 'EN' : 'ES';
    }
  }

  function createButton() {
    if (document.getElementById('lang-toggle-label')) return true;
    // Gitbook creates <a class="btn pull-right"> directly inside .book-header
    // We need to find an existing button to insert before, or the header itself
    var header = document.querySelector('.book-header');
    if (!header) return false;
    var existing = header.querySelector('a.btn');
    if (!existing) return false; // gitbook toolbar buttons not yet created

    var btn = document.createElement('a');
    btn.className = 'btn pull-right';
    btn.href = '#';
    btn.title = 'ES / EN';
    btn.innerHTML = '<i class="fa fa-language"></i> <span id="lang-toggle-label" style="font-weight:700;letter-spacing:1pt">' +
      (getLang() === 'es' ? 'EN' : 'ES') + '</span>';
    btn.addEventListener('click', function(ev) {
      ev.preventDefault();
      var newLang = (getLang() === 'es') ? 'en' : 'es';
      setLang(newLang);
    });

    // Insert before the first existing button
    header.insertBefore(btn, existing);
    return true;
  }

  function init() {
    if (createButton()) {
      applyLang(getLang());
    }
  }

  // Poll until the toolbar exists in the DOM
  var attempts = 0;
  var poll = setInterval(function() {
    attempts++;
    if (createButton()) {
      clearInterval(poll);
      applyLang(getLang());
    }
    if (attempts > 100) clearInterval(poll);
  }, 200);

  // Also try on DOMContentLoaded and load
  document.addEventListener('DOMContentLoaded', init);
  window.addEventListener('load', init);
})();
