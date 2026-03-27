-- Lua filter for PDF: keep only Spanish content, remove English blocks
-- Handles ::: {.lang-en} and ::: {.lang-es} fenced divs

function Div(el)
  if el.classes:includes("lang-en") then
    -- Remove English content entirely
    return {}
  elseif el.classes:includes("lang-es") then
    -- Unwrap Spanish content (keep blocks, remove wrapper)
    return el.content
  elseif el.classes:includes("rmdnote") then
    -- Wrap rmdnote content in LaTeX tcolorbox environment
    local result = {}
    table.insert(result, pandoc.RawBlock("latex", "\\begin{rmdnote}"))
    for _, block in ipairs(el.content) do
      table.insert(result, block)
    end
    table.insert(result, pandoc.RawBlock("latex", "\\end{rmdnote}"))
    return result
  end
end

-- Strip data-en attributes from headers (cosmetic, avoids stray text)
function Header(el)
  el.attributes["data-en"] = nil
  return el
end

-- Convert display math with (\#eq:label) to \begin{equation}...\end{equation}
-- so that bookdown can number them properly in PDF output.
-- Pandoc sees $$...(\#eq:label)$$ as DisplayMath with literal (\#eq:...) text.
function Math(el)
  if el.mathtype == "DisplayMath" then
    local label = el.text:match("%(\\#eq:[-/%w]+%)")
    if label then
      -- Remove the (\#eq:...) from the math, keep rest
      local body = el.text:gsub("%s*%(\\#eq:[-/%w]+%)", "")
      body = body:gsub("%s+$", "")
      -- Wrap in equation environment; bookdown will post-process the \label
      local tex = "\\begin{equation}\n" .. body .. "\n" .. label .. "\n\\end{equation}"
      return pandoc.RawInline("latex", tex)
    end
  end
end
