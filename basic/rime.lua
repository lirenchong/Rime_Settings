-- select_character_processor: 以词定字
-- 详见 `lua/select_character.lua`

-- 需要以词定字插件打开第5行注释
select_character_processor = require("select_character")

function time_translator(input, seg)

-- Changelog 结合时间函数，用于日常写作及 Logseq 双向链接的日期引用
-- 日期 + 星期 + 时间
    if (input == "cl") then
        arr = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
        arr[0] = "Sunday"
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d "..arr[tonumber(os.date("%w"))].. " %H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("[[%Y-%m-%d "..arr[tonumber(os.date("%w"))].. "]] %H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("- %Y-%m-%d "..arr[tonumber(os.date("%w"))].. " %H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("- [[%Y-%m-%d "..arr[tonumber(os.date("%w"))].. "]] %H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("Changlog：%Y-%m-%d "..arr[tonumber(os.date("%w"))].. " %H:%M:%S"), ""))        
        yield(Candidate("date", seg.start, seg._end, os.date("Changlog：[[%Y-%m-%d "..arr[tonumber(os.date("%w"))].. "]] %H:%M:%S"), ""))        
    end

    if (input == "riqi") then
        arr = {"一","二","三","四","五","六"}
        arr[0] = "日"
        yield(Candidate("date", seg.start, seg._end, os.date("%Y 年 %m 月 %d 日"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y 年 %m 月 %d 日 星期"..arr[tonumber(os.date("%w"))]), ""))
    end

    if (input == "rq") then
        arr = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
        arr[0] = "Sunday"
        yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d_"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("[[%Y-%m-%d "..arr[tonumber(os.date("%w"))].. "]]"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%m 月 %d 日"), ""))
    end


-- 时间相关    
    if (input == "time") then
        yield(Candidate("date", seg.start, seg._end, os.date("%H:%M"), ""))        
        yield(Candidate("date", seg.start, seg._end, os.date("%H:%M:%S"), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%H 点 %M 分"), ""))        
        yield(Candidate("date", seg.start, seg._end, os.date("%H 点 %M 分 %S 秒"), ""))
    end

    if (input == "sj") then
        local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " ")
        cand.quality = 1
        yield(cand)
    end

    if (input == "uijm") then
       local cand = Candidate("time", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), " ")
       cand.quality = 1
       yield(cand)
    end


-- 星期相关
    if (input == "we") then
        arr = {"Mon","Tuesday","Wednesday","Thursday","Friday","Saturday"}
        arr[0] = "Sun"
        yield(Candidate("date", seg.start, seg._end, os.date(""..arr[tonumber(os.date("%w"))]), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("Today is "..arr[tonumber(os.date("%w"))]), "."))
    end

    if (input == "wee") then
        arr = {"一","二","三","四","五","六"}
        arr[0] = "日"
        yield(Candidate("date", seg.start, seg._end, os.date("星期"..arr[tonumber(os.date("%w"))]), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("今天星期"..arr[tonumber(os.date("%w"))]), ""))
        yield(Candidate("date", seg.start, seg._end, os.date("%Y 年 %m 月 %d 日 星期"..arr[tonumber(os.date("%w"))]), ""))
    end

 end

--- 过滤器：单字在先
    function single_char_first_filter(input)
        local l = {}
        for cand in input:iter() do
        if (utf8.len(cand.text) == 1) then
            yield(cand)
        else
            table.insert(l, cand)
        end
        end
        for i, cand in ipairs(l) do
        yield(cand)
        end
    end

