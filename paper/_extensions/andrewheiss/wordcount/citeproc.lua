-- Check if a citekey looks like a crossref
function is_crossref(id, meta)
  -- These are all of Quarto's built-in crossref prefixes: 
  -- https://quarto.org/docs/authoring/cross-references.html#reserved-prefixes
  -- 
  -- This checks to see if it's one of those
  local known_prefixes = {
    "fig", "tbl", "lst", "tip", "nte", "wrn", "imp", "cau", "thm", "lem", "cor",
    "prp", "cnj", "def", "exm", "exr", "sol", "rem", "alg", "eq", "sec"
  }
  for _, prefix in ipairs(known_prefixes) do
    if id:match("^" .. prefix .. "%-") then
      return true
    end
  end

  -- Users can specify their own custom crossref types:
  -- https://quarto.org/docs/authoring/cross-references-custom.html
  -- 
  -- This checks the document metadata and to see if there's a crossref entry 
  -- and then extracts the key prefix if present
  if meta.crossref and meta.crossref.custom then
    local custom = meta.crossref.custom
    -- custom could be a list of tables
    for i = 1, #custom do
      local item = custom[i]
      if item.key then
        local key = pandoc.utils.stringify(item.key)
        if id:match("^" .. key .. "%-") then
          return true
        end
      end
    end
  end

  return false
end

-- Run citeproc, but first protect/preserve all the cross references
function Pandoc (doc)
  -- Remove crossref keys before running citeproc
  local crossrefs = {}
  doc = doc:walk({
    Cite = function(el)
      if is_crossref(el.citations[1].id, doc.meta) then
        -- Store the cite element with a unique placeholder
        local placeholder = "CROSSREF" .. #crossrefs .. "PLACEHOLDER"
        table.insert(crossrefs, el)
        return pandoc.Str(placeholder)
      end
    end
  })

  -- Run citeproc
  doc = pandoc.utils.citeproc(doc)

  -- Put crossref keys back now that citations have been handled
  doc = doc:walk({
    Str = function(el)
      local match = el.text:match("CROSSREF(%d+)PLACEHOLDER")
      if match then
        return crossrefs[tonumber(match) + 1]
      end
    end
  })

  return doc
end
