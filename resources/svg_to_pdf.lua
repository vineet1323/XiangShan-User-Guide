if FORMAT:match 'latex' then
    function Image (elem)
       elem.src = elem.src:gsub("%.svg$", ".pdf")
       return elem
    end
end
