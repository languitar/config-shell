function makej --wraps make
    if test -f /proc/cpuinfo
        make -j (cat /proc/cpuinfo | grep processor | wc | sed -r 's/^ +([0-9])+.*/\1/')
    else
        make -j (sysctl hw.ncpu | awk '{print $2}')
    end
end
