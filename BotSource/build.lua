local BCS_COMPILER = 'zt-bcc'

function IsWindows ()
    return package.config:sub(1,1) == '\\'
end

function IsProgramInPath (exec)
    local chkExec = 'command -v'
    local redirErr = '2>/dev/null'

    if IsWindows() then
        chkExec = 'where'
        redirErr = '2>nul'
    end

    local f = io.popen(chkExec .. ' ' .. exec .. ' ' .. redirErr)
    local result = f:read('*all')
    f:close()
    return result ~= ''
end

function POSIXPathToWin (str)
    return str:gsub('/', '\\')
end

function InvokeProgram (exec, args, fatal, path)
    local path = path or ''
    local fatal = fatal or false

    if (path == '') and not IsProgramInPath(exec) then
        path = os.getenv(string.gsub(string.upper(exec), '-', '_') .. '_PATH')
        if path == nil then
            return false
        end
    end

    if IsWindows() then
        exec = exec .. '.exe'

        path = POSIXPathToWin(path)
        args = POSIXPathToWin(args)
    end

    local cmd = path .. exec .. ' ' .. args
    local progHandle = io.popen(cmd, "r")
    local output = progHandle:read('*all')
    local res = progHandle:close()

    print(output)

    if fatal and not res then
        print(exec .. ' failed!')
        os.exit()
    end

    return res
end

function CopyFile (src, dst)
    local exec = 'cp'

    if IsWindows() then
        exec = 'copy'

        src = POSIXPathToWin(src)
        dst = POSIXPathToWin(dst)
    end

    return os.execute(exec .. ' ' .. src .. ' ' .. dst)
end

local defines = {...}

local m4Args = ' '
local bccArgs = ' '
for i,v in ipairs(defines) do
    m4Args = m4Args .. '--define=' .. v .. ' '
    bccArgs = bccArgs .. '-D ' .. v .. ' '
end

print('Compiling main BCS module...')
InvokeProgram(BCS_COMPILER, bccArgs .. 'BCS/TDBots.bcs ../acs/TDBots.o', true)

print('Verifying header file...')
if InvokeProgram(BCS_COMPILER, 'headers/TDBots.h.bcs headers/TDBots.o') then
    os.remove('headers/TDBots.o')
end

print('Compiling IWAD support modules...')
InvokeProgram(BCS_COMPILER, '-I headers/ BCS/IWADSupport/TDB_Doom.bcs ../acs/TDB_Doom.o', true)
InvokeProgram(BCS_COMPILER, '-I headers/ BCS/IWADSupport/TDB_Here.bcs ../acs/TDB_Here.o', true)
InvokeProgram(BCS_COMPILER, '-I headers/ BCS/IWADSupport/TDB_Hexn.bcs ../acs/TDB_Hexn.o', true)
InvokeProgram(BCS_COMPILER, '-I headers/ BCS/IWADSupport/TDB_Stri.bcs ../acs/TDB_Stri.o', true)

print('Preprocessing DECOM4...')
InvokeProgram('m4', m4Args .. 'DECOM4.dec > ../DECORATE.tdb', true)

print('Preprocessing and compiling BotScript...')

InvokeProgram('m4', m4Args .. 'tdbot_m4.botc > tdbot.botc', true)
InvokeProgram('botc', 'tdbot.botc ../tdbot', true, 'tools/')
os.remove('tdbot.botc')

CopyFile('../tdbot', '../crashbot.lump')
CopyFile('../tdbot', '../dfultbot.lump')
CopyFile('../tdbot', '../fatbot.lump')
CopyFile('../tdbot', '../humanbot.lump')
CopyFile('../tdbot', '../sausgbot.lump')
